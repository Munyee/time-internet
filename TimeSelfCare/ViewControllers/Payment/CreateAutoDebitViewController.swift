//
//  CreateAutoDebitViewController.swift
//  TimeSelfCare
//
//  Created by Loka on 23/11/2017.
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import UIKit
import MBProgressHUD

internal class CreateAutoDebitViewController: TimeBaseViewController {
    var existingCreditCard: CreditCard?

    var requiredTextFields: [VDTTextField] {
        return [nameTextField,
                cardNumberTextField,
                securityCodeTextField,
                expiryTextField
        ]
    }

    var confirmationDidDismissAction: (() -> Void)?

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var cardTypeImageView: UIImageView!
    @IBOutlet private weak var accountNumberLabel: UILabel!
    @IBOutlet private weak var outstandingBalanceLabel: UILabel!
    @IBOutlet private weak var nameTextField: VDTTextField!
    @IBOutlet private weak var cardNumberTextField: VDTTextField!
    @IBOutlet private weak var securityCodeTextField: VDTTextField!
    @IBOutlet private weak var expiryTextField: VDTTextField!
    @IBOutlet private weak var submitButton: UIButton!
    @IBOutlet private weak var agreementButton: UIButton!
    @IBOutlet private weak var agreementLabel: UILabel!
    @IBOutlet private weak var privacyPolicyButton: UIButton!
    @IBOutlet private weak var privacyPolicyLabel: UILabel!
    @IBOutlet private weak var removeAutoDebitButton: UIButton!
    @IBOutlet private weak var creditCardErrorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        Keyboard.addKeyboardChangeObserver(self)
        self.setupUI()
        self.setupTextFieldsRules()
    }

    private func setupUI() {
        for (index, textField) in self.requiredTextFields.enumerated() {
            if textField.keyboardType == .numberPad {
                let doneButton = UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: .plain, target: self, action: #selector(self.textFieldDoneButtonTapped(_:)))
                doneButton.tag = index
                let emptySpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
                textField.setupToolBar(buttons: [emptySpace, doneButton])
            }
        }

        if let existingCreditCard = self.existingCreditCard {
            self.title = NSLocalizedString("Modify Auto Debit", comment: "")
            self.removeAutoDebitButton.isHidden = false
        } else {
            self.title = NSLocalizedString("Register for Auto Debit", comment: "")
            self.removeAutoDebitButton.isHidden = true
        }

        if let account = AccountController.shared.selectedAccount {
            if let title = account.title {
                self.accountNumberLabel.text = "\(account.accountNo) (\(title))"
            } else {
                self.accountNumberLabel.text = "\(account.accountNo)"
            }
            if let bill = BillDataController.shared.getBills(account: AccountController.shared.selectedAccount).first {
                self.outstandingBalanceLabel.text = "\(bill.currency ?? "RM") \(bill.totalOutstanding ?? 0.00)"
            }
        }
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: ""), style: .plain, target: self, action: #selector(self.cancel))
        if let creditCard = self.existingCreditCard {
            self.nameTextField.text = creditCard.ccName
        }

        let attributedAgreement = NSMutableAttributedString(string: self.agreementLabel.text ?? "", attributes: [NSAttributedString.Key.font: UIFont.getCustomFont(family: "DIN", style: .caption1)])
        attributedAgreement.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.primary], range: ((self.agreementLabel.text ?? "") as NSString).range(of: "Terms & Conditions"))
        self.agreementLabel.attributedText = attributedAgreement

        let attributedPrivacy = NSMutableAttributedString(string: self.privacyPolicyLabel.text ?? "", attributes: [NSAttributedString.Key.font: UIFont.getCustomFont(family: "DIN", style: .caption1)])
        attributedPrivacy.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.primary], range: ((self.privacyPolicyLabel.text ?? "") as NSString).range(of: "http://www.time.com.my/privacy-policy"))
        self.privacyPolicyLabel.attributedText = attributedPrivacy

        let agreementGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTappedAttributedLabel(gesture:)))
        self.agreementLabel.isUserInteractionEnabled = true
        self.agreementLabel.addGestureRecognizer(agreementGesture)

        let privacyGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTappedAttributedLabel(gesture:)))
        self.privacyPolicyLabel.isUserInteractionEnabled = true
        self.privacyPolicyLabel.addGestureRecognizer(privacyGesture)
    }

    private func setupTextFieldsRules() {
        let emptyErrorMessage = String()
        nameTextField.rulesMapping = [({ !$0.isEmpty }, emptyErrorMessage)]
        cardNumberTextField.rulesMapping = [({ $0.count == 16 && [.mastercard, .visa].contains($0.inferredCreditCardType()) }, emptyErrorMessage)]
        securityCodeTextField.rulesMapping = [({ $0.count == 3 }, emptyErrorMessage)]
        expiryTextField.rulesMapping = [({ $0.count == 5 }, emptyErrorMessage)]
    }

    @objc
    func cancel() {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func respondToAgreement(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.updateUI()
    }

    func updateUI() {
        if let cardNumber = self.cardNumberTextField.text {
            switch true {
            case cardNumber.inferredCreditCardType() == .mastercard && cardNumber.count <= 16:
                self.cardTypeImageView.image = #imageLiteral(resourceName: "ic_debit_mastercard")
            case cardNumber.inferredCreditCardType() == .visa && cardNumber.count <= 16:
                self.cardTypeImageView.image = #imageLiteral(resourceName: "ic_debit_visa")
            default:
                self.cardTypeImageView.image = #imageLiteral(resourceName: "ic_debit_card_default_big")
            }

            self.creditCardErrorLabel.isHidden = (cardNumber.count == 16 && cardNumber.inferredCreditCardType() != .unknown) || cardNumber.isEmpty
        }

        self.removeAutoDebitButton.isHidden = self.existingCreditCard == nil
        self.updateSubmitButton()
    }

    private func updateSubmitButton() {
        self.submitButton.isEnabled = self.requiredTextFields.reduce(self.agreementButton.isSelected && self.privacyPolicyButton.isSelected) {
            $0 && $1.isInputTextValid
        }
        self.submitButton.backgroundColor = self.submitButton.isEnabled ? .primary : .grey2
    }

    @IBAction func showCardScanner(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Payment", bundle: nil)
        if let scanCardVC = storyboard.instantiateViewController(withIdentifier: "ScanCardViewController") as? ScanCardViewController {
            scanCardVC.delegate = self
            self.presentNavigation(scanCardVC, animated: true)
        }
    }

    @objc
    func didTappedAttributedLabel(gesture: UITapGestureRecognizer) {
        let agreementKeyword = "Terms & Conditions"
        if let agreementRange = (self.agreementLabel?.text as NSString?)?.range(of: agreementKeyword) {
            if gesture.didTapAttributedTextInLabel(label: self.agreementLabel, inRange: agreementRange) {
                let url: String = AccountController.shared.profile.accounts.compactMap { $0.custSegment }.contains(.business)
                    ? "https://www.time.com.my/terms-and-conditions?title=small-business#auto-debit"
                    : "https://www.time.com.my/terms-and-conditions?title=consumer#auto-debit"

                openURL(withURLString: url)
                return
            }
        }

        let privacyPolicyLink = "http://www.time.com.my/privacy-policy"
        if let privacyPolicyRange = (self.privacyPolicyLabel?.text as NSString?)?.range(of: privacyPolicyLink) {
            if gesture.didTapAttributedTextInLabel(label: self.privacyPolicyLabel, inRange: privacyPolicyRange) {
                openURL(withURLString: privacyPolicyLink)
                return
            }
        }
    }

    @IBAction func registerAutoDebit(_ sender: Any) {
        guard let paymentVC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentViewController") as? PaymentViewController else {
            return
        }
        let billAmount = BillDataController.shared.getBills(account: AccountController.shared.selectedAccount).first?.totalOutstanding
        var parameters: [String: Any] = [:]
        let path = "make_payment_autodebit"
        parameters["action"] = path
        parameters["username"] = AccountController.shared.profile?.username
        parameters["account_no"] = AccountController.shared.selectedAccount?.accountNo
        parameters["token"] = APIClient.shared.getToken(forPath: path)
        parameters["amount"] = "\(billAmount?.isZero ?? true ? 1.00 : billAmount!)" // swiftlint:disable:this force_unwrapping
        parameters["autodebit_payment"] = (billAmount?.isZero ?? true) ? "verify_cc" : "bill_payment"
        parameters["autodebit_action"] = existingCreditCard == nil ? "new" : "modify"
        parameters["cc_no"] = self.cardNumberTextField.inputText

        let key: String = self.cardNumberTextField.inputText.inferredCreditCardType() == .mastercard ? mastercardIdKey : visaIdKey
        parameters["cc_type_id"] = Installation.current().valueForKey(key) as? String
        parameters["cc_name"] = self.nameTextField.inputText
        parameters["cc_expiry_month"] = self.expiryTextField.text?.split(separator: "/").first
        parameters["cc_expiry_year"] = self.expiryTextField.text?.split(separator: "/").last
        parameters["cc_cvv_no"] = self.securityCodeTextField.inputText
        parameters["session_id"] = AccountController.shared.sessionId
        paymentVC.parameters = parameters
        paymentVC.title = NSLocalizedString("Register Auto Debit", comment: "")
        paymentVC.transactionFailedBlock = {
            self.presentedViewController?.dismissVC()
        }
        paymentVC.transactionSuccessBlock = {
            self.presentedViewController?.dismiss(animated: false) {
                self.showSuccessConfirmation()
            }
        }

        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { _ in
             self.presentNavigation(paymentVC, animated: true)
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .default, handler: nil)

        let alertTitle = (billAmount?.isZero ?? true) ? NSLocalizedString("RM1 Deduction", comment: "") : NSLocalizedString("Clear Payment", comment: "")
        let alertMessage = (billAmount?.isZero ?? true) ? NSLocalizedString("To verify your card, RM 1 will be charged and reversed on the same day.", comment: ""):
            String(format: NSLocalizedString("There's an outstanding amount of %.2f on your account. This will be charged to your card. Should you proceed?", comment: ""), billAmount ?? 0)
        self.showAlertMessage(title: alertTitle, message: alertMessage, actions: [cancelAction, okAction])
    }

    func showSuccessConfirmation() {
        let storyboard = UIStoryboard(name: "Common", bundle: nil)
        if let confirmationVC = storyboard.instantiateViewController(withIdentifier: "ConfirmationViewController") as? ConfirmationViewController {
            confirmationVC.mode = .autodebitAdded
            confirmationVC.actionBlock = {
                self.presentingViewController?.dismiss(animated: false, completion: nil)
                self.confirmationDidDismissAction?()
            }
            confirmationVC.modalPresentationStyle = .fullScreen
            self.present(confirmationVC, animated: true, completion: nil)
        }
    }

    func showRemovedConfirmation() {
        let storyboard = UIStoryboard(name: "Common", bundle: nil)
        if let confirmationVC = storyboard.instantiateViewController(withIdentifier: "ConfirmationViewController") as? ConfirmationViewController {
            confirmationVC.mode = .autodebitRemoved
            confirmationVC.actionBlock = {
                self.presentingViewController?.dismiss(animated: false, completion: nil)
                self.confirmationDidDismissAction?()
            }
            confirmationVC.modalPresentationStyle = .fullScreen
            self.present(confirmationVC, animated: true, completion: nil)
        }
    }

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
}

