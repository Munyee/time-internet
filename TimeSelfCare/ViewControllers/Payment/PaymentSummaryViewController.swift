//
//  PaymentSummaryViewController.swift
//  TimeSelfCare
//
//  Created by Loka on 22/11/2017.
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import UIKit

internal class PaymentSummaryViewController: TimeBaseViewController {

    private var paymentButtons: [UIButton] {
        return [creditCardButton, bankingButton]
    }

    private var selectedPaymentType: PaymentType.TypeId {
        if creditCardButton.isSelected {
            return PaymentType.TypeId.cc
        } else if bankingButton.isSelected {
            return PaymentType.TypeId.fpx
        } else {
            return PaymentType.TypeId.unknown
        }
    }

    private var banks: [Bank] {
        return BankDataController.shared.getBanks().sorted {
            guard let previousBankName = $0.name,
                let nextBankName = $1.name else {
                    return false
            }
            return previousBankName < nextBankName
        }
    }

    private var selectedBank: Bank?

    @IBOutlet private weak var scrollView: UIScrollView!

    @IBOutlet private weak var agreementLabel: UILabel!
    @IBOutlet private weak var agreementButton: UIButton!
    @IBOutlet private weak var paymentAmountTextField: UITextField!
    @IBOutlet private weak var paymentAmountSeparator: UIView!
    @IBOutlet private weak var totalAmountLabel: UILabel!
    @IBOutlet private weak var accountNumberLabel: UILabel!
    @IBOutlet private weak var creditCardButton: UIButton!
    @IBOutlet private weak var bankingButton: UIButton!
    @IBOutlet private weak var paymentButton: UIButton!
    @IBOutlet private weak var bankSelectionTextField: UITextField!
    @IBOutlet private weak var errorLabel: UILabel!
    private weak var bankPickerView: UIPickerView?

    override func viewDidLoad() {
        super.viewDidLoad()
        Keyboard.addKeyboardChangeObserver(self)

        let bankCancelButton = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: ""), style: .plain, target: self.bankSelectionTextField, action: #selector(self.bankSelectionTextField.resignFirstResponder))
        let bankDoneButton = UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: .plain, target: self, action: #selector(self.selectBankRow))
        let emptySpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        self.bankSelectionTextField.setupToolBar(buttons: [bankCancelButton, emptySpace, bankDoneButton])
        self.paymentAmountTextField.font = UIFont(name: "DINCondensed-Bold", size: 60)

        let paymentDoneButton = UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: .plain, target: self.paymentAmountTextField, action: #selector(self.paymentAmountTextField.resignFirstResponder))
        self.paymentAmountTextField.setupToolBar(buttons: [emptySpace, paymentDoneButton])
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        self.bankSelectionTextField.inputView = pickerView
        self.bankPickerView = pickerView

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

        self.creditCardButton.isSelected = true
        self.updateAgreement()
    }

    @IBAction func cancelPayment(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func choosePayment(_ sender: UIButton) {
        self.paymentButtons.forEach { $0?.isSelected = sender == $0 }
        self.bankSelectionTextField.isHidden = !self.bankingButton.isSelected
        self.updatePaymentButton()
        self.updateAgreement()
    }

    @IBAction func respondToAgreement(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.updatePaymentButton()
    }

    private func updatePaymentButton() {
        self.paymentButton.isEnabled = (selectedPaymentType == .cc ||
                                        (selectedPaymentType == .fpx && selectedBank != nil)) &&
                                        self.agreementButton.isSelected &&
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
        parameters["payment_type"] = self.selectedPaymentType.rawValue
        parameters["bank_id"] = self.selectedBank?.bankId
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

    @objc
    public func selectBankRow() {
        let row = self.bankPickerView?.selectedRow(inComponent: 0) ?? 0
        self.selectedBank = self.banks[row]
        self.bankSelectionTextField.resignFirstResponder()
        self.bankSelectionTextField.text = self.selectedBank?.name
        self.updatePaymentButton()
    }

    private func updateAgreement() {
        var agreementText = "I agree to make a payment in accordance with the Terms & Conditions. "
        if selectedPaymentType == .fpx {
            agreementText.append("By clicking on the \"Make Payment\" button below, you agree to FPX's Terms & Conditions.")
        }
        let attributedString = NSMutableAttributedString(string: agreementText)
        let attributes: [NSAttributedString.Key : Any] = [
            .foregroundColor: UIColor.primary,
            .font: UIFont.getCustomFont(family: "DIN", style: .caption1) ?? UIFont.preferredFont(forTextStyle: .body)
        ]
        attributedString.addAttributes(attributes, range: (agreementText as NSString).range(of: "Terms & Conditions"))
        attributedString.addAttributes(attributes, range: (agreementText as NSString).range(of: "FPX's Terms & Conditions"))
        self.agreementLabel.attributedText = attributedString
    }
}

extension PaymentSummaryViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.banks.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.banks[row].name
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
        let minimumAmount: Double = PaymentTypeDataController.shared.getPaymentTypes(account: AccountController.shared.selectedAccount).first { $0.typeId == selectedPaymentType }?.minAmount ?? 1.00
        self.errorLabel.isHidden = paymentAmount >= minimumAmount
        self.errorLabel.text = String(format: NSLocalizedString("Minimum payment for \(selectedPaymentType == .fpx ?  "fpx" : "Debit / Credit Card") is RM%.2f", comment: ""), minimumAmount)

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
