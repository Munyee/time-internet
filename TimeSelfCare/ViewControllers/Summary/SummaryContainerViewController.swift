//
//  SummaryContainerViewController.swift
//  TimeSelfCare
//
//  Created by Loka on 21/11/2017.
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import UIKit
import Lottie
import MBProgressHUD
import Alamofire
import SwiftyJSON

class BannerGesture: UITapGestureRecognizer {
    
    var label: UILabel = UILabel()
    var href: [Href] = []
    var text = ""

    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
    }
}

class SummaryContainerViewController: TimeBaseViewController {
    enum Page {
        case accountSummary, addOnSummary, voiceLineSummary, performanceStatusSummary
    }
    
    private var pages: [Page] = []
    
    @IBOutlet private weak var pageControl: UIPageControl!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var pageTitleLabel: UILabel!
    
    @IBOutlet private weak var activityAnimationView: AnimationView!
    @IBOutlet private weak var profileFullNameLabel: UILabel!
    @IBOutlet private weak var floatingActionButton: UIButton!
    @IBOutlet private weak var activityButton: UIButton!
    @IBOutlet weak var liveChatView: ExpandableLiveChatView!
    @IBOutlet weak var liveChatConstraint: NSLayoutConstraint!
    @IBOutlet weak var importantNoticeView: UIView!
    @IBOutlet weak var importantNoticeLabel: UILabel!
    var showFloatingButton = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileFullNameLabel.text = AccountController.shared.selectedAccount?.profile?.fullname ?? "..."
        
        self.floatingActionButton.layer.shadowPath = UIBezierPath(ovalIn: self.floatingActionButton.bounds).cgPath
        self.floatingActionButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.floatingActionButton.layer.shadowColor = UIColor.grey.cgColor
        self.floatingActionButton.layer.shadowOpacity = 0.8
        self.floatingActionButton.layer.shadowRadius = 4
        
        didUpdatePage(with: 0)
        
        self.updatePages()
        
        let account = AccountController.shared.selectedAccount! // swiftlint:disable:this force_unwrapping

        BillingPopUpDataController.shared.loadBillingPopUp(account: account) { (data, error) in
            
            guard error == nil else {
                print(error.debugDescription)
                return
            }
            
            if let result = data, let show = result.show {
                if show {
                    if var vc = UIApplication.shared.keyWindow?.rootViewController {
                        while let presentedViewController = vc.presentedViewController {
                            vc = presentedViewController
                        }
                        
                        if let alertView = UIStoryboard(name: "BillingPopUp", bundle: nil).instantiateViewController(withIdentifier: "BillingPopUpViewController") as? BillingPopUpViewController {
                            alertView.pdf_url = result.pdf_url
                            vc.addChild(alertView)
                            alertView.view.frame = vc.view.frame
                            vc.view.addSubview(alertView.view)
                            alertView.didMove(toParent: vc)
                        }
                    }
                }
            }
            
        }
        
