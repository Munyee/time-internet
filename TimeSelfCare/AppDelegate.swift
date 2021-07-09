//
//  AppDelegate.swift
//  AppSkeleton
//
//  Created by AppLab on 01/11/2017.
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import UIKit
import ApptivityFramework
import TimeSelfCareData
import UserNotifications
import Firebase
import Smartlook
import HwMobileSDK

extension NSNotification.Name {
    static let NotificationDidReceive: NSNotification.Name = NSNotification.Name(rawValue: "NotificationDidReceive")
}

internal class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        AuthUser.authDelegate = AccountController.shared
        AuthUser.enableAnonymousUser(with: LocalAnonymousProvider())
        AuthUser.enableProfiles(with: AccountController.shared)

        application.setupRemoteNotifications()
        APNSController.shared.dataDelegate = self
        
        var appId = "e7b242c4-d7f0-4442-ac69-14af0b14ff91"
        var appKey = "8c2c04e4-0080-44ba-b4de-dc0fa8af2cc2"

        #if DEBUG
            appId = "23bb7b7f-0da4-4837-b4c4-a233c251adad"
            appKey = "590e83e4-c424-4f02-9cd0-e7dab8db8320"
        #else
            let smartlookConfig = Smartlook.SetupConfiguration(key: "73e0b72d49d303d9c7e365bbfbcffde6e0e5dabc")
            Smartlook.setupAndStartRecording(configuration: smartlookConfig)
        #endif

        let freshchatConfig: FreshchatConfig = FreshchatConfig(appID: appId, andAppKey: appKey)
        Freshchat.sharedInstance().initWith(freshchatConfig)
        
        self.applyAppearance()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
//        HuaweiHelper.shared.checkIsLogin { result in
//            if !result.isLogined {
//                self.HuaweiLogin()
//            }
//        }
    }
    
//    func HuaweiLogin() {
//        HuaweiHelper.shared.login { _ in
//            HuaweiHelper.shared.registerErrorMessageHandle { msg in
//                self.checkIsKick()
//            }
//        }
//    }
    
    func checkIsKick() {
        HuaweiHelper.shared.registerErrorMessageHandle { msg in
            print(msg.errorCode)
            if msg.errorCode == "403" {
//                self.HuaweiLogin()
            }
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

extension AppDelegate {

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        var userInfo = userInfo
        if var activityJson = userInfo["activity"] as? [String: Any] {
            activityJson["account_no"] = AccountController.shared.selectedAccount?.accountNo
            guard let username = AccountController.shared.profile?.username else {
                return
            }
            activityJson["profile_username"] = username
            userInfo["activity"] = activityJson
        }

        APNSController.shared.receiveRemoteNotification(userInfo: userInfo)
        UIApplication.shared.applicationIconBadgeNumber = APNSController.shared.unreadBadgeCount()
        NotificationCenter.default.post(name: NSNotification.Name.NotificationDidReceive, object: nil)

        completionHandler(UIBackgroundFetchResult.newData)
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

        Freshchat.sharedInstance().setPushRegistrationToken(deviceToken)

        let token = deviceToken.hexadecimalString()
        debugPrint("Device Token: \(token)")

        Installation.current().set(token, forKey: "deviceToken")
        guard
            let account = AccountController.shared.selectedAccount,
            let notificationSetting = NotificationSettingDataController.shared.getNotificationSettings(account: account).first
        else {
            return
        }
        notificationSetting.deviceToken = token
        NotificationSettingDataController.shared.updateNotificationSetting(notificationSetting: notificationSetting)
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        debugPrint("Failed to register for remote notifications: ", error)
    }
}

extension AppDelegate: APNSControllerDelegate {
    func dataItemForNotification(userInfo: [AnyHashable : Any]) -> GeneralNotification? {
        let keys: [String] = userInfo.keys.map { (key: AnyHashable) -> String in
            key as? String ?? ""
        }

        if keys.contains("activity") {
            return ActivityNotification(userInfo: userInfo)
        }
        return AlertNotification(userInfo: userInfo)
    }
}

extension AppDelegate {
    func applyAppearance() {
        UIFont.setCustomFont()

        UINavigationBar.appearance().tintColor = UIColor.primary

        if let title2Font = UIFont.getCustomFont(family: "DIN", style: .title2) {
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: title2Font]
        }

        var backgroundImage: UIImage
        if #available(iOS 11.0, *) {
            backgroundImage = #imageLiteral(resourceName: "bg_navbar_44")
        } else {
            backgroundImage = #imageLiteral(resourceName: "bg_navbar_64")
        }
        
        UINavigationBar.appearance().setBackgroundImage(backgroundImage.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch), for: .default)

        if let subheadlineFont = UIFont.getCustomFont(family: "DIN", style: .subheadline) {
            UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: subheadlineFont], for: .normal)
            UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: subheadlineFont], for: .highlighted)
        }
    }
}
