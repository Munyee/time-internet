//
//  ChangeNotificationSettingsViewController.swift
//  TimeSelfCare
//
//  Created by Loka on 15/05/2018.
//  Copyright © 2018 Apptivity Lab. All rights reserved.
//

import UIKit
import MBProgressHUD
import UserNotifications

class NotificationSettingsViewController: BaseViewController {

    private let smsKey: String = "sms"
    private let pushNotificationKey: String = "push"
    private let emailKey: String = "email"

    private var notificationSetting: NotificationSetting? {
        didSet {
            self.updateUI()
        }
    }

    @IBOutlet private weak var pushNotificationSwitch: UISwitch!
    @IBOutlet private weak var smsNotificationSwitch: UISwitch!
    @IBOutlet private weak var emailNotificationSwitch: UISwitch!
    @IBOutlet private weak var saveButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("NOTIFICATION SETTINGS", comment: "")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back_arrow"), style: .plain, target: self, action: #selector(self.cancel))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = NSLocalizedString("Loading...", comment: "")
        NotificationSettingDataController.shared.loadNotificationSettings(account: AccountController.shared.selectedAccount) { (settings: [NotificationSetting], error: Error?) in
            hud.hide(animated: true)
            if let error = error {
                self.showAlertMessage(with: error)
                return
            }

            self.notificationSetting = settings.first
        }
    }

    override func updateUI() {
        guard
            let methodsString = self.notificationSetting?.methodsString,
            !methodsString.isEmpty
        else {
            self.emailNotificationSwitch.isOn = true
            self.pushNotificationSwitch.isOn = true
            return
        }

        self.pushNotificationSwitch.isOn = methodsString.contains(pushNotificationKey)
        self.smsNotificationSwitch.isOn = methodsString.contains(smsKey)
        self.emailNotificationSwitch.isOn = methodsString.contains(emailKey)
    }

    @objc
    private func cancel() {
        self.dismissVC()
    }

    @IBAction func onSwitchValueChange(_ sender: UISwitch) {
        // Hardcoded business rules. Either email or sms must be turn on.
        switch sender {
        case smsNotificationSwitch:
            if !sender.isOn {
                emailNotificationSwitch.isOn = true
            }
        case emailNotificationSwitch:
            if !sender.isOn {
                smsNotificationSwitch.isOn = true
            }
        case pushNotificationSwitch:
            guard sender.isOn else {
                return
            }
            UNUserNotificationCenter.current().getNotificationSettings { (settings: UNNotificationSettings) in
                if settings.authorizationStatus == .denied {
                    let openAction = UIAlertAction(title: NSLocalizedString("Open Setting", comment: ""), style: .default) { _ in
                        UIApplication.shared.openApplicationSettings()
                    }

                    let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .default, handler: nil)
                    DispatchQueue.main.async {
                        self.showAlertMessage(message: NSLocalizedString("Push notifications for TIME Self Care are currently disabled. If you'd like to receive push notifications, please enable them in the Setting.", comment: ""), actions: [cancelAction, openAction])
                    }
                } else {
                    UIApplication.shared.setupRemoteNotifications()
                }
            }
        default:
            break
        }
        self.saveButton.isEnabled = true
        self.saveButton.backgroundColor = .primary
    }

    @IBAction func saveNotificationSetting(_ sender: Any) {
        guard let notificationSetting = self.notificationSetting else {
            return
        }

        var methods: [String] = []
        if self.pushNotificationSwitch.isOn {
            methods.append(pushNotificationKey)
        }

        if self.emailNotificationSwitch.isOn {
            methods.append(emailKey)
        }

        if self.smsNotificationSwitch.isOn {
            methods.append(smsKey)
        }

        notificationSetting.methodsString = methods.joined(separator: ",")

        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { _ in

            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.label.text = NSLocalizedString("Updating...", comment: "")
            NotificationSettingDataController.shared.updateNotificationSetting(notificationSetting: notificationSetting) { _, error in
                hud.hide(animated: true)

                if let error = error {
                    self.showAlertMessage(with: error)
                    return
                }

                let confirmationVC: ConfirmationViewController = UIStoryboard(name: TimeSelfCareStoryboard.common.filename, bundle: nil).instantiateViewController()

                confirmationVC.mode = .infoUpdated
                confirmationVC.actionBlock = {
                    self.dismissVC()
                }
                confirmationVC.modalPresentationStyle = .fullScreen
                self.present(confirmationVC, animated: true, completion: nil)
            }
        }

        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .default, handler: nil)

        self.showAlertMessage(title: NSLocalizedString("Change Confirmation", comment: ""), message: NSLocalizedString("Are you sure you want to proceed?", comment: ""), actions: [cancelAction, okAction])
    }

}
