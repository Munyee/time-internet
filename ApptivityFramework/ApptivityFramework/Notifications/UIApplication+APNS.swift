//
//  UIApplication+APNS.swift
//  ApptivityFramework
//
//  Created by Jason Khong on 10/28/16.
//  Copyright © 2016 Apptivity Lab. All rights reserved.
//

import UIKit
import UserNotifications

extension UIApplication {
    public func setupRemoteNotifications() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [UNAuthorizationOptions.alert, UNAuthorizationOptions.badge, UNAuthorizationOptions.sound], completionHandler: { (granted: Bool, error: Error?) in
                if granted {
                    let generalCategory = UNNotificationCategory(identifier: "GENERAL",
                                                                 actions: [],
                                                                 intentIdentifiers: [],
                                                                 options: .customDismissAction)
                    let center = UNUserNotificationCenter.current()
                    center.setNotificationCategories([generalCategory])

                    DispatchQueue.main.async {
                        self.registerForRemoteNotifications()
                    }
                }
            })
        } else {
            // Fallback on earlier versions
            self.registerUserNotificationSettings(UIUserNotificationSettings(types: [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound], categories: nil))
            self.registerForRemoteNotifications()
        }
    }
}

extension UIApplication: APNSControllerDelegate {}
