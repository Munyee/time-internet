//
//  Installation.swift
//  ApptivityFramework
//
//  Created by Li Theen Kok on 21/06/2017.
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import Foundation

public class Installation {

    // swiftlint:disable implicitly_unwrapped_optional
    fileprivate static var _current: Installation!

    public let uuid: UUID
    public fileprivate(set) var lastLaunchedAt: Date?

    fileprivate var remoteNotificationsDeviceToken: Data?
    fileprivate var createdAt: Date?

    fileprivate var optionalValuesMap: [String : Any] = [:]

    fileprivate var subscriptions: [Subscription] = []
    fileprivate var pendingSubscriptions: [Subscription] = []

    fileprivate init(uuid: UUID) {
        self.uuid = uuid
        self.fetchExistingSubscriptions()
    }

    public func set(_ value: Any, forKey key: String) {
        self.optionalValuesMap[key] = value
        self.save()
    }

    public func valueForKey(_ key: String) -> Any? {
        return self.optionalValuesMap[key]
    }

    func toJson() -> [String : Any] {
        var json: [String : Any] = [
            "uuid": self.uuid.uuidString.lowercased(),
            "os": "iOS",
            "app_identifier": Bundle.main.bundleIdentifier ?? NSNull()
        ]

        if let bundleVersion = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String {
            json["build_number"] = bundleVersion
        }
        if let lastLaunchedAt = self.lastLaunchedAt,
            let timeZone: TimeZone = TimeZone(abbreviation: "GMT") {
            json["last_launched_at"] = lastLaunchedAt.string(usingFormat: "yyyy-MM-dd HH:mm:ss", usingTimeZone: timeZone, localeIdentifier: "en_US_POSIX")
        }

        if let remoteNotificationsDeviceToken = self.remoteNotificationsDeviceToken {
            json["push_token"] = remoteNotificationsDeviceToken.hexadecimalString()
        }

        for (key, value) in self.optionalValuesMap {
            if let dateValue = value as? Date, let timeZone: TimeZone = TimeZone(abbreviation: "GMT") {
                json[key] = dateValue.string(usingFormat: "yyyy-MM-dd HH:mm:ss", usingTimeZone: timeZone, localeIdentifier: "en_US_POSIX")
            } else {
                json[key] = value
            }

        }

        return json
    }

    public func save() {
        UserDefaults.standard.set(self.uuid.uuidString.lowercased(), forKey: "Installation.uuid")
        if let createdAt = self.createdAt,
            let timeZone: TimeZone = TimeZone(abbreviation: "GMT") {
            UserDefaults.standard.set(createdAt.string(usingFormat: "yyyy-MM-dd HH:mm:ss", usingTimeZone: timeZone, localeIdentifier: "en_US_POSIX"), forKey: "Installation.createdAt")
        }
        if let lastLaunchedAt = self.lastLaunchedAt,
            let timeZone: TimeZone = TimeZone(abbreviation: "GMT") {
            UserDefaults.standard.set(lastLaunchedAt.string(usingFormat: "yyyy-MM-dd HH:mm:ss", usingTimeZone: timeZone, localeIdentifier: "en_US_POSIX"), forKey: "Installation.lastLaunchedAt")
        }

        if let remoteNotificationsDeviceToken = self.remoteNotificationsDeviceToken {
            UserDefaults.standard.set(remoteNotificationsDeviceToken, forKey: "Installation.remoteNotificationsDeviceToken")
        } else {
            UserDefaults.standard.removeObject(forKey: "Installation.remoteNotificationsDeviceToken")
        }

        do {
            var optionalValuesJsonObject: [String : Any] = [:]
            for (key, value) in self.optionalValuesMap {
                if let dateValue = value as? Date, let timeZone: TimeZone = TimeZone(abbreviation: "GMT") {
                    optionalValuesJsonObject[key] = dateValue.string(usingFormat: "yyyy-MM-dd HH:mm:ss", usingTimeZone: timeZone, localeIdentifier: "en_US_POSIX")
                } else {
                    optionalValuesJsonObject[key] = value
                }
            }

            let optionalValuesJsonData = try JSONSerialization.data(withJSONObject: optionalValuesJsonObject, options: JSONSerialization.WritingOptions(rawValue: 0))
            let optionalValuesJsonString: String = String(data: optionalValuesJsonData, encoding: String.Encoding.utf8) ?? "{}"
            UserDefaults.standard.set(optionalValuesJsonString, forKey: "Installation.optionalValues")
        } catch {
            debugPrint("Error converting optional Installation values to JSON: \(error)")
        }

        UserDefaults.standard.synchronize()

        if self.createdAt != nil {
            InstallationController.shared()?.updateInstallation(self, completion: nil)
        }
    }

    func fetchExistingSubscriptions() {
        InstallationController.shared()?.fetchSubscriptionsForInstallation(self) { (subscriptions: [Installation.Subscription], error: Error?) in
            self.subscriptions.removeAll()
            self.subscriptions += subscriptions
        }
    }

