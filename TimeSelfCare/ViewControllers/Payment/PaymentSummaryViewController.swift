//
//  PaymentSummaryViewController.swift
//  TimeSelfCare
//
//  Created by Loka on 22/11/2017.
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import UIKit

internal class PaymentSummaryViewController: TimeBaseViewController {
    @IBOutlet private weak var scrollView: UIScrollView!

    @IBOutlet private weak var agreementLabel: UILabel!
    @IBOutlet private weak var agreementButton: UIButton!
    @IBOutlet private weak var paymentAmountTextField: UITextField!
    @IBOutlet private weak var paymentAmountSeparator: UIView!
    @IBOutlet private weak var totalAmountLabel: UILabel!
    @IBOutlet private weak var accountNumberLabel: UILabel!
    @IBOutlet private weak var paymentButton: UIButton!
    @IBOutlet private weak var errorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        Keyboard.addKeyboardChangeObserver(self)

        let emptySpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        self.paymentAmountTextField.font = UIFont(name: "DINCondensed-Bold", size: 60)

        let paymentDoneButton = UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: .plain, target: self.paymentAmountTextField, action: #selector(self.paymentAmountTextField.resignFirstResponder))
        self.paymentAmountTextField.setupToolBar(buttons: [emptySpace, paymentDoneButton])
        self.accountNumberLabel.text = AccountController.shared.selectedAccount?.accountNo

        if let bill = BillDataController.shared.getBills(account: AccountController.shared.selectedAccount).sorted(by: { previousBill, nextBill -> Bool in
            guard let previousBillDate = previousBill.invoiceDate,
                let nextBillDate = nextBill.invoiceDate else {
                    return false
            }
            return nextBillDate < previousBillDate
        }).first {
            self.totalAmountLabel.text = bill.totalOutstanding?.currencyString(withSymbol: bill.currency ?? "RM", minimumFractionDigits: 2, maximumFractionDigits: 2)
            self.paymentAmountTextField.text = bill.totalOutstanding?.currencyString(withSymbol: "", minimumFractionDigits: 2, maximumFractionDigits: 2)
        }

        let agreementGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTappedAttributedLabel(gesture:)))
        self.agreementLabel.isUserInteractionEnabled = true
        self.agreementLabel.addGestureRecognizer(agreementGesture)

        self.updateAgreement()
    }

    @IBAction func cancelPayment(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func respondToAgreement(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.updatePaymentButton()
    }

    private func updatePaymentButton() {
        self.paymentButton.isEnabled = self.agreementButton.isSelected &&
                                        self.errorLabel.isHidden
        self.paymentButton.backgroundColor = self.paymentButton.isEnabled ? UIColor.primary : UIColor.grey2
    }

    @IBAction func makePayment(_ sender: UIButton) {
        guard
            let amountString = paymentAmountTextField.text,
            let amount = Double(amountString.replacingOccurrences(of: ",", with: ""))
        else {
                return
        }
        guard let paymentVC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentViewController") as? PaymentViewController else {
                return
        }
        var parameters: [String: Any] = [:]
        let path = "make_payment"
        parameters["action"] = path
        parameters["username"] = AccountController.shared.profile.username
        parameters["account_no"] = AccountController.shared.selectedAccount?.accountNo
        parameters["token"] = APIClient.shared.getToken(forPath: path)
        parameters["amount"] = amount
        parameters["upgw"] = "yes"
        parameters["session_id"] = AccountController.shared.sessionId
        paymentVC.parameters = parameters
        paymentVC.title = NSLocalizedString("Make Payment", comment: "")
        self.presentNavigation(paymentVC, animated: true)
    }

    @objc
    func didTappedAttributedLabel(gesture: UITapGestureRecognizer) {
        let agreementKeyword = "Terms & Conditions"
        let fpxAgreementKeyword = "FPX's Terms & Conditions"
        if let agreementRange = (self.agreementLabel?.text as NSString?)?.range(of: agreementKeyword),
            gesture.didTapAttributedTextInLabel(label: self.agreementLabel, inRange: agreementRange) {
            openURL(withURLString: "http://www.time.com.my/terms-and-conditions")
        } else if let fpxAgreementRange = (self.agreementLabel?.text as NSString?)?.range(of: fpxAgreementKeyword),
            gesture.didTapAttributedTextInLabel(label: self.agreementLabel, inRange: fpxAgreementRange) {
            openURL(withURLString: "https://www.mepsfpx.com.my/FPXMain/termsAndConditions.jsp")
        }
    }

    private func updateAgreement() {
        let agreementText = "I agree to make a payment in accordance with the Terms & Conditions. "

        let attributedString = NSMutableAttributedString(string: agreementText)
        let attributes: [NSAttributedString.Key : Any] = [
            .foregroundColor: UIColor.primary,
            .font: UIFont.getCustomFont(family: "DIN", style: .caption1) ?? UIFont.preferredFont(forTextStyle: .body)
        ]
        attributedString.addAttributes(attributes, range: (agreementText as NSString).range(of: "Terms & Conditions"))

        self.agreementLabel.attributedText = attributedString
    }
}

extension PaymentSummaryViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField == self.paymentAmountTextField else {
            return true
        }
        let textContent: NSMutableString = NSMutableString(string: textField.text ?? "")
        textContent.replaceCharacters(in: range, with: string)
        textContent.replaceOccurrences(of: "\\D", with: "", options: String.CompareOptions.regularExpression, range: NSRange(location: 0, length: textContent.length))
        textContent.replacingOccurrences(of: "^0*", with: "", options: String.CompareOptions.regularExpression, range: NSRange(location: 0, length: textContent.length))

        let amount: Double = (Double(textContent as String) ?? 0) / 100
        self.paymentAmountTextField.text = amount.currencyString(withSymbol: "", minimumFractionDigits: 2, maximumFractionDigits: 2)

        self.updateErrorLabel(paymentAmount: amount)
        self.updatePaymentButton()
        return false
    }

    private func updateErrorLabel(paymentAmount: Double) {
        // Confirm new payment gateway's minimum payment amount
        let minimumAmount: Double = PaymentTypeDataController.shared.getPaymentTypes(account: AccountController.shared.selectedAccount).first { $0.typeId == .payment }?.minAmount ?? 2.00

        self.errorLabel.isHidden = paymentAmount >= minimumAmount
        self.errorLabel.text = String(format: NSLocalizedString("Minimum payment amount is RM%.2f", comment: ""), minimumAmount)

        self.paymentAmountSeparator.backgroundColor = self.errorLabel.isHidden ? UIColor.lightGray : UIColor.error
    }
}

extension PaymentSummaryViewController: KeyboardChangeObserver {
    func keyboardChanging(endHeight: CGFloat, duration: TimeInterval) {
        self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: endHeight, right: 0)
    }
}

extension UITextField {
    func setupToolBar(buttons: [UIBarButtonItem]) {
        let toolBar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        toolBar.backgroundColor = UIColor.white
        toolBar.items = buttons
        toolBar.sizeToFit()
        self.inputAccessoryView = toolBar
    }
}
