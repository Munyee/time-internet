//
//  LaunchViewController.swift
//  SamsungKato
//
//  Created by Aarief on 22/09/2017.
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import UserNotifications
import FirebaseRemoteConfig

internal let hasShownWalkthroughKey: String = "has_shown_walkthrough"
internal let dontAskAgainFlag: String = "dontAskAgain"

internal class LaunchViewController: UIViewController, UNUserNotificationCenterDelegate {
    var appVersionConfig: AppVersionModal!
    var remoteConfig: RemoteConfig!
    var message = ""

     private var hasShownWalkthrough: Bool {
         return Installation.current().valueForKey(hasShownWalkthroughKey) as? Bool ?? false
     }

    private var shouldOpenActivityController: Bool = false

    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var progressStackView: UIStackView!
    @IBOutlet private weak var okButton: UIButton!
    @IBOutlet private weak var versionUpdateView: UIView!
    @IBOutlet private weak var dontShowButton: UIButton!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var updateOrContinueButton: UIButton!
    
    @IBOutlet weak var alertTitleLabel: UILabel!
    @IBOutlet private weak var updateInfoTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.handlingInvalidSession), name: NSNotification.Name.SessionInvalid, object: nil)
        UNUserNotificationCenter.current().delegate = self
    }

    deinit {
        appVersionConfig = nil
        remoteConfig = nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.errorLabel.isHidden = true
        self.okButton.isHidden = true
        self.versionUpdateView.isHidden = true
        self.versionUpdateView.layer.cornerRadius = 10
        self.versionUpdateView.layer.borderWidth = 1
        self.versionUpdateView.layer.borderColor = UIColor.black.cgColor
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getFirebaseAppVersion()
    }

    func getFirebaseAppVersion() {
        if NetworkReachabilityManager()!.isReachable {
            remoteConfig = RemoteConfig.remoteConfig()
            let settings = RemoteConfigSettings()
            settings.minimumFetchInterval = 0
            remoteConfig.configSettings = settings
            remoteConfig.setDefaults(fromPlist: "GoogleService-Info")
            remoteConfig.fetch(withExpirationDuration: 3600) { (status, error) -> Void in
                if status == .success {
                    print("Config fetched!")
                    self.remoteConfig.activate(completionHandler: { (error) in
                        self.appVersionConfig = AppVersionModal(dictionary: (self.remoteConfig["app_init"].jsonValue as? NSDictionary)!)
                        DispatchQueue.main.async { self.checkAppVersion() }
                    })
                } else {
                    self.showNext()
                    print("Config not fetched")
                    print("Error: \(error?.localizedDescription ?? "No error available.")")
                }
            }
        } else {
            let alert = UIAlertController(title:"", message: "No Internet Connection", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "RETRY", style: .cancel, handler: { (_) in
                self.getFirebaseAppVersion()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func checkAppVersion() {
        guard
            let bundleVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String,
            let currentInstalledVersion = Int(bundleVersion),
            let majorVersion = Int(self.appVersionConfig.major),
            let minorVersion = Int(self.appVersionConfig.minor),
            let latestVersion = Int(self.appVersionConfig.latest),
            let majorTitle = self.appVersionConfig.major_title as? String,
            let majorText = self.appVersionConfig.major_text as? String,
            let minorTitle = self.appVersionConfig.minor_title as? String,
            let minorText = self.appVersionConfig.minor_text as? String else {
            return
        }
        
        if currentInstalledVersion < latestVersion {
            if currentInstalledVersion < majorVersion {
                print("Major Version update")
                showAppVersionWithMajorUpdate(messageTitle:majorTitle, messageBody: majorText)
            } else
                if currentInstalledVersion < minorVersion {
                print("Minor Version update")
                showAppVersionWithMinorUpdate(messageTitle:minorTitle, messageBody: minorText)
            } else if currentInstalledVersion < latestVersion {
                print("Latest Version update")
                showAppVersionWithLatestUpdate()
            }
        } else {
            print("No update")
            self.versionUpdateView.isHidden = true
            self.showNext()
        }
    }
    
    func showAppVersionWithMajorUpdate(messageTitle: String, messageBody:String ) {
        self.versionUpdateView.isHidden = false
        self.dontShowButton.isHidden = true
        self.alertTitleLabel.text = messageTitle
        self.updateInfoTextView.text = messageBody
    }
    
    func showAppVersionWithMinorUpdate(messageTitle: String, messageBody:String ) {
        if UserDefaults.standard.bool(forKey:dontAskAgainFlag) {
            self.versionUpdateView.isHidden = true
            self.dontShowButton.isHidden = true
            self.showNext()
        }else {
            self.versionUpdateView.isHidden = false
            self.dontShowButton.isHidden = false
        }
        self.alertTitleLabel.text = messageTitle
        self.updateInfoTextView.text = messageBody
    }
    
    func showAppVersionWithLatestUpdate() {
        self.versionUpdateView.isHidden = false
        self.dontShowButton.isHidden = true
        self.alertTitleLabel.text = "New Update Available"
        self.updateInfoTextView.text = "A newer version of this app is available. Please update the app to continue using it."
    }
    
    @IBAction func dontAskAgainButtonTapped(_ sender: Any) {
        UserDefaults.standard.set(true, forKey:dontAskAgainFlag)
        self.showNext()
    }
    
    @IBAction func updateButtonTapped(_ sender: Any) {
        UserDefaults.standard.set(false, forKey:dontAskAgainFlag)
        if let url = URL(string: self.appVersionConfig.url) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.showNext()
    }
    
    @IBAction private func showNext() { // swiftlint:disable:this cyclomatic_complexity
        guard
            let bundleVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String,
            let currentInstalledVersion = Int(bundleVersion),
            let remoteVersion = VersionDataController.shared.getVersion() else {
            VersionDataController.shared.loadVersion { (version: Int?, error: Error?) in
                if let version = version,
                    error == nil {
                    self.showNext()
                } else {
                    self.showAlertMessage(with: error)
                }
            }
            return
        }

        guard currentInstalledVersion >= remoteVersion else {
            let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String // swiftlint:disable:this force_cast
            let alertAction = UIAlertAction(title: NSLocalizedString("UPDATE", comment: ""), style: .default) { _ in
                let url = URL(string: "itms-apps://itunes.apple.com/app/1315891250")! // swiftlint:disable:this force_unwrap
                if UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
                self.showNext()
            }
            self.showAlertMessage(title: NSLocalizedString("Update Required", comment: ""), message: String.localizedStringWithFormat("A newer version of this app is available. Please update the app to continue using it.", appName), actions: [alertAction])
            return
        }

        guard let profile = AccountController.shared.profile else {
            self.launchAuthMenu()
            return
        }

        if profile.shouldChangePassword {
            self.launchAuthMenu(with: .firstTimeLoginPasswordChange)
            return
        }

        if profile.shouldChangeEmail {
            self.launchUpdateEmailViewController()
            return
        }

        guard self.hasShownWalkthrough else {
            self.launchWalkthrough()
            return
        }

        if AccountDataController.shared.getAccounts(profile: AccountController.shared.profile).isEmpty {
            self.loadDataFromServer { error in
                if error == nil {
                    self.progressStackView.isHidden = true
                    self.showNext()
                }
            }
            return
        }

        AccountController.shared.selectedAccount = AccountDataController.shared.getAccounts(profile: AccountController.shared.profile).first
        if let token = Installation.current().valueForKey("deviceToken") as? String,
            let account = AccountController.shared.selectedAccount,
            let notificationSetting = NotificationSettingDataController.shared.getNotificationSettings(account: account).first {
            notificationSetting.deviceToken = token
            NotificationSettingDataController.shared.updateNotificationSetting(notificationSetting: notificationSetting)
        }

        self.launchMain()
    }

    private func launchAuthMenu(with action: AuthMenuViewController.AuthenticationAction? = nil) {
        guard let landingVC = UIStoryboard(name: "AuthMenu", bundle: nil).instantiateInitialViewController() else {
            return
        }

        landingVC.modalPresentationStyle = .fullScreen
        landingVC.modalTransitionStyle = .crossDissolve
        ((landingVC as? UINavigationController)?.viewControllers.first as? AuthMenuViewController)?.authAction = action
        self.present(landingVC, animated: true, completion: nil)
    }

    private func launchWalkthrough() {
        guard let walkthroughVC = UIStoryboard(name: "Walkthrough", bundle: nil).instantiateInitialViewController() else {
            return
        }
        walkthroughVC.modalPresentationStyle = .fullScreen
        self.present(walkthroughVC, animated: true, completion: nil)
    }

    private func launchChangePasswordViewController() {
        let changePasswordVC: ChangePasswordViewController = UIStoryboard(name: TimeSelfCareStoryboard.profile.filename, bundle: nil).instantiateViewController()
        self.presentNavigation(changePasswordVC, animated: true)
    }

    private func launchUpdateEmailViewController() {
        let changeMenuVc: ChangeEmailViewController = UIStoryboard(name: TimeSelfCareStoryboard.authMenu.filename, bundle: nil).instantiateViewController()
        changeMenuVc.modalPresentationStyle = .fullScreen
        self.present(changeMenuVc, animated: true, completion: nil)
    }

    private func launchMain() {
        guard let initialViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() else {
            return
        }

        initialViewController.modalPresentationStyle = .fullScreen
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

    private func loadDataFromServer(completion: ((Error?) -> Void)? = nil) {
        self.progressStackView.isHidden = false

        AccountDataController.shared.loadAccounts { (accounts: [Account], error: Error?) in
            guard error == nil else {
                self.progressStackView.isHidden = true
                self.errorLabel.text = error?.localizedDescription
                self.errorLabel.isHidden = false
                self.okButton.isHidden = false
                AuthUser.current?.logout()
                completion?(error)
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
                        completion?(error)
                        return
                    }

                    serviceCount += 1
                    if serviceCount == totalAccountsCount {
                        let service = ServiceDataController.shared.getServices(account: account).first { $0.category == .broadband || $0.category == .broadbandAstro }
                        SsidDataController.shared.loadSsids(account: account, service: service) { _, _ in
                        }
                        completion?(nil)
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
            self.loadDataFromServer { error in
                if error == nil {
                    self.userNotificationCenter(center, didReceive: response, withCompletionHandler: completionHandler)
                }
            }
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
            completionHandler()
            return
        }

        activityJson["account_no"] = account.accountNo
        activityJson["profile_username"] = AccountController.shared.profile?.username

        guard let activity = Activity(with: activityJson) else {
            openActivity()
            completionHandler()
            return
        }

        switch activity.type {
        case .rewards:
            let rewardVC: RewardViewController = UIStoryboard(name: TimeSelfCareStoryboard.reward.filename, bundle: nil).instantiateViewController()
            currentViewController.presentNavigation(rewardVC, animated: true)
            completionHandler()
        default:
            openActivity()
            completionHandler()
        }
    }
}
