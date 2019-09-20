//  .swift
//  
//
//  Generated by Operahouse using Auth - Sign Up View Controller
//  Template last updated 2017-11-01
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import UIKit
import MBProgressHUD
import EasyTipView

internal class SignUpViewController: BaseAuthViewController {
    override var allRequiredTextFields: [VDTTextField] {
        return [accountNumberTextField, myKadNoTextField, createPasswordTextField, confirmPasswordTextField]
    }
    private var tooltip: EasyTipView?
    private var gesture: UITapGestureRecognizer?
    private var job: DispatchWorkItem?

    private var accountNumberErrorMessage: String? {
        return (self.accountNumberTextField.text?.isEmpty ?? false) || (self.accountNumberTextField.text?.count ?? 0 >= 8 && self.accountNumberTextField.text?.count ?? 0 <= 12) ? nil : NSLocalizedString("Valid account numbers should have 8 to 12 characters", comment: "")
    }

    private var passwordErrorMessage: String? {
        return (self.createPasswordTextField.text?.isAlphanumeric ?? false) || (self.createPasswordTextField.text?.isEmpty ?? false) ? nil : NSLocalizedString("Special characters are not allowed.", comment: "" )
    }

    private var confirmationErrorMessage: String? {
        return self.createPasswordTextField.text == self.confirmPasswordTextField.text || (self.confirmPasswordTextField.text?.isEmpty ?? false) ? nil : NSLocalizedString("These passwords do not match. Please check and try again.", comment: "")
    }