        let request = Alamofire.request("https://api-4854611070421271444-279141.firebaseio.com/.json", method: .get, parameters: nil, encoding: URLEncoding(), headers: nil)
        request.responseJSON { data in
            let mode: String = UserDefaults.standard.string(forKey: Installation.kMode) ?? "Production"
            var json = JSON(data.result.value)["production"]
            if mode != "Production" && !mode.isEmpty {
                json = JSON(data.result.value)["staging"]
            }
            let maintenanceMode = MaintenanceMode(json: json)
            
            let version = UserDefaults.standard.string(forKey: MaintenanceMode.NOTICE_POPUP_VERSION)
            
            if (version != maintenanceMode.notice_auto_popup.ver || version == nil) && maintenanceMode.notice_auto_popup.ver != "" {
                if var vc = UIApplication.shared.keyWindow?.rootViewController {
                    while let presentedViewController = vc.presentedViewController {
                        vc = presentedViewController
                    }
                    
                    if let alertView = UIStoryboard(name: "ImportantNotice", bundle: nil).instantiateViewController(withIdentifier: "NoticePopUpViewController") as? NoticePopUpViewController {
                        alertView.noticePopUp = maintenanceMode.notice_auto_popup
                        vc.addChild(alertView)
                        alertView.view.frame = vc.view.frame
                        vc.view.addSubview(alertView.view)
                        alertView.didMove(toParent: vc)
                    }
                }
            }
            
            
            if maintenanceMode.show_notice {
                self.importantNoticeView.isHidden = false
                self.importantNoticeLabel.attributedText = maintenanceMode.notice_message_v2.htmlAttributedStringWith(href: maintenanceMode.notice_message_href)
                let tapGesture = BannerGesture(target: self, action: #selector(self.didTappedAttributedLabel(gesture:)))
                tapGesture.label = self.importantNoticeLabel
                tapGesture.href = maintenanceMode.notice_message_href
                tapGesture.text = self.importantNoticeLabel.attributedText?.string ?? ""
                self.importantNoticeLabel.isUserInteractionEnabled = true
                self.importantNoticeLabel.addGestureRecognizer(tapGesture)
            } else {
                self.importantNoticeView.isHidden = true
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleConnectionStatusUpdate(notification:)), name: NSNotification.Name.ConnectionStatusDidUpdate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateNotificationIndicator), name: NSNotification.Name.NotificationDidReceive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleAccountChange), name: NSNotification.Name.SelectedAccountDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reinstateBackgroundTask), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reinstateBackgroundTask), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let hideSidebarGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.hideSidebar(_:)))
        hideSidebarGesture.delegate = self
        self.view.addGestureRecognizer(hideSidebarGesture)
        
        self.updateNotificationIndicator()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if liveChatView.isExpand {
            liveChatConstraint.constant = 0
        } else {
            liveChatConstraint.constant = -125
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let summaryPageVC = segue.destination as? SummaryPageViewController {
            summaryPageVC.vcDelegate = self
        }
    }
    
    @objc
    private func handleAccountChange() {
        self.updatePages()
    }
    
    @objc
    func didTappedAttributedLabel(gesture: BannerGesture) {
        for item in gesture.href {
            let range = (gesture.text as NSString).range(of: item.href)
            if gesture.didTapAttributedTextInLabel(label: gesture.label, inRange: range) {
                if var vc = UIApplication.shared.keyWindow?.rootViewController {
                    while let presentedViewController = vc.presentedViewController {
                        vc = presentedViewController
                    }
                    
                    if let alertView = UIStoryboard(name: "ImportantNotice", bundle: nil).instantiateViewController(withIdentifier: "ImportantNoticeViewController") as? ImportantNoticeViewController {
                        alertView.desc = item.desc
                        vc.addChild(alertView)
                        alertView.view.frame = vc.view.frame
                        vc.view.addSubview(alertView.view)
                        alertView.didMove(toParent: vc)
                    }
                }
            }

        }
    }
    
    private func updatePages() {
        DispatchQueue.main.async {
            self.pages = [.accountSummary, .addOnSummary]
            
            let account = AccountController.shared.selectedAccount! // swiftlint:disable:this force_unwrapping
            
            let shouldShowVoiceScreen: Bool = ServiceDataController.shared.getServices(account: account).first { $0.category == .voice } != nil
            if shouldShowVoiceScreen {
                self.pages.append(.voiceLineSummary)
            }
            
            self.pages.append(.performanceStatusSummary)
            
            self.updatePageControl()
            
            guard
                let service: Service = ServiceDataController.shared.getServices(account: account).first(where: { $0.category == .broadband || $0.category == .broadbandAstro })
            else {
                return
            }
            
            var isCustSegments = account.custSegment == .residential
            #if DEBUG
            isCustSegments = account.custSegment == .residential || account.custSegment == .business
            #endif
            
            if isCustSegments {
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                hud.label.text = NSLocalizedString("Loading...", comment: "")
                AccountDataController.shared.isUsingHuaweiDevice(account: account, service: service) { data, error in
                    hud.hide(animated: true)
                    
                    guard error == nil else {
                        print(error.debugDescription)
                        return
                    }
                    
                    if let result = data {
                        let huaweiDevice = IsHuaweiDevice(with: result)
                        if huaweiDevice?.status == "yes" {
                            self.showFloatingButton = false
                            HuaweiHelper.shared.initHwSdk {
                                HuaweiHelper.shared.checkIsLogin { result in
                                    if !result.isLogined {
                                        self.HuaweiLogin()
                                    }
//                                                                        else {
                                    //                                    self.checkIsKick()
                                    //                                }
                                }
                            }
                        } else {
                            self.showFloatingButton = false
                        }
                    }
                }
            }
        }
    }
    
    func HuaweiLogin() {
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = NSLocalizedString("Loading...", comment: "")
        
        DispatchQueue.main.async {
            guard let account = AccountController.shared.selectedAccount else {
                return
            }
            
            guard
                let service: Service = ServiceDataController.shared.getServices(account: account).first(where: { $0.category == .broadband || $0.category == .broadbandAstro })
            else {
                return
            }
            
            let UUIDValue = UIDevice.current.identifierForVendor!.uuidString
            AccountDataController.shared.getHuaweiSSOAuthCode(mobileId: UUIDValue, account: account, service: service) { data, error in
                
                hud.hide(animated: true)
                guard error == nil else {
                    print(error.debugDescription)
                    return
                }
                
                if let result = data {
                    if let authCode = result["authcode"] as? String {
                        HuaweiHelper.shared.initWithAppAuth(token: authCode, username: service.serviceId, completion: { _ in
                            DispatchQueue.main.async {
                                self.showGuestWifi()
                                self.showControlHub()
                            }
                            self.checkIsKick()
                        }, error: { exception in
//                            DispatchQueue.main.async {
//                                self.showAlertMessage(message: HuaweiHelper.shared.mapErrorMsg(exception?.errorCode ?? ""))
//                            }
                        })
                    }
                }
            }
        }
    }
    
    func checkIsKick() {
        HuaweiHelper.shared.registerErrorMessageHandle { msg in
            print(msg.errorCode)
            if msg.errorCode == "403" {
                self.HuaweiLogin()
            }
        }
    }
    
    @objc
    private func updatePageControl() {
        self.pageControl.numberOfPages = self.pages.count
    }
    
    @objc
    private func updateNotificationIndicator() {
        guard let currentAccount = AccountController.shared.selectedAccount else {
            return
        }
        
        let hasUnreadActivity: Bool = ActivityDataController.shared.getActivities(account: currentAccount).first{ $0.isNew } != nil || APNSController.shared.unreadBadgeCount() > 0
        let activityButtonImage: UIImage = hasUnreadActivity ? #imageLiteral(resourceName: "ic_notification_highlight_new") : #imageLiteral(resourceName: "ic_notification_filled")
        self.activityButton.setImage(activityButtonImage, for: .normal)
        self.activityAnimationView.animation = Animation.named("anim_notification_bell")
        self.activityAnimationView.isHidden = !hasUnreadActivity
        self.activityButton.alpha = hasUnreadActivity ? 0 : 1
        if hasUnreadActivity {
            self.activityAnimationView.animation = Animation.named("anim_notification_bell")
            self.activityAnimationView.loopMode = .playOnce
            self.activityAnimationView.play { (_: Bool) in
                self.activityButton.alpha = 1
                self.activityAnimationView.isHidden = true
            }
        }
        
    }
    
    @IBAction func menuItemTapped(_ sender: Any?) {
        self.view.endEditing(true)
        self.sidebarNavigationController?.toggleLeftSidebar(sender)
    }
    
    @objc
    func hideSidebar(_ sender: Any?) {
        if self.sidebarNavigationController.sidebarState == .leftSidebarOpen {
            self.sidebarNavigationController.hideLeftSidebar()
        }
    }
    
    @IBAction func floatingActionMenuTapped(_ sender: Any?) {
        UIView.animate(withDuration: 0.25, delay: 0, options: [.beginFromCurrentState], animations: {
            self.floatingActionButton.alpha = 0
            
            let transform = CGAffineTransform.identity.rotated(by: CGFloat(Double.pi * 135.0 / 180))
            self.floatingActionButton.transform = transform
        }, completion: { (completed: Bool) in
            if completed {
                self.floatingActionButton.isHidden = true
                self.floatingActionButton.transform = CGAffineTransform.identity
                self.floatingActionButton.alpha = 1
                
                self.showFloatingActionMenu()
            }
        })
    }
    
    private func showFloatingActionMenu() {
        let storyboard = UIStoryboard(name: TimeSelfCareStoryboard.summary.filename, bundle: nil)
        let fabMenuVC: FABViewController = storyboard.instantiateViewController()
        var menuItems: [FloatingMenuItem] = []
        
        guard self.pageControl.currentPage < self.pages.count else {
            return
        }
        
        let page: Page = self.pages[self.pageControl.currentPage]
        switch page {
        case .accountSummary:
            menuItems.append(.invoices)
            if AccountController.shared.selectedAccount?.showAutoDebit ?? false {
                menuItems.append(.autoDebit)
            }
            menuItems.append(.billingInfo)
        //        case .performanceStatusSummary:
        //            menuItems = [.changeSsid, .runDiagnostics]
        default:
            break
        }
        fabMenuVC.menuItems = menuItems
        fabMenuVC.delegate = self
        self.present(fabMenuVC, animated: true, completion: nil)
    }
    
    private func showFloatingActionButton(with image: UIImage) {
        self.floatingActionButton.setImage(image, for: .normal)
        self.floatingActionButton.layer.removeAllAnimations()
        if !self.floatingActionButton.isHidden {
            return
        }
        
        self.floatingActionButton.alpha = 0
        self.floatingActionButton.isHidden = false
        self.floatingActionButton.transform = CGAffineTransform.identity
            .translatedBy(x: 0, y: 300)
            .rotated(by: CGFloat(Double.pi * 135.0 / 180))
            .scaledBy(x: 0.25, y: 0.25)
        
        UIView.animate(withDuration: 0.25, delay: 0, options: [.beginFromCurrentState, .curveEaseOut], animations: {
            self.floatingActionButton.alpha = 1
            self.floatingActionButton.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    private func hideFloatingActionButton() {
        self.floatingActionButton.layer.removeAllAnimations()
        if self.floatingActionButton.isHidden {
            return
        }
        
        UIView.animate(withDuration: 0.25, delay: 0, options: [.beginFromCurrentState, .curveEaseIn], animations: {
            self.floatingActionButton.alpha = 0
            
            let transform = CGAffineTransform.identity
                .translatedBy(x: 0, y: 300)
                .rotated(by: CGFloat(Double.pi * 135.0 / 180))
                .scaledBy(x: 0.25, y: 0.25)
            self.floatingActionButton.transform = transform
        }, completion: { (completed: Bool) in
            if completed {
                self.floatingActionButton.isHidden = true
                self.floatingActionButton.transform = CGAffineTransform.identity
                self.floatingActionButton.alpha = 1
            }
        })
    }
    
    func dismissFloatingActionMenu(completion: (() -> Void)? = nil) {
        self.floatingActionButton.alpha = 0
        self.floatingActionButton.isHidden = false
        self.floatingActionButton.transform = CGAffineTransform.identity.rotated(by: CGFloat(Double.pi * 135.0 / 180))
        
        UIView.animate(withDuration: 0.25, delay: 0, options: [.beginFromCurrentState], animations: {
            self.floatingActionButton.transform = CGAffineTransform.identity
        }, completion: nil)
        
        UIView.animate(withDuration: 0.25, delay: 0.1, options: [], animations: {
            self.floatingActionButton.alpha = 1
        }, completion: { _ in
            completion?()
        })
    }
    
    @IBAction func showInvoices(_ sender: Any?) {
        let storyboard = UIStoryboard(name: "Payment", bundle: nil)
        guard let invoicesVC = storyboard.instantiateViewController(withIdentifier: "BillsViewController") as? BillsViewController
        else {
            return
        }
        self.presentNavigation(invoicesVC, animated: true)
    }
    
    @IBAction func showBillingInfo(_ sender: Any?) {
        let storyboard = UIStoryboard(name: "BillingInfo", bundle: nil)
        guard let billingInfoDetailVC = storyboard.instantiateViewController(withIdentifier: "BillingInfoDetailViewController") as? BillingInfoDetailViewController else {
            return
        }
        self.presentNavigation(billingInfoDetailVC, animated: true)
    }
    
    @IBAction func showNotification(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Activity", bundle: nil)
        let activityViewController: ActivityViewController = storyboard.instantiateViewController()
        self.presentNavigation(activityViewController, animated: true)
    }
    
    @IBAction func registerAutoDebit(_ sender: Any?) {
        let storyboard = UIStoryboard(name: "Payment", bundle: nil)
        guard let autoDebitVC = storyboard.instantiateViewController(withIdentifier: "AutoDebitViewController") as? AutoDebitViewController
        else {
            return
        }
        self.presentNavigation(autoDebitVC, animated: true)
    }
    
    @IBAction func activateHomeForward(_ sender: Any?) {
        let storyboard = UIStoryboard(name: "Summary", bundle: nil)
        guard let homeForwardListVC = storyboard.instantiateViewController(withIdentifier: "HomeForwardListViewController") as? HomeForwardListViewController else {
            return
        }
        self.presentNavigation(homeForwardListVC, animated: true)
    }
    
    @IBAction func changeSsid(_ sender: Any?) {
        let storyboard = UIStoryboard(name: TimeSelfCareStoryboard.performance.filename, bundle: nil)
        
        let changeSsidVC: ChangeSSIDViewController = storyboard.instantiateViewController()
        self.presentNavigation(changeSsidVC, animated: true)
    }
    
    @IBAction func runDiagnostics(_ sender: Any?) {
        let storyboard = UIStoryboard(name: TimeSelfCareStoryboard.diagnostics.filename, bundle: nil)
        
        let diagnosticsVC: DiagnosisViewController = storyboard.instantiateViewController()
        self.presentNavigation(diagnosticsVC, animated: true)
    }
    
    @IBAction func actCloseNotice(_ sender: Any) {
        self.importantNoticeView.isHidden = true
    }
    
    @objc
    func handleConnectionStatusUpdate(notification: Notification) {
        let isConnected: Bool = notification.userInfo?[kIsConnected] as? Bool ?? false
        let isSsidChangeEnabled: Bool = SsidDataController.shared.getSsids(account: AccountController.shared.selectedAccount).first?.isEnabled ?? false
        
        guard
            self.pageControl.currentPage == self.pages.index(where: { $0 == .performanceStatusSummary }),
            isSsidChangeEnabled
        else {
            return
        }
        
        if isConnected && self.showFloatingButton {
            self.showFloatingActionButton(with: #imageLiteral(resourceName: "ic_ssid_button"))
        } else {
            self.hideFloatingActionButton()
        }
    }
    
    @objc
    func reinstateBackgroundTask() {
        showGuestWifi()
        showControlHub()
    }
    
    func showGuestWifi() {
        if AccountController.shared.showGuestWifi {
            AccountController.shared.showGuestWifi = false
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.label.text = NSLocalizedString("Loading...", comment: "")
            HuaweiHelper.shared.queryUserBindGateway { gateways in
                hud.hide(animated: true)
                if !gateways.isEmpty {
                    let storyboard = UIStoryboard(name: TimeSelfCareStoryboard.guestwifi.filename, bundle: nil)
                    guard let vc = storyboard.instantiateViewController(withIdentifier: "GuestWifiViewController") as? GuestWifiViewController else {
                        return
                    }
                    self.presentNavigation(vc, animated: true)
                }
            }
        }
    }
    
    func showControlHub() {
        if AccountController.shared.showControlHub {
            AccountController.shared.showControlHub = false
            NotificationCenter.default.post(name: NSNotification.Name.ReceiveControlHubNotification, object: nil)

        }
    }
}

extension SummaryContainerViewController: SummaryPageViewControllerDelegate {
    func didUpdatePage(with index: Int) {
        self.pageControl.currentPage = index
        guard index < self.pages.count else {
            return
        }
        
        let page = self.pages[index]
        switch page {
        case .accountSummary:
            self.pageTitleLabel.text = NSLocalizedString("Summary", comment: "")
            if !(AccountController.shared.selectedAccount?.showBill ?? false) &&
                !(AccountController.shared.selectedAccount?.showAutoDebit ?? false) {
                hideFloatingActionButton()
            } else {
                showFloatingActionButton(with: #imageLiteral(resourceName: "ic_fab_menu"))
            }
        case .addOnSummary:
            self.pageTitleLabel.text = NSLocalizedString("Add-Ons", comment: "")
            hideFloatingActionButton()
        case .voiceLineSummary:
            self.pageTitleLabel.text = NSLocalizedString("Voice Line", comment: "")
            hideFloatingActionButton()
        case .performanceStatusSummary:
            self.pageTitleLabel.text = NSLocalizedString("Control Hub", comment: "")
            if SsidDataController.shared.getSsids(account: AccountController.shared.selectedAccount).first?.isEnabled ?? false && self.showFloatingButton {
                showFloatingActionButton(with: #imageLiteral(resourceName: "ic_ssid_button"))
            } else {
                hideFloatingActionButton()
            }
        }
    }
}

extension SummaryContainerViewController: FABViewControllerDelegate {
    func viewController(_ viewController: FABViewController, didSelectItem menuItem: FloatingMenuItem) {
        let dismissFABCompletionBlock: (() -> Void?) = {
            switch menuItem {
            case .invoices:
                return self.showInvoices(nil)
            case .autoDebit:
                return self.registerAutoDebit(nil)
            case .billingInfo:
                return self.showBillingInfo(nil)
            case .activateHomeForward:
                return self.activateHomeForward(nil)
            case .changeSsid:
                return self.changeSsid(nil)
            case .runDiagnostics:
                return self.runDiagnostics(nil)
            case .all, .activated, .inprogress, .unsuccessful:
                return nil
            }
        }
        
        self.dismissFloatingActionMenu {
            dismissFABCompletionBlock()
        }
    }
    
    func viewControllerWillDismiss(_ viewController: FABViewController) {
        self.dismissFloatingActionMenu()
    }
    
    func viewControllerDidDismiss(_ viewController: FABViewController) {
        
    }
}

extension SummaryContainerViewController: UIGestureRecognizerDelegate {
    
    // Only receive touches if sidebar is opened
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if self.sidebarNavigationController?.sidebarState == .leftSidebarOpen {
            return true
        }
        return false
    }
}
