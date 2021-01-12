//
//  Notifications.swift
//  ApptivityFramework
//
//  Created by Jason Khong on 10/28/16.
//  Copyright © 2016 Apptivity Lab. All rights reserved.
//

import Foundation
import UserNotifications

public protocol APNSControllerDelegate {
    func dataItemForNotification(userInfo: [AnyHashable : Any]) -> GeneralNotification?
}

public extension APNSControllerDelegate {
    public func dataItemForNotification(userInfo: [AnyHashable : Any]) -> GeneralNotification? {
        var notification: GeneralNotification?
        if let _ = userInfo["aps"] {
            notification = AlertNotification(userInfo: userInfo)
        } else if let _ = userInfo["content-available"] {
            notification = SilentNotification(userInfo: userInfo)
        }
        return notification
    }
}

/// Framework to handle Push Notifications for in-app alerts & history
/// Adds in read/unread status
///
/// - Important
///   - Push Notifications only work on actual device, not the simulator
open class APNSController {
    /// Singleton
    open static let shared = APNSController()
    public private(set) var recentNotifications: [GeneralNotification] = []
    public var dataDelegate: APNSControllerDelegate? {
        didSet {
            if self.dataDelegate != nil {
                if let data = try? Data(contentsOf: datafile) {
                    self.cachedNotifications.removeAll()
                    self.recentNotifications.removeAll()
                    if let historyJson: [[String: Any]] = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String : Any]] {
                        for item in historyJson {
                            receiveRemoteNotification(userInfo: item, writeToFile: false)
                        }
                    }
                }
            }
        }
    }
    
    // Storage and caching of notifications
    let folder: URL
    let datafile: URL
    public private(set) var cachedNotifications: [[AnyHashable: Any]] = [] {
        didSet {
            UIApplication.shared.applicationIconBadgeNumber = self.unreadBadgeCount()
        }
    }

    private init() {
        self.folder = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first!
        self.datafile = self.folder.appendingPathComponent("pushhistory.json")
        self.dataDelegate = UIApplication.shared
    }

    /// Handle newly received notifications, save to JSON file
    public func receiveRemoteNotification(userInfo: [AnyHashable : Any], writeToFile: Bool = true, unread: Bool = true) {

        var unreadNotification = userInfo
        
        // Write to file as unread notification
        if writeToFile {
            unreadNotification["unread"] = unread
            unreadNotification["uuid"] = UUID().uuidString
            unreadNotification["timestamp"] = Date().string(usingFormat: "yyyy-MM-dd'T'HH:mm:ss ZZZ", usingTimeZone: TimeZone(abbreviation: "GMT")!, localeIdentifier: "en_US_POSIX")
        }
        
        cachedNotifications.append(unreadNotification)

        if writeToFile { self.writeToFile() }
        
        // Save a GeneralNotification to the list
        if let alert = self.dataDelegate?.dataItemForNotification(userInfo: unreadNotification) {
            self.recentNotifications.append(alert)
        }
    }
        
    /// Retrieve number of unread notifications
    public func unreadBadgeCount() -> Int {
        var totalUnread: Int = 0
        for userInfo in cachedNotifications {
            if ((userInfo["unread"] as? Bool) ?? false) == true {
                totalUnread = totalUnread + 1
            }
        }
        return totalUnread
    }
    
    public func deleteNotification(notification: GeneralNotification) {
        // Update storage
        var existingNotifications: [[AnyHashable: Any]] = []
        for var userInfo in cachedNotifications {
            if (userInfo["uuid"] as? String) ?? "" == notification.uuid {
                continue
            }
            existingNotifications.append(userInfo)
        }
        
        cachedNotifications = existingNotifications
        writeToFile()
        
        if let index = self.recentNotifications.index(of: notification) {
            self.recentNotifications.remove(at: index)
        }
    }

    public func deleteAllNotifications() {
        self.cachedNotifications = []
        writeToFile()
        self.recentNotifications.removeAll(keepingCapacity: false)
    }
    
    /// Mark as read
    public func markAsRead(notification: GeneralNotification) {
        // notification.unread = false
        
        // Update storage
        var existingNotifications: [[AnyHashable: Any]] = []
        for var userInfo in cachedNotifications {
            if (userInfo["uuid"] as? String) ?? "" == notification.uuid {
                userInfo["unread"] = false
            }
            existingNotifications.append(userInfo)
        }
        
        cachedNotifications = existingNotifications
        writeToFile()
    }

    /// Mark all read
    public func markAllRead() {
        for notification in self.recentNotifications {
            (notification as? AlertNotification)?.unread = false
        }
        
        // Update storage
        var readNotifications: [[AnyHashable: Any]] = []
        for var userInfo in cachedNotifications {
            userInfo["unread"] = false
            readNotifications.append(userInfo)
        }
        
        cachedNotifications = readNotifications
        writeToFile()
    }
    
    private func writeToFile() {
        do {
            let data: Data? = try? JSONSerialization.data(withJSONObject: cachedNotifications, options: .prettyPrinted)
            try data?.write(to: datafile)
            
            print("Saved to \(datafile.absoluteString)")
        } catch {
            print("Unable to save to file")
        }
        _ = self.unreadBadgeCount()
    }
}

