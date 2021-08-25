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
import FirebaseCrashlytics
import AppTrackingTransparency
import Firebase
import FBSDKCoreKit

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
    @IBOutlet private weak var okButton: UIButton!
    @IBOutlet private weak var versionUpdateView: UIView!
    @IBOutlet private weak var dontShowButton: UIButton!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var updateOrContinueButton: UIButton!
    @IBOutlet private weak var alertTitleLabel: UILabel!
    @IBOutlet private weak var updateInfoTextView: UILabel!
    @IBOutlet private var appLogoImgView: UIImageView!
    @IBOutlet private var progressImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().delegate = self
    } 
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.handlingInvalidSession), name: NSNotification.Name.SessionInvalid, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
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
        
        progressImageView.animationImages = self.animatedImages(for: "PreloadBarFrames")
        progressImageView.contentMode = .scaleAspectFill
        progressImageView.animationDuration = 1
        progressImageView.animationRepeatCount = 1
        progressImageView.image = self.progressImageView.animationImages?.last
        progressImageView.startAnimating()
        
        getFirebaseAppVersion()

        appLogoImgView.animationImages = self.animatedLogoImages(for: "TIME_AnimationFrame")
        appLogoImgView.contentMode = .scaleAspectFill
        appLogoImgView.animationDuration = 1.0
        appLogoImgView.animationRepeatCount = 1
        appLogoImgView.image = appLogoImgView.animationImages?.last
        appLogoImgView.startAnimating()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        progressImageView.stopAnimating()
    }
    
    func animatedLogoImages(for name: String) -> [UIImage] {
        var i = 0
        var images = [UIImage]()
        while let image = UIImage(named: "\(name)/Frame\(i)") {
            images.append(image)
            i += 1
        }
        return images
    }
    
    func animatedImages(for name: String) -> [UIImage] {
        var i = 0
        var images = [UIImage]()
        while let image = UIImage(named: "\(name)/preloadbar\(i)") {
            images.append(image)
            i += 1
        }
        return images
    }

    func getFirebaseAppVersion() {
        if NetworkReachabilityManager()!.isReachable {
            
            if #available(iOS 14, *) {
                ATTrackingManager.requestTrackingAuthorization { status in
                    if status == .authorized {
                        Analytics.setAnalyticsCollectionEnabled(true)
                        Settings.setAdvertiserTrackingEnabled(true)
                        Settings.isAutoLogAppEventsEnabled = true
                        Settings.isAdvertiserIDCollectionEnabled = true
                    } else {
                        Analytics.setAnalyticsCollectionEnabled(false)
                        Settings.setAdvertiserTrackingEnabled(false)
                    }
                }
            } else {
                Analytics.setAnalyticsCollectionEnabled(true)
                Settings.setAdvertiserTrackingEnabled(true)
                Settings.isAutoLogAppEventsEnabled = true
                Settings.isAdvertiserIDCollectionEnabled = true
            }
            
            remoteConfig = RemoteConfig.remoteConfig()
            let settings = RemoteConfigSettings()
            settings.fetchTimeout = 30
            settings.minimumFetchInterval = 3_600

            #if DEBUG
            #endif
            remoteConfig.configSettings = settings
            remoteConfig.setDefaults(fromPlist: "GoogleService-Info")
            remoteConfig.fetch { status, error in
                if status == .success {
                    self.remoteConfig.activate { _, _ in
                        guard let appInit = self.remoteConfig["app_init"].jsonValue as? NSDictionary else {
                            self.showNext()
                            return
                        }
                        self.appVersionConfig = AppVersionModal(dictionary: appInit)
                        DispatchQueue.main.async {
                            self.checkAppVersion()
                        }
                    }
                } else {
                    self.showNext()
                    print("Config not fetched")
                    print("Error: \(error?.localizedDescription ?? "No error available.")")
                }
            }
        } else {
            self.showAlertMessage(title: "", message: "No Internet Connection", actions: [
                UIAlertAction(title: "RETRY", style: .cancel, handler: { _ in
                    self.getFirebaseAppVersion()
                })
            ])
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
        DispatchQueue.main.async {
            self.versionUpdateView.isHidden = false
            self.dontShowButton.isHidden = true
            self.alertTitleLabel.text = messageTitle
            self.updateInfoTextView.text = messageBody
        }
    }
    
    func showAppVersionWithMinorUpdate(messageTitle: String, messageBody:String ) {
        DispatchQueue.main.async {
            if UserDefaults.standard.bool(forKey:dontAskAgainFlag) {
                self.versionUpdateView.isHidden = true
                self.dontShowButton.isHidden = true
                self.showNext()
            } else {
                self.versionUpdateView.isHidden = false
                self.dontShowButton.isHidden = false
            }
            self.alertTitleLabel.text = messageTitle
            self.updateInfoTextView.text = messageBody
        }
    }
    
    func showAppVersionWithLatestUpdate() {
        DispatchQueue.main.async {
            self.versionUpdateView.isHidden = false
            self.dontShowButton.isHidden = true
            self.alertTitleLabel.text = "New Update Available"
            self.updateInfoTextView.text = "A newer version of this app is available. Please update the app to continue using it."
        }
    }
    
    @IBAction func dontAskAgainButtonTapped(_ sender: Any) {
        UserDefaults.standard.set(true, forKey:dontAskAgainFlag)
        self.showNext()
    }
    
    @IBAction func updateButtonTapped(_ sender: Any) {
        UserDefaults.standard.set(false, forKey:dontAskAgainFlag)
        if let url = URL(string: self.appVersionConfig.url) {
            print("Url = \(url)")
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.showNext()
    }
    
    @IBAction private func showNext() {
//        guard
//            let bundleVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String,
//            let currentInstalledVersion = Int(bundleVersion),
//            let remoteVersion = VersionDataController.shared.getVersion() else {
//            VersionDataController.shared.loadVersion { (version: Int?, error: Error?) in
//                if let version = version,
//                    error == nil {
//                    self.showNext()
//                } else {
//                    self.showAlertMessage(title: NSLocalizedString("Error", comment: "Error"), message: error?.localizedDescription ?? "", actions: [
//                        UIAlertAction(title: "RETRY", style: .cancel, handler: { _ in
//                            self.showNext()
//                        })
//                    ])
//                }
//            }
//            return
//        }

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
        DispatchQueue.main.async {
            guard let landingVC = UIStoryboard(name: "AuthMenu", bundle: nil).instantiateInitialViewController() else {
                return
            }
            
            landingVC.modalPresentationStyle = .fullScreen
            landingVC.modalTransitionStyle = .crossDissolve
            ((landingVC as? UINavigationController)?.viewControllers.first as? AuthMenuViewController)?.authAction = action
            self.present(landingVC, animated: true, completion: nil)
        }
    }

    private func launchWalkthrough() {
        DispatchQueue.main.async {
            guard let walkthroughVC = UIStoryboard(name: "Walkthrough", bundle: nil).instantiateInitialViewController() else {
                return
            }
            walkthroughVC.modalPresentationStyle = .fullScreen
            self.present(walkthroughVC, animated: true, completion: nil)
        }
    }

    private func launchChangePasswordViewController() {
        let changePasswordVC: ChangePasswordViewController = UIStoryboard(name: TimeSelfCareStoryboard.profile.filename, bundle: nil).instantiateViewController()
        self.presentNavigation(changePasswordVC, animated: true)
    }

    private func launchUpdateEmailViewController() {
        DispatchQueue.main.async {
            let changeMenuVc: ChangeEmailViewController = UIStoryboard(name: TimeSelfCareStoryboard.authMenu.filename, bundle: nil).instantiateViewController()
            changeMenuVc.modalPresentationStyle = .fullScreen
            self.present(changeMenuVc, animated: true, completion: nil)
        }
    }

    private func launchMain() {
        DispatchQueue.main.async {
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
    }

    private func loadDataFromServer(completion: ((Error?) -> Void)? = nil) {
        AccountDataController.shared.loadAccounts { (accounts: [Account], error: Error?) in
            guard error == nil else {
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
        case .reDirectMsg:
            if activity.click == "AddOnSummaryPage" {
                let addOnVC: AddOnViewController = UIStoryboard(name: TimeSelfCareStoryboard.summary.filename, bundle: nil).instantiateViewController()
                currentViewController.presentNavigation(addOnVC, animated: true)
                completionHandler()
            }
        case .launchExternalApp:
            if activity.click == "WebBrowser" {
                if let urlString = activity.url {
//                    let timeWebView = TIMEWebViewController()
//                    let url = URL(string: urlString)
//                    timeWebView.url = url
//                    currentViewController.presentNavigation(timeWebView, animated: true)
                    openURL(withURLString: urlString)
                    completionHandler()
                }
            }
        case .guestWifi:
            AccountController.shared.showGuestWifi = true
            
            if let presentedVC = self.presentedViewController?.children[0].presentedViewController {
                presentedVC.dismiss(animated: true, completion: {
                    NotificationCenter.default.post(name: UIApplication.didBecomeActiveNotification, object: nil)
                })
            }
            completionHandler()
        default:
            openActivity()
            completionHandler()
        }
    }
}