    @IBOutlet private weak var containerView: UIStackView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var accountNumberTextField: VDTTextField!
    @IBOutlet private weak var myKadNoTextField: VDTTextField!
    @IBOutlet private weak var createPasswordTextField: VDTTextField!
    @IBOutlet private weak var confirmPasswordTextField: VDTTextField!
    @IBOutlet private weak var registerButton: UIButton!
    @IBOutlet private weak var agreementCheckButton: UIButton!
    @IBOutlet private weak var accountIconButton: UIButton!
    @IBOutlet private weak var passwordIconButton: UIButton!
    @IBOutlet private weak var usernameIconButton: UIButton!
    @IBOutlet private weak var confirmPasswordIconButton: UIButton!
    @IBOutlet private weak var confirmationErrorLabel: UILabel!
    @IBOutlet private weak var accountNumberErrorLabel: UILabel!
    @IBOutlet private weak var passwordErrorLabel: UILabel!
    @IBOutlet private weak var termsLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        Keyboard.addKeyboardChangeObserver(self)
        let termsText = NSLocalizedString("I have read, understand and agree to be bound by the Terms & Conditions.", comment: "")
        let attributedString = NSMutableAttributedString(string: termsText)
        let attributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.primary,
            NSAttributedString.Key.font: UIFont.getCustomFont(family: "DIN", style: .body) ?? UIFont.preferredFont(forTextStyle: .body)
        ]
        attributedString.addAttributes(attributes, range: (termsText as NSString).range(of: NSLocalizedString("Terms & Conditions", comment: "")))
        self.termsLabel.attributedText = attributedString
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTappedAttributedLabel(gesture:)))
        self.termsLabel.isUserInteractionEnabled = true
        self.termsLabel.addGestureRecognizer(tapGesture)
        self.accountNumberTextField.setupPhoneKeyboard()
    }

    func checkPasswordStrength() {
        let password = self.createPasswordTextField.inputText
        APIClient.shared.verifyPasswordStrength(password) { passwordStrength in
            if password == self.self.createPasswordTextField.inputText {
                self.passwordErrorLabel.text = String.localizedStringWithFormat("Password Strength: %@", passwordStrength ?? "")
                self.passwordErrorLabel.isHidden = false
            }
        }
    }

    @IBAction func signUp(_ sender: Any) {
        guard self.hasAllTextFieldFilled
        else {
            self.showAlertMessage(title: NSLocalizedString("Required Fields", comment: ""), message: NSLocalizedString("All fields are required in order to proceed with sign up.", comment: ""))
            return
        }

        guard self.createPasswordTextField.inputText == self.confirmPasswordTextField.inputText else {
            self.showAlertMessage(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("Password does not match, please try again.", comment: ""), actions: [UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil)])
            return
        }
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = NSLocalizedString("Signing Up...", comment: "")

        APIClient.shared.signUp(
            icNumber: self.myKadNoTextField.inputText,
            accountNumber: self.accountNumberTextField.inputText,
            password: self.createPasswordTextField.inputText
        ) { (error: Error?) in
            hud.hide(animated: true)
            if let error = error {
                self.showAlertMessage(with: error)
                return
            }
            Installation.current().set(false, forKey: hasShownWalkthroughKey)

            self.dismiss(animated: true, completion: nil)
        }
    }

    @objc
    func didTappedAttributedLabel(gesture: UITapGestureRecognizer) {
        let fullText = self.termsLabel.text ?? String()
        let termsText = "Terms & Conditions"
        let termsRange = (fullText as NSString).range(of: termsText)
        if gesture.didTapAttributedTextInLabel(label: self.termsLabel, inRange: termsRange) {
            self.showTermAndConditions()
        }
    }

    func showTermAndConditions() {
        openURL(withURLString: "http://www.time.com.my/terms-and-conditions")
    }

    @IBAction func toggleAgreementCheck(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.updateUI()
    }

    @IBAction func toggleTextFieldVisibility(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        [createPasswordTextField, confirmPasswordTextField].forEach { textField in
            if textField?.tag == sender.tag {
                textField?.isSecureTextEntry = !(textField?.isSecureTextEntry ?? false)
            }
        }
    }

    @IBAction func toggleTooltip(_ sender: UIButton) {
        if sender == self.tooltip?.presentingView {
            self.tooltip?.dismiss(gesture: nil)
            self.tooltip = nil
            return
        }
        var message: String = String()
        switch sender {
        case self.usernameIconButton:
            message = NSLocalizedString("Your username is your MyKad No./ Passport No./ Passport No./ Business Registration No. [BRN]", comment: "")
        case self.accountIconButton:
            message = NSLocalizedString("Your account number can be found on the first page of your bill as shown in the sample here.\n\nFor Astro IPTV service, your account number if the 8 digits as shown in the sample here.", comment: "")
        case self.passwordIconButton, confirmPasswordIconButton:
            message = NSLocalizedString("Special characters are not allowed.", comment: "")
        default:
            break
        }
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.getCustomFont(family: "DIN", style: .caption1) ?? UIFont.preferredFont(forTextStyle: .caption1),
                                                         NSAttributedString.Key.foregroundColor: UIColor.white]
        let attributedString = NSMutableAttributedString(string: message, attributes: attributes)

        let underlineWord: String = "here"
        let separator: Character = " "
        if message.contains(underlineWord) {
            //            var locationCounts = 0
            let underlineAttribute: [NSAttributedString.Key: Any] = [.underlineColor : UIColor.white,
                                                                     .underlineStyle: NSUnderlineStyle.single.rawValue]

            var count = 0
            let ranges: [NSRange] = message.split(separator: separator).compactMap { subString -> NSRange? in
                var subrange = (subString as NSString).localizedStandardRange(of: underlineWord)
                guard subrange.location != NSNotFound else {
                    count += (subString.count + 1)
                    return nil
                }
                subrange.location += count
                count += (subString.count + 1)
                return subrange
            }

            ranges.forEach {
                attributedString.addAttributes(underlineAttribute, range: $0)
            }
        }
        var preferences = EasyTipView.Preferences()
        preferences.drawing.backgroundColor = UIColor.black
        preferences.positioning.maxWidth = containerView.bounds.width
        preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.top
        let tooltip = EasyTipView(text: attributedString, preferences: preferences, delegate: self)
        self.tooltip?.dismiss(gesture: nil)
        self.tooltip = tooltip
        self.tooltip?.show(animated: true, forView: sender, withinSuperview: self.containerView)
    }

    override func updateUI() {
        let errorMessages = [passwordErrorMessage, confirmationErrorMessage, accountNumberErrorMessage]
        registerButton.isEnabled = self.hasAllTextFieldFilled && self.agreementCheckButton.isSelected && errorMessages.reduce(true) { $0 && ($1 == nil) }
        registerButton.backgroundColor = registerButton.isEnabled ? UIColor.primary : UIColor.grey2
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        self.tooltip?.dismiss(gesture: nil)
        self.confirmationErrorLabel.text = self.confirmationErrorMessage
        self.confirmationErrorLabel.isHidden = self.confirmationErrorMessage == nil
        self.passwordErrorLabel.text = self.passwordErrorMessage ?? self.passwordErrorLabel.text
        self.passwordErrorLabel.isHidden = self.passwordErrorLabel.text?.isEmpty ?? true
        self.accountNumberErrorLabel.text = self.accountNumberErrorMessage
        self.accountNumberErrorLabel.isHidden = self.accountNumberErrorMessage == nil
        self.updateUI()
    }

    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var string = string

        if string == "" {
            textField.deleteBackward()
        } else {
            if textField == self.confirmPasswordTextField || textField == self.createPasswordTextField {
                string = string.alphaNumeric()
            } else if textField == self.accountNumberTextField {
                string = string.toIntegerOnly()
            }
            textField.insertText(string)
        }

        if textField == self.createPasswordTextField {
            self.job?.cancel()
            if textField.text?.isEmpty ?? true {
                self.passwordErrorLabel.text = self.passwordErrorMessage
                self.passwordErrorLabel.isHidden = self.passwordErrorLabel.text?.isEmpty ?? true
            } else {
                self.job = DispatchWorkItem(block: self.checkPasswordStrength)
                DispatchQueue.global(qos: .background).asyncAfter(deadline: DispatchTime.now() + 0.3, execute: self.job!) // swiftlint:disable:this force_unwrapping
            }
        }

        self.updateUI()
        return false
    }
}

extension SignUpViewController: KeyboardChangeObserver {
    func keyboardChanging(endHeight: CGFloat, duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: endHeight + 16, right: 0)
            self.view.layoutIfNeeded()
        }
    }
}