extension APNSController {
    // MARK: - Local Notifications
    // TODO: Save in JSON file
    public func addLocalNotification(_ fireDate: Date, title: String, message: String, identifier: String, completion: ((_ error: Error?) -> Void)?) {
        if #available(iOS 10.0, *) {
            let notificationContent = UNMutableNotificationContent()
            notificationContent.title = title
            notificationContent.body = message
            notificationContent.sound = UNNotificationSound.default()
            
            let dateComponents: DateComponents = Calendar.current.dateComponents([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day, Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second], from: fireDate)
            let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            let notificationRequest = UNNotificationRequest(identifier: identifier, content: notificationContent, trigger: notificationTrigger)
            UNUserNotificationCenter.current().add(notificationRequest, withCompletionHandler: { (error: Error?) in
                completion?(error)
            })
        } else {
            // Fallback on earlier versions
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound], categories: nil))
            let notification: UILocalNotification = UILocalNotification()
            notification.userInfo = ["identifier": identifier]
            notification.alertBody = message
            notification.fireDate = fireDate
            UIApplication.shared.scheduleLocalNotification(notification)
        }
    }
    
    public func removePendingLocalNotification(identifiersForEventToRemove: [String]) {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiersForEventToRemove)
        } else {
            guard let localNotifications: [UILocalNotification] = UIApplication.shared.scheduledLocalNotifications else {
                return
            }
            
            for localNotification in localNotifications {
                if let identifier: String =  localNotification.userInfo?["identifier"] as? String {
                    for identifierForEventToRemove in identifiersForEventToRemove {
                        if identifierForEventToRemove == identifier {
                            UIApplication.shared.cancelLocalNotification(localNotification)
                            break
                        }
                    }
                }
            }
        }
    }
    
    public func createSampleData(_ sampleData: [[AnyHashable: Any]]?) {
        if let sampleData = sampleData {
            for sample in sampleData {
                receiveRemoteNotification(userInfo: sample)
            }
        } else {
            let sample1: [AnyHashable: Any] = ["aps": ["alert": "Hello from SNS!"]]
            let sample2: [AnyHashable: Any] = ["aps": ["alert": ["title": "Exciting push title!", "body": "This is a normal mundane push notification message body"]]]
            receiveRemoteNotification(userInfo: sample1)
            receiveRemoteNotification(userInfo: sample2)
        }
        
        let calendar: Calendar = Calendar.current
        var dateComponent: DateComponents = DateComponents()
        dateComponent.minute = 1
        let futureDate: Date = calendar.date(byAdding: dateComponent, to: Date())!
        APNSController.shared.addLocalNotification(futureDate,title: "This is a sample local notification.", message: "Hello", identifier: "hello_lesson_identifier", completion: {(error: Error?) in
            if let error = error {
                debugPrint(error.localizedDescription)
            }
        })
        //        APNSController.shared.removePendingLocalNotification(identifiersForEventToRemove: ["hello_lesson_identifier"])
    }
}
