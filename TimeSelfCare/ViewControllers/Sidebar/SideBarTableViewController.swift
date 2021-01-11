//
//  SideBarTableViewController.swift
//  TimeSelfCare
//
//  Created by Loka on 09/11/2017.
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import Foundation
import MBProgressHUD

internal class SidebarTableViewController: UIViewController {
    private enum Section: Int {
        case account = 0, service

        static var total: Int = 2
    }

    private var accounts: [Account] = []

    private var services: [ServiceSidebarCell.ServiceType] {

        let isResidential = self.accounts.first { $0.custSegment == .residential } != nil
        let isBusiness = self.accounts.first { $0.custSegment == .business } != nil

        if (isResidential) {
            return [.reward, .hookup, .shop, .support, .livechat]
        } else if (isBusiness) {
            return [.support, .livechat]
        } else {
            return []
        }
    }

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var nameInitialLabel: UILabel!
    @IBOutlet private var versionLabel: UILabel!
    @IBOutlet var viewProfileButton: RoundedButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateInitial), name: NSNotification.Name.PersonDidChange, object: nil)
        self.nameInitialLabel.font = UIFont(name: "DINCondensed-Bold", size: 50)
        tableView.backgroundColor = .white
        self.viewProfileButton.titleLabel?.textAlignment = .center
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateDataSet()
        updateVersionDisplay()
    }

    private func updateDataSet() {
        self.accounts = AccountDataController.shared.getAccounts(profile: AccountController.shared.profile)
        self.tableView.reloadData()
        self.updateInitial()
    }

    @IBAction func logout(_ sender: Any) {
        let yesAction = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default) { _ in
            let hud = MBProgressHUD.showAdded(to: self.parent!.view, animated: true) // swiftlint:disable:this force_unwrapping
            hud.label.text = NSLocalizedString("Logging out...", comment: "")

            AccountSummaryViewController.didAnimate = false

            AuthUser.current?.logout { _ in
                hud.hide(animated: true)
                let storyboard = UIStoryboard(name: "Common", bundle: nil)
                if let confirmationVC = storyboard.instantiateViewController(withIdentifier: "ConfirmationViewController") as? ConfirmationViewController {
                    confirmationVC.mode = .logout
                    confirmationVC.actionBlock = {
                        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
                    }
                    confirmationVC.modalPresentationStyle = .fullScreen
                    self.present(confirmationVC, animated: true, completion: nil)
                }
            }
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .default, handler: nil)
        self.showAlertMessage(title: NSLocalizedString("Logout from TIME Self Care", comment: ""), message: NSLocalizedString("Proceed to logout?", comment: ""), actions: [cancelAction, yesAction])
    }
    
    private func updateVersionDisplay() {
         let isStagingMode: Bool = UserDefaults.standard.bool(forKey: Installation.kIsStagingMode)
        var appVersion = Installation.appVersion
        if isStagingMode {
            appVersion = "\(appVersion) (Staging)"
        }
        self.versionLabel.text = appVersion
    }

    @objc
    private func updateInitial() {
        if let profile: Profile = ProfileDataController.shared.getProfiles().first(where: { $0.username == (AuthUser.current?.person as? Profile)?.username }) {
            self.nameInitialLabel.text = profile.fullname?.nameInitials
        } else {
            self.nameInitialLabel.text = "--"
        }
    }

    @IBAction func viewProfile(_ sender: Any) {
        let storyboard = UIStoryboard(name: TimeSelfCareStoryboard.profile.filename, bundle: nil)
        let profileDetailVC: ProfileDetailViewController = storyboard.instantiateViewController()
        self.presentNavigation(profileDetailVC, animated: true)
    }
}