    func handlePendingSubscriptions() {
        for subscription in self.pendingSubscriptions {
            InstallationController.shared()?.createSubscription(subscription, forInstallation: self) { (error: Error?) -> Void in
                if error == nil {
                    self.subscriptions.append(subscription)
                    if let index: Int = self.pendingSubscriptions.index(where: { $0 == subscription }) {
                        self.pendingSubscriptions.remove(at: index)
                    }
                }
            }
        }
    }

    func clearSubscriptions() {
        self.subscriptions.removeAll()
        self.pendingSubscriptions.removeAll()
    }

    public func associateWith(remoteNotificationsDeviceToken deviceToken: Data) {
        if self.createdAt != nil {
            self.remoteNotificationsDeviceToken = deviceToken
            InstallationController.shared()?.updateInstallation(self, completion: { (error: Error?) -> Void in
                if error != nil {
                    self.remoteNotificationsDeviceToken = nil
                } else {
                    if self.remoteNotificationsDeviceToken != nil && self.pendingSubscriptions.count > 0 {
                        self.handlePendingSubscriptions()
                    }
                    self.save()
                }
            })
        }
    }

    public func subscribeTo(interest: Interest) {
        let subscription: Installation.Subscription = Installation.Subscription(forInterest: interest)

        guard !self.subscriptions.contains(subscription) else {
            // Don't have to save on server
            return
        }
        guard !self.pendingSubscriptions.contains(subscription) else {
            // Subscription already queued
            return
        }

        self.pendingSubscriptions.append(subscription)
        if self.remoteNotificationsDeviceToken == nil {
            return
        }

        InstallationController.shared()?.createSubscription(subscription, forInstallation: self) { (error: Error?) -> Void in
            if error == nil {
                self.subscriptions.append(subscription)
                if let index: Int = self.pendingSubscriptions.index(where: { $0 == subscription }) {
                    self.pendingSubscriptions.remove(at: index)
                }
            }
        }
    }

    public static func enableRemoteNotifications(for application: UIApplication) {
        application.setupRemoteNotifications()
    }

    public func applicationDidBecomeActive(_ application: UIApplication) {
        self.lastLaunchedAt = Date()
        self.save()
    }
}

public extension Installation {
    public static func current() -> Installation {
        if Installation._current != nil {
            return Installation._current
        }

        if let installationUuidString = UserDefaults.standard.string(forKey: "Installation.uuid"),
            let uuid: UUID = UUID(uuidString: installationUuidString) {
            Installation._current = Installation(uuid: uuid)

            if let lastLaunchedAt: Date = UserDefaults.standard.string(forKey: "Installation.lastLaunchedAt")?.date(withFormat: "yyyy-MM-dd HH:mm:ss") {
                Installation._current.lastLaunchedAt = lastLaunchedAt
            }
            if let remoteNotificationsDeviceToken = UserDefaults.standard.data(forKey: "Installation.remoteNotificationsDeviceToken") {
                Installation._current.remoteNotificationsDeviceToken = remoteNotificationsDeviceToken
            }

            if let optionalValuesJsonString = UserDefaults.standard.string(forKey: "Installation.optionalValues"),
                let optionalValuesJsonData = optionalValuesJsonString.data(using: String.Encoding.utf8) {
                do {
                    if let jsonObject = try JSONSerialization.jsonObject(with: optionalValuesJsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : Any] {
                        for (key, value) in jsonObject {
                            if let dateValue = (value as? String)?.dateWithGMTTimeZone(format: "yyyy-MM-dd HH:mm:ss") {
                                Installation._current.optionalValuesMap[key] = dateValue
                            } else {
                                Installation._current.optionalValuesMap[key] = value
                            }
                        }
                    }
                } catch {
                    debugPrint("Error converting optional Installation values to JSON: \(error)")
                }
            }

            if let createdAt: Date = UserDefaults.standard.string(forKey: "Installation.createdAt")?.date(withFormat: "yyyy-MM-dd HH:mm:ss") {
                Installation._current.createdAt = createdAt
            } else {
                InstallationController.shared()?.createInstallation(Installation._current, completion: { (error: Error?) in
                    if error == nil {
                        Installation._current.createdAt = Date()
                        Installation._current.save()
                    }
                })
            }
        } else {
            Installation._current = Installation(uuid: UUID())

            UserDefaults.standard.set(Installation._current.uuid.uuidString.lowercased(), forKey: "Installation.uuid")
            UserDefaults.standard.synchronize()

            InstallationController.shared()?.createInstallation(Installation._current, completion: { (error: Error?) in
                if error == nil {
                    Installation._current.createdAt = Date()
                    Installation._current.save()
                }
            })
        }

        return Installation._current
    }

    public static func hasExistingInstallation() -> Bool {
        return UserDefaults.standard.string(forKey: "Installation.uuid") != nil
    }
}