extension CreateAutoDebitViewController: UITextFieldDelegate {
    @objc
    func textFieldDoneButtonTapped(_ sender: Any) {
        guard let index = (sender as? UIBarButtonItem)?.tag else {
            return
        }

        self.findNextResponder(self.requiredTextFields[index])
    }

    func findNextResponder(_ textField: UITextField) {

        let textFields: [VDTTextField] = self.requiredTextFields
        let index: Int = textFields.index { $0 == textField } ?? 0

        // Go to next required field
        if index < textFields.count - 1 {
            textFields[index + 1].becomeFirstResponder()
        } else if !(textFields.filter { $0.inputText.isEmpty }).isEmpty {
            // Loop back to first required field if not all is filled
            textFields.first?.becomeFirstResponder()
        } else {
            self.view.endEditing(true)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.findNextResponder(textField)
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField == self.expiryTextField else {
            let nsString = textField.text as NSString?
            let newString = nsString?.replacingCharacters(in: range, with: string)

            if textField == self.securityCodeTextField && (newString?.count ?? 0) > 3 {
                return false
            }

            textField.text = newString
            self.updateUI()
            return false
        }

        var textContent: NSMutableString = NSMutableString(string: textField.text ?? "")
        textContent.replaceCharacters(in: range, with: string)
        if textContent.length > 5 {
            return false
        }

        let expiryDateDigits = textContent.replacingOccurrences(of: "\\D", with: "", options: NSString.CompareOptions.regularExpression, range: NSRange(location: 0, length: textContent.length))
        if string != "" && textContent.length >= 2 && !textContent.contains("/") {
            textContent = NSMutableString(string: expiryDateDigits)
            textContent.insert("/", at: 2)
        }

        self.expiryTextField.text = textContent as String

        self.updateUI()
        return false
    }
}

extension CreateAutoDebitViewController: ScanCardViewControllerDelegate {
    func scanCardViewController(didScanCardInfo cardInfo: CardIOCreditCardInfo) {
        self.cardNumberTextField.text = cardInfo.cardNumber
        self.updateUI()
    }
}

extension CreateAutoDebitViewController: KeyboardChangeObserver {
    func keyboardChanging(endHeight: CGFloat, duration: TimeInterval) {
        self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: endHeight, right: 0)
    }
}
