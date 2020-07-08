//
//  SummaryContainerViewController.swift
//  TimeSelfCare
//
//  Created by Loka on 21/11/2017.
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import UIKit
import Lottie

class SummaryContainerViewController: TimeBaseViewController {
    enum Page {
        case accountSummary, addOnSummary, voiceLineSummary, performanceStatusSummary
    }

    private var pages: [Page] = []

    @IBOutlet private weak var pageControl: UIPageControl!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var pageTitleLabel: UILabel!

    @IBOutlet private weak var activityAnimationView: LOTAnimationView!
    @IBOutlet private weak var profileFullNameLabel: UILabel!
    @IBOutlet private weak var floatingActionButton: UIButton!
    @IBOutlet private weak var activityButton: UIButton!
    @IBOutlet weak var liveChatView: ExpandableLiveChatView!
    @IBOutlet weak var liveChatConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileFullNameLabel.text = AccountController.shared.selectedAccount?.profile?.fullname ?? "..."

        self.floatingActionButton.layer.shadowPath = UIBezierPath(ovalIn: self.floatingActionButton.bounds).cgPath
        self.floatingActionButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.floatingActionButton.layer.shadowColor = UIColor.grey.cgColor
        self.floatingActionButton.layer.shadowOpacity = 0.8
        self.floatingActionButton.layer.shadowRadius = 4

        didUpdatePage(with: 0)

        NotificationCenter.default.addObserver(self, selector: #selector(self.handleConnectionStatusUpdate(notification:)), name: NSNotification.Name.ConnectionStatusDidUpdate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateNotificationIndicator), name: NSNotification.Name.NotificationDidReceive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleAccountChange), name: NSNotification.Name.SelectedAccountDidChange, object: nil)

        self.updatePages()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let hideSidebarGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.hideSidebar(_:)))
        hideSidebarGesture.delegate = self
        self.view.addGestureRecognizer(hideSidebarGesture)

        self.updateNotificationIndicator()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if (liveChatView.isExpand) {
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

    private func updatePages() {
        self.pages = [.accountSummary, .addOnSummary]

        let account = AccountController.shared.selectedAccount! // swiftlint:disable:this force_unwrapping

        let shouldShowVoiceScreen: Bool = ServiceDataController.shared.getServices(account: account).first { $0.category == .voice } != nil
        if shouldShowVoiceScreen {
            self.pages.append(.voiceLineSummary)
        }

        self.pages.append(.performanceStatusSummary)

        self.updatePageControl()
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
        self.activityAnimationView.setAnimation(named: "anim_notification_bell")
        self.activityAnimationView.isHidden = !hasUnreadActivity
        self.activityButton.alpha = hasUnreadActivity ? 0 : 1
        if hasUnreadActivity {
            self.activityAnimationView.setAnimation(named: "anim_notification_bell")
            self.activityAnimationView.loopAnimation = false
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
        case .performanceStatusSummary:
            menuItems = [.changeSsid]
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

        if isConnected {
            self.showFloatingActionButton(with: #imageLiteral(resourceName: "ic_ssid_button"))
        } else {
            self.hideFloatingActionButton()
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
            self.pageTitleLabel.text = NSLocalizedString("Performance", comment: "")

            if SsidDataController.shared.getSsids(account: AccountController.shared.selectedAccount).first?.isEnabled ?? false {
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