// MARK: - TableView DataSource & Delegate
extension SidebarTableViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
//        let shouldShowSupport = self.accounts.first { $0.custSegment == .residential } != nil
        return Section.total
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else {
            return 0
        }
        switch section {
        case .account:
            return self.accounts.count
        case .service:
            return self.services.count
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.contentView.backgroundColor = .white
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = Section(rawValue: indexPath.section)
        if section == .account,
            let cell = tableView.dequeueReusableCell(withIdentifier: "AccountSidebarCell") as? AccountSidebarCell {
            cell.configureCell(with: self.accounts[indexPath.row])
            cell.selectionStyle = .none
            return cell
        } else if section == .service,
            let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceSidebarCell") as? ServiceSidebarCell {
            cell.configure(with: self.services[indexPath.item])
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == Section.service.rawValue {
            let divider = UIView()
            divider.backgroundColor = .grey
            let view = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: tableView.bounds.width, height: 30)))
            view.addSubview(divider)
            divider.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                divider.heightAnchor.constraint(equalToConstant: 1),
                divider.widthAnchor.constraint(equalToConstant: view.frame.size.width - 30),
                divider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                divider.centerYAnchor.constraint(equalTo: view.centerYAnchor)
                ])
            return view
        } else {
            return nil
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == Section.account.rawValue else {
            self.handleNavigation(with: indexPath)
            return
        }

        AccountController.shared.selectedAccount = self.accounts[indexPath.row]
        self.sidebarNavigationController.hideLeftSidebar()
        self.tableView.reloadData()
    }

    private func handleNavigation(with serviceIndexPath: IndexPath) {
        guard serviceIndexPath.section == Section.service.rawValue else {
            return
        }
        
        DispatchQueue.main.async {
        switch self.services[serviceIndexPath.item] {
        case .reward:
            let rewardVC: RewardViewController = UIStoryboard(name: TimeSelfCareStoryboard.reward.filename, bundle: nil).instantiateViewController()
            self.presentNavigation(rewardVC, animated: true)
        case .hookup:
            let hookupVC: HookupViewController = UIStoryboard(name: TimeSelfCareStoryboard.hookup.filename, bundle: nil).instantiateViewController()
            self.presentNavigation(hookupVC, animated: true)
        case .shop:
            let shopVC: ShopViewController = UIStoryboard(name: TimeSelfCareStoryboard.shop.filename, bundle: nil).instantiateViewController()
            self.presentNavigation(shopVC, animated: true)
        case .support:
            let ticketListVC: TicketListViewController = UIStoryboard(name: TimeSelfCareStoryboard.support.filename, bundle: nil).instantiateViewController()
            self.presentNavigation(ticketListVC, animated: true)
        case .livechat:

            LiveChatDataController.shared.loadStatus { statusResult in
                if let status = statusResult {
                    if (status == "online") {
                        if let selectedAccount = AccountController.shared.selectedAccount {
                            let user = FreshchatUser.sharedInstance()
                            let profile = selectedAccount.profile
                            user.firstName = profile?.fullname
                            user.email = profile?.email
                            user.phoneNumber = profile?.mobileNo
                            Freshchat.sharedInstance().setUser(user)
                            Freshchat.sharedInstance().setUserPropertyforKey("AccountNo", withValue: selectedAccount.accountNo)
                        }
                            let alert = UIAlertController(title: "Choose Option", message: nil, preferredStyle: .actionSheet)

                            alert.addAction(UIAlertAction(title: "Conversations", style: .default , handler:{ (UIAlertAction) in
                                Freshchat.sharedInstance().showConversations(self)
                            }))

                            alert.addAction(UIAlertAction(title: "FAQ", style: .default , handler:{ (UIAlertAction) in
                                Freshchat.sharedInstance().showFAQs(self)
                            }))

                            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))

                            self.present(alert, animated: true, completion: nil)
                        } else {
                            if var vc = UIApplication.shared.keyWindow?.rootViewController {
                                while let presentedViewController = vc.presentedViewController {
                                    vc = presentedViewController
                                }

                                if let alertView = UIStoryboard(name: "LiveChatAlert", bundle: nil).instantiateViewController(withIdentifier: "alertView") as? LiveChatPopUpViewController {
                                    vc.addChild(alertView)
                                    alertView.view.frame = vc.view.frame
                                    vc.view.addSubview(alertView.view)
                                    alertView.didMove(toParent: vc)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
