//
//  AutoDebitViewController.swift
//  TimeSelfCare
//
//  Created by Loka on 23/11/2017.
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import UIKit
import MBProgressHUD

internal class AutoDebitViewController: TimeBaseViewController {

    private var creditCards: [CreditCard] = [] {
        didSet {
            self.tableView.reloadData()
            self.tableView.isHidden = self.creditCards.isEmpty
            self.placeholderView.isHidden = !self.creditCards.isEmpty
        }
    }
    @IBOutlet private weak var placeholderView: UIStackView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var registerButton: UIButton!
    @IBOutlet private weak var removeButton: UIButton!
    @IBOutlet weak var liveChatView: ExpandableLiveChatView!
    @IBOutlet weak var liveChatConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Auto Debit", comment: "")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: ""), style: .plain, target: self, action: #selector(self.back))
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if (liveChatView.isExpand) {
            liveChatConstraint.constant = 0
        } else {
            liveChatConstraint.constant = -125
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateDataSet()
        self.refresh()
    }

    private func updateDataSet() {
        self.creditCards = CreditCardDataController.shared.getCreditCards(account: AccountController.shared.selectedAccount)
    }

    private func refresh() {
        CreditCardDataController.shared.loadCreditCards(account: AccountController.shared.selectedAccount) { _, error in
            if let error = error {
                self.showAlertMessage(with: error)
                return
            }
            self.updateDataSet()
        }
    }

    @objc
    func back() {
        self.dismissVC()
    }
}

extension AutoDebitViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.creditCards.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AutoDebitCell") as? AutoDebitCell else {
            return UITableViewCell()
        }
        cell.configure(with: self.creditCards[indexPath.row])
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if self.creditCards.isEmpty {
            return nil
        }

        return self.removeButton
    }
}

extension AutoDebitViewController: AutoDebitCellDelegate {
    func modify(cell: AutoDebitCell, creditCard: CreditCard) {
        self.modifyAutoDebit(self)
    }
}

// Registering for autodebit using new payment gateway
extension AutoDebitViewController {
    enum AutoDebitAction: String {
        case modify
        case new
    }

    private func prepareAutoDebitPayment(action: AutoDebitAction = .new) -> PaymentViewController? {
        guard let paymentVC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentViewController") as? PaymentViewController else {
            return nil
        }

        let billAmount = BillDataController.shared.getBills(account: AccountController.shared.selectedAccount).first?.totalOutstanding

        var parameters: [String: Any] = [:]
        let path = "make_payment_autodebit"
        parameters["action"] = path
        parameters["username"] = AccountController.shared.profile?.username
        parameters["account_no"] = AccountController.shared.selectedAccount?.accountNo
        parameters["token"] = APIClient.shared.getToken(forPath: path)
        parameters["amount"] = "\(billAmount?.isLessThanOrEqualTo(0) ?? true ? 1.00 : billAmount!)" // swiftlint:disable:this force_unwrapping
        parameters["autodebit_payment"] = (billAmount?.isLessThanOrEqualTo(0) ?? true) ? "verify_cc" : "bill_payment"
        parameters["autodebit_action"] = action == .new ? "new" : "modify"
        parameters["upgw"] = "yes"
        parameters["cc_type_id"] = 1 // According to API docs, this should not be required... but without it, goes API redirects to payment failed
        parameters["session_id"] = AccountController.shared.sessionId
        paymentVC.parameters = parameters
        paymentVC.transactionFailedBlock = {
            self.presentedViewController?.dismissVC()
        }
        paymentVC.transactionSuccessBlock = {
            self.presentedViewController?.dismiss(animated: false) {
                self.showSuccessConfirmation()
            }
        }

        return paymentVC
    }

    @IBAction func registerAutoDebit(_ sender: Any) {
        guard let paymentVC = self.prepareAutoDebitPayment(action: .new) else {
            return
        }

        paymentVC.title = NSLocalizedString("Register Auto Debit", comment: "")

        let billAmount = BillDataController.shared.getBills(account: AccountController.shared.selectedAccount).first?.totalOutstanding

        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { _ in
            self.presentNavigation(paymentVC, animated: true)
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .default, handler: nil)

        let alertTitle = (billAmount?.isLessThanOrEqualTo(0) ?? true) ? NSLocalizedString("RM1 Deduction", comment: "") : NSLocalizedString("Clear Payment", comment: "")
        let alertMessage = (billAmount?.isLessThanOrEqualTo(0) ?? true) ? NSLocalizedString("To verify your card, RM 1 will be charged and reversed on the same day.", comment: "") :
            String(format: NSLocalizedString("There's an outstanding amount of %.2f on your account. This will be charged to your card. Should you proceed?", comment: ""), billAmount ?? 0)
        self.showAlertMessage(title: alertTitle, message: alertMessage, actions: [cancelAction, okAction])
    }

    @IBAction func modifyAutoDebit(_ sender: Any) {
        guard let paymentVC = self.prepareAutoDebitPayment(action: .modify) else {
            return
        }

        paymentVC.title = NSLocalizedString("Modify Auto Debit", comment: "")

        self.presentNavigation(paymentVC, animated: true)
    }

    func showSuccessConfirmation() {
        let storyboard = UIStoryboard(name: "Common", bundle: nil)
        if let confirmationVC = storyboard.instantiateViewController(withIdentifier: "ConfirmationViewController") as? ConfirmationViewController {
            confirmationVC.mode = .autodebitAdded
            confirmationVC.actionBlock = {
                self.presentingViewController?.dismiss(animated: false, completion: nil)
                // self.confirmationDidDismissAction?()
            }
            confirmationVC.modalPresentationStyle = .fullScreen
            self.present(confirmationVC, animated: true, completion: nil)
        }
    }
}

// Removing registered autodebit
extension AutoDebitViewController {
    @IBAction func removeAutoDebit(_ sender: Any) {
        guard
            let profile = AccountController.shared.profile,
            let selectedAccount = AccountController.shared.selectedAccount
            else {
                return
        }

        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.label.text = NSLocalizedString("Removing...", comment: "")
            CreditCardDataController.shared.removeCreditCard(username: profile.username, account: selectedAccount) { error in
                hud.hide(animated: true)
                if let error = error {
                    self.showAlertMessage(with: error)
                    return
                }
                self.showRemovedConfirmation()
            }
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .default, handler: nil)
        self.showAlertMessage(title: NSLocalizedString("Remove Auto Debit", comment: ""),
                              message: "You will no longer enjoy RM 2 off your monthly bill. Are you sure?", actions: [cancelAction, yesAction])
    }

    func showRemovedConfirmation() {
        let storyboard = UIStoryboard(name: "Common", bundle: nil)
        if let confirmationVC = storyboard.instantiateViewController(withIdentifier: "ConfirmationViewController") as? ConfirmationViewController {
            confirmationVC.mode = .autodebitRemoved
            confirmationVC.actionBlock = {
                self.presentingViewController?.dismiss(animated: false, completion: nil)
                // self.confirmationDidDismissAction?()
            }
            confirmationVC.modalPresentationStyle = .fullScreen
            self.present(confirmationVC, animated: true, completion: nil)
        }
    }
}
