//
//  LaunchViewController.swift
//  SamsungKato
//
//  Created by Aarief on 22/09/2017.
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import UIKit
import MBProgressHUD
import UserNotifications

internal let hasShownWalkthroughKey: String = "has_shown_walkthrough"

internal class LaunchViewController: UIViewController, UNUserNotificationCenterDelegate {
     private var hasShownWalkthrough: Bool {
         return Installation.current().valueForKey(hasShownWalkthroughKey) as? Bool ?? false
     }

    private var shouldOpenActivityController: Bool = false

    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var progressStackView: UIStackView!
    @IBOutlet private weak var okButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.handlingInvalidSession), name: NSNotification.Name.SessionInvalid, object: nil)
        UNUserNotificationCenter.current().delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.errorLabel.isHidden = true
        self.okButton.isHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.showNext()
    }

    @IBAction private func showNext() {
        guard AccountController.shared.profile != nil else {
            self.launchAuthMenu()
            return
        }

        if AccountController.shared.needUpdateEmailAddress {
            self.launchUpdateEmailViewController()
            return
        }

        guard self.hasShownWalkthrough else {
            self.launchWalkthrough()
            return
        }

        if AccountDataController.shared.getAccounts(profile: AccountController.shared.profile).isEmpty {
            self.loadDataFromServer()
            return
        }

        AccountController.shared.selectedAccount = AccountDataController.shared.getAccounts(profile: AccountController.shared.profile).first
        if let token = Installation.current().valueForKey("deviceToken") as? String,
            let account = AccountController.shared.selectedAccount,
            let notificationSetting = NotificationSettingDataController.shared.getNotificationSettings(account: account).first {
            notificationSetting.deviceToken = token
            NotificationSettingDataController.shared.updateNotificationSetting(notificationSetting: notificationSetting) { _ in }
        }

        self.launchMain()
    }

    private func launchAuthMenu() {
        guard let landingVC = UIStoryboard(name: "AuthMenu", bundle: nil).instantiateInitialViewController() else {
            return
        }

        landingVC.modalTransitionStyle = .crossDissolve
        self.present(landingVC, animated: true, completion: nil)
    }

    private func launchWalkthrough() {
        guard let walkthroughVC = UIStoryboard(name: "Walkthrough", bundle: nil).instantiateInitialViewController() else {
            return
        }
        self.present(walkthroughVC, animated: true, completion: nil)
    }

    private func launchUpdateEmailViewController() {
        let changeMenuVc: ChangeEmailViewController = UIStoryboard(name: TimeSelfCareStoryboard.authMenu.filename, bundle: nil).instantiateViewController()
        self.present(changeMenuVc, animated: true, completion: nil)
    }

    private func launchMain() {
        guard let initialViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() else {
            return
        }

        initialViewController.modalTransitionStyle = .crossDissolve
        self.present(initialViewController, animated: true) {
            if self.shouldOpenActivityController {
               self.shouldOpenActivityController = false
                var currentViewController: UIViewController = self
                while let presentedController = currentViewController.presentedViewController {
                    currentViewController = presentedController
                }

                let activityVC: ActivityViewController = UIStoryboard(name: TimeSelfCareStoryboard.activity.filename, bundle: nil).instantiateViewController()
                currentViewController.presentNavigation(activityVC, animated: true)
            }
        }
    }

    private func loadDataFromServer() {
        self.progressStackView.isHidden = false

        AccountDataController.shared.loadAccounts { (accounts: [Account], error: Error?) in
            guard error == nil else {
                self.progressStackView.isHidden = true
                self.errorLabel.text = error?.localizedDescription
                self.errorLabel.isHidden = false
                self.okButton.isHidden = false
                AuthUser.current?.logout()
                return
            }
            let totalAccountsCount = accounts.count
            var serviceCount = 0
            accounts.forEach { (account: Account) in
                ServiceDataController.shared.loadServices(accountNo: account.accountNo) { (_: [Service], error: Error?) in
                    if error != nil {
                        self.progressStackView.isHidden = true
                        self.errorLabel.text = error?.localizedDescription
                        self.errorLabel.isHidden = false
                        self.okButton.isHidden = false
                        AuthUser.current?.logout()
                        return
                    }
                    serviceCount += 1
                    if serviceCount == totalAccountsCount {
                        let service = ServiceDataController.shared.getServices(account: account).first { $0.category == .broadband || $0.category == .broadbandAstro }
                        SsidDataController.shared.loadSsids(account: account, service: service) { _, _ in
                        }
                        self.progressStackView.isHidden = true
                        self.showNext()
                    }
                }

                ActivityDataController.shared.loadActivities(account: account) { (_, _) in
                }
            }
        }
    }

    @objc
    private func handlingInvalidSession() {
        AuthUser.current?.logout()
        self.showNext()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }

    // Detect user tap on push notification.
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        guard let account = AccountController.shared.selectedAccount else {
            self.shouldOpenActivityController = true
            return
        }

        var currentViewController: UIViewController = self
        while let presentedController = currentViewController.presentedViewController {
            currentViewController = presentedController
        }

        let openActivity = {
            let activityVC: ActivityViewController = UIStoryboard(name: TimeSelfCareStoryboard.activity.filename, bundle: nil).instantiateViewController()
            currentViewController.presentNavigation(activityVC, animated: true)
        }

        guard
            let userInfo: [String: Any] = response.notification.request.content.userInfo as? [String: Any],
            var activityJson = userInfo["activity"] as? [String: Any]
        else {
                openActivity()
                return
        }

        activityJson["account_no"] = account.accountNo
        activityJson["profile_username"] = AccountController.shared.profile.username

        guard let activity = Activity(with: activityJson) else {
            openActivity()
            return
        }

        switch activity.type {
        case .rewards:
            let rewardVC: RewardViewController = UIStoryboard(name: TimeSelfCareStoryboard.reward.filename, bundle: nil).instantiateViewController()
            self.presentNavigation(rewardVC, animated: true)
        default:
            openActivity()
        }
    }
}
