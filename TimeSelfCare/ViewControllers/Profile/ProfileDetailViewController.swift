//
//  ProfileDetailViewController.swift
//  TimeSelfCare
//
//  Created by Loka on 29/11/2017.
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import UIKit

internal class ProfileDetailViewController: TimeBaseViewController {

    @IBOutlet private weak var accountNumberLabel: UILabel!
    @IBOutlet private weak var fullnameLabel: UILabel!
    @IBOutlet private weak var businessRegistrationNumberLabel: UILabel!
    @IBOutlet private weak var contactPersonLabel: UILabel!
    @IBOutlet private weak var contactMobileLabel: UILabel!
    @IBOutlet private weak var contactOfficeLabel: UILabel!
    @IBOutlet private weak var emailAddressLabel: UILabel!
    @IBOutlet private weak var fullNameKeyLabel: UILabel!
    @IBOutlet private weak var contactPersonContainerView: UIStackView!
    @IBOutlet private weak var businessRegistrationNumberContainerView: UIStackView!
    @IBOutlet private weak var contactOfficeContainerView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("PROFILE", comment: "")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back_arrow"), style: .plain, target: self, action: #selector(self.back))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(self.editProfile))

//        loadDataFromServer()

        // populate data
        let selectedAccount = AccountController.shared.selectedAccount
        let profile = selectedAccount?.profile

        if selectedAccount?.custSegment == .residential {
            self.contactOfficeContainerView.isHidden = true
            self.businessRegistrationNumberContainerView.isHidden = true
            self.contactOfficeContainerView.isHidden = true
        }

        self.fullNameKeyLabel.text = selectedAccount?.custSegment == .residential ? NSLocalizedString("Name", comment: "") : NSLocalizedString("Company Name", comment: "")
        self.businessRegistrationNumberLabel.text = selectedAccount?.profileUsername ?? "-"
        self.accountNumberLabel.text = selectedAccount?.accountNo ?? "-"
        self.fullnameLabel.text = profile?.fullname ?? "-"
        self.contactPersonLabel.text = profile?.contactPerson ?? "-"
        self.contactPersonContainerView.isHidden = selectedAccount?.custSegment != .business
        self.contactMobileLabel.text = profile?.mobileNo ?? "-"
        self.contactOfficeLabel.text = profile?.officeNo ?? "-"
        self.emailAddressLabel.text = profile?.email ?? "-"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadDataFromServer()
    }
    
    private func loadDataFromServer() {

        AccountDataController.shared.loadAccounts { (accounts: [Account], error: Error?) in
            let totalAccountsCount = accounts.count
            var serviceCount = 0
            accounts.forEach { (account: Account) in
                ServiceDataController.shared.loadServices(accountNo: account.accountNo) { (_: [Service], error: Error?) in
                    if error != nil {
                        AuthUser.current?.logout()
                        FreshChatManager.shared.logout()
                        return
                    }
                    serviceCount += 1
                    if serviceCount == totalAccountsCount {
                        let service = ServiceDataController.shared.getServices(account: account).first { $0.category == .broadband || $0.category == .broadbandAstro }
                        SsidDataController.shared.loadSsids(account: account, service: service) { _, _ in
                        }
                    }
                }

                ActivityDataController.shared.loadActivities(account: account) { _,_  in
                    let selectedAccount = AccountController.shared.selectedAccount
                    let profile = selectedAccount?.profile
                    self.businessRegistrationNumberLabel.text = selectedAccount?.profileUsername ?? "-"
                    self.accountNumberLabel.text = selectedAccount?.accountNo ?? "-"
                    self.fullnameLabel.text = profile?.fullname ?? "-"
                    self.contactPersonLabel.text = profile?.contactPerson ?? "-"
                    self.contactPersonContainerView.isHidden = selectedAccount?.custSegment != .business
                    self.contactMobileLabel.text = profile?.mobileNo ?? "-"
                    if profile?.officeNo == "" {
                        self.contactOfficeLabel.text = "-"
                    } else {
                        self.contactOfficeLabel.text = profile?.officeNo ?? "-"
                    }
                    self.emailAddressLabel.text = profile?.email ?? "-"
                }
            }
        }
    }

    @objc
    func back() {
        self.dismissVC()
    }

    @IBAction func changeNotificationSettings(_ sender: Any) {
        let notifcationSettingsVC: NotificationSettingsViewController = UIStoryboard(name: TimeSelfCareStoryboard.profile.filename, bundle: nil).instantiateViewController()
        self.show(notifcationSettingsVC, sender: nil)
    }
    
    @objc
    func editProfile() {
        let editProfileVC: EditProfileViewController = UIStoryboard(name: TimeSelfCareStoryboard.profile.filename, bundle: nil).instantiateViewController()
        self.show(editProfileVC, sender: nil)
    }

    @IBAction func changePassword(_ sender: Any) {
        let changePasswordVC: ChangePasswordViewController = UIStoryboard(name: TimeSelfCareStoryboard.profile.filename, bundle: nil).instantiateViewController()
        self.show(changePasswordVC, sender: nil)
    }

    @IBAction func logout(_ sender: Any) {
        let yesAction = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default) { _ in
            let hud = LoadingView().addLoading(toView: self.view)
            hud.showLoading()

            AccountSummaryViewController.didAnimate = false

            AuthUser.current?.logout { _ in
                hud.hideLoading()
                let storyboard = UIStoryboard(name: "Common", bundle: nil)
                if let confirmationVC = storyboard.instantiateViewController(withIdentifier: "ConfirmationViewController") as? ConfirmationViewController {
                    confirmationVC.mode = .logout
                    confirmationVC.actionBlock = {
                        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
                        FreshChatManager.shared.logout()
                    }
                    confirmationVC.modalPresentationStyle = .fullScreen
                    self.present(confirmationVC, animated: true, completion: nil)
                }
            }
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .default, handler: nil)
        self.showAlertMessage(title: NSLocalizedString("Logout from TIME Self Care", comment: ""), message: NSLocalizedString("Proceed to logout?", comment: ""), actions: [cancelAction, yesAction])
    }
}
