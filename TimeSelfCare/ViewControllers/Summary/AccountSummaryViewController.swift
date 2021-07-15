//
//  AccountSummaryViewController.swift
//  TimeSelfCare
//
//  Created by Loka on 21/11/2017.
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import UIKit

class AccountSummaryViewController: BaseViewController {

    static var didAnimate: Bool = false
    
    var isAutoDebit: Bool = false

    private var service: Service?

    @IBOutlet private weak var accountLabel: UILabel!
    @IBOutlet private weak var speedLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var currencyLabel: UILabel!
    @IBOutlet private weak var amountDueStackView: UIStackView!
    @IBOutlet private weak var dueLabel: UILabel!
    @IBOutlet private weak var autoDebitButton: UIButton!
    @IBOutlet private weak var payButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.priceLabel.font = UIFont(name: "DINCondensed-Bold", size: 80)
        self.payButton.titleLabel?.textAlignment = .center
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name.SelectedAccountDidChange, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refresh()
        if !AccountSummaryViewController.didAnimate {
            let animationTargets: [UIView] = [self.accountLabel, self.speedLabel, self.statusLabel, self.amountDueStackView, self.dueLabel, self.payButton, self.autoDebitButton]
            animationTargets.forEach { (view: UIView) in
                view.alpha = 0
                view.transform = CGAffineTransform.identity.translatedBy(x: 0, y: 16)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    private func animateViews() {
        if AccountSummaryViewController.didAnimate {
            return
        }

        let animationTargets: [UIView] = [self.accountLabel, self.speedLabel, self.statusLabel, self.amountDueStackView, self.dueLabel, self.payButton, self.autoDebitButton]
        animationTargets.forEach { (view: UIView) in
            let index = animationTargets.index(of: view) ?? 0
            let delay = TimeInterval(index) * 0.15
            UIView.animate(withDuration: 0.25, delay: delay, options: [UIView.AnimationOptions.beginFromCurrentState, UIView.AnimationOptions.curveEaseIn], animations: {
                view.transform = CGAffineTransform.identity
                view.alpha = 1
            }, completion: { (_: Bool) in
                AccountSummaryViewController.didAnimate = true
            })
        }
    }

    @objc
    func refresh() {
        guard
            AccountController.shared.profile != nil,
            let account = AccountController.shared.selectedAccount
        else {
                self.animateViews()
            return
        }

        BillDataController.shared.loadBills(account: account) { bills, _ in
            if let bill = bills.first {
                self.priceLabel.isHidden = false
                self.currencyLabel.isHidden = false
                self.priceLabel.text = bill.totalOutstanding?.currencyString(withSymbol: "", minimumFractionDigits: 2, maximumFractionDigits: 2) ?? "..."
                self.currencyLabel.text = bill.currency
                self.dueLabel.isHidden = false
                self.dueLabel.text = "DUE \(bill.dueDate?.string(usingFormat: "d MMMM yyyy") ?? String())".uppercased()

                let hasOutstandingAmount: Bool = !(bill.totalOutstanding?.isLessThanOrEqualTo(0) ?? false)
                self.payButton.isHidden = false
                self.payButton.isEnabled = hasOutstandingAmount
                self.payButton.backgroundColor = self.payButton.isEnabled ? .primary : .grey2
                self.payButton.setTitle(self.payButton.isEnabled ? NSLocalizedString("PAY NOW", comment: "") : NSLocalizedString("PAID", comment: ""), for: .normal)
                bill.invoiceStatus = hasOutstandingAmount ? .unpaid : .paid
            } else {
                self.priceLabel.isHidden = true
                self.dueLabel.isHidden = true
                self.payButton.isHidden = true
                self.currencyLabel.isHidden = true
            }
            self.animateViews()
        }

        CreditCardDataController.shared.loadCreditCards(account: account) { (creditCards: [CreditCard], _: Error?) in
            let creditCard = creditCards.first
            if creditCard == nil {
                self.isAutoDebit = false
                self.autoDebitButton.setTitle(NSLocalizedString("Register for Auto Debit", comment: ""), for: .normal)
                self.autoDebitButton.setTitleColor(.primary, for: .normal)
            } else {
                if creditCard!.ccExist == true {
                    self.isAutoDebit = true
                    self.autoDebitButton.setTitle(NSLocalizedString("You are on Auto Debit.", comment: ""), for: .normal)
                    self.autoDebitButton.setTitleColor(.grey2, for: .normal)
                } else {
                    self.isAutoDebit = false
                    self.autoDebitButton.setTitle(NSLocalizedString("Register for Auto Debit", comment: ""), for: .normal)
                    self.autoDebitButton.setTitleColor(.primary, for: .normal)
                }
            }
        }

        NotificationSettingDataController.shared.loadNotificationSettings(account: account) {   _, _ in
        }
    }

    override func updateDataSet(items: [Service]?) {
        self.service = (items ?? ServiceDataController.shared.getServices(account: AccountController.shared.selectedAccount)).first { $0.category == .broadband }
        self.updateUI()
    }

    override func updateUI() {
        let selectedAccount = AccountController.shared.selectedAccount
        self.accountLabel.text = selectedAccount?.accountNo
        self.speedLabel.text = selectedAccount?.title
        self.statusLabel.text = selectedAccount?.accountStatus?.displayText
        self.statusLabel.backgroundColor = selectedAccount?.accountStatus == .active ? .positive : .grey2
        self.autoDebitButton.isHidden = !(selectedAccount?.showAutoDebit ?? true)
    }

    @IBAction func makePayment(_ sender: Any) {
        
        if AccountController.shared.selectedAccount?.custSegment == .residential && self.autoDebitButton.isHidden == false {
            if isAutoDebit {
                let storyboard = UIStoryboard(name: "Payment", bundle: nil)
                guard let autoDebitVC = storyboard.instantiateViewController(withIdentifier: "AutoDebitViewController") as? AutoDebitViewController
                    else {
                        return
                }
                self.presentNavigation(autoDebitVC, animated: true)
            } else {
                let setupAction = UIAlertAction(title: NSLocalizedString("SETUP NOW", comment: ""), style: .default) { _ in
                    let storyboard = UIStoryboard(name: "Payment", bundle: nil)
                    guard let autoDebitVC = storyboard.instantiateViewController(withIdentifier: "AutoDebitViewController") as? AutoDebitViewController
                        else {
                            return
                    }
                    self.presentNavigation(autoDebitVC, animated: true)
                }
                
                let continueAction = UIAlertAction(title: NSLocalizedString("CONTINUE PAYMENT", comment: ""), style: .default) { _ in
                    let storyboard = UIStoryboard(name: "Payment", bundle: nil)
                    if let paymentSummaryVC = storyboard.instantiateInitialViewController() {
                        paymentSummaryVC.modalPresentationStyle = .fullScreen
                        self.present(paymentSummaryVC, animated: true, completion: nil)
                    }
                }
                
                self.showAlertMessage(title: NSLocalizedString("Get RM2 off your monthly subscription", comment: ""), message: NSLocalizedString("When you pay with Auto Debit", comment: ""), actions: [setupAction, continueAction])
            }
        } else {
            let storyboard = UIStoryboard(name: "Payment", bundle: nil)
            if let paymentSummaryVC = storyboard.instantiateInitialViewController() {
                paymentSummaryVC.modalPresentationStyle = .fullScreen
                self.present(paymentSummaryVC, animated: true, completion: nil)
            }
        }
    }

    @IBAction func registerAutoDebit(_ sender: Any?) {
        let storyboard = UIStoryboard(name: "Payment", bundle: nil)
        guard let autoDebitVC = storyboard.instantiateViewController(withIdentifier: "AutoDebitViewController") as? AutoDebitViewController
            else {
                return
        }
        self.presentNavigation(autoDebitVC, animated: true)
    }
}
