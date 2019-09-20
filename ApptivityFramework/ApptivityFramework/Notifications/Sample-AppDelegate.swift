//
//  Sample-AppDelegate.swift
//  ApptivityFramework
//
//  Created by Jason Khong on 10/28/16.
//  Copyright © 2016 Apptivity Lab. All rights reserved.
//

import UIKit

class SampleAppDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        // Setup APNS
        application.setupRemoteNotifications()

        return true
    }
}

extension SampleAppDelegate {
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        APNSController.shared.receiveRemoteNotification(userInfo: userInfo)
        application.applicationIconBadgeNumber = APNSController.shared.unreadBadgeCount()
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokenString: String = deviceToken.hexadecimalString()
        // TODO: Register endpoint with deviceTokenString
        print("Register on server: \(deviceTokenString)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
    }
}

