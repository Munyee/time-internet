//
//  ForgetPasswordViewController.swift
//  TimeSelfCare
//
//  Created by Loka on 16/11/2017.
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import UIKit
import MBProgressHUD
import EasyTipView

internal class ForgetPasswordViewController: BaseAuthViewController {
    override var allRequiredTextFields: [VDTTextField] {
        return [accountTextField, usernameTextField]
    }

    private var tooltip: EasyTipView?

    @IBOutlet private weak var containerView: UIStackView!
    @IBOutlet private weak var accountTextField: VDTTextField!
    @IBOutlet private weak var accountIconButton: UIButton!
    @IBOutlet private weak var usernameTextField: VDTTextField!
    @IBOutlet private weak var usernameIconButton: UIButton!
    @IBOutlet private weak var resetPasswordButton: UIButton!
    @IBOutlet private weak var noteLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        let noteText = "An email will be sent to you in the next five minutes to reset your password. Otherwise, please get in touch with us at 1800 18 1818 or cs@time.com.my."
        let attributedString = NSMutableAttributedString(string: noteText, attributes: [NSAttributedString.Key.font: UIFont.getCustomFont(family: "DIN", style: .subheadline)])

        attributedString.addAttributes([NSAttributedString.Key.font: UIFont(name: "DIN-Bold", size: 16)], range: (noteText as NSString).range(of: "temporary password"))

        let linkAttributes: [NSAttributedString.Key : Any] = [
            .foregroundColor: UIColor.primary,
            .font: UIFont(name: "DIN-Bold", size: 16)
        ]
        attributedString.addAttributes(linkAttributes, range: (noteText as NSString).range(of: "cs@time.com.my"))
        attributedString.addAttributes(linkAttributes, range: (noteText as NSString).range(of: "1800 18 1818"))
        self.noteLabel.attributedText = attributedString

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTappedAttributedLabel(gesture:)))
        self.noteLabel.isUserInteractionEnabled = true
        self.noteLabel.addGestureRecognizer(tapGesture)
        self.accountTextField.setupPhoneKeyboard()
    }

    deinit {
        self.noteLabel.gestureRecognizers?.forEach { self.noteLabel.removeGestureRecognizer($0) }
    }

    override func updateUI() {
        self.resetPasswordButton.isEnabled = self.hasAllTextFieldFilled
        self.resetPasswordButton.backgroundColor = self.resetPasswordButton.isEnabled ? .primary : .grey2
    }

    @IBAction func resetPassword(_ sender: Any) {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = NSLocalizedString("Resetting password...", comment: "")
        APIClient.shared.forgetPassword(self.usernameTextField.inputText, accountNo: self.accountTextField.inputText) { response, error in
            hud.hide(animated: true)
            if let error = error {
                self.showAlertMessage(with: error)
                return
            }
            let dismissAction = UIAlertAction(title: NSLocalizedString("Dismiss", comment: ""), style: .default) { _ in
                self.dismiss(animated: true, completion: nil)
            }

            let message: String
            if let responseMessage = response?["message"] as? String, !responseMessage.isEmpty {
                message = responseMessage
            } else {
                message = NSLocalizedString("Temporary password has been sent to your registered email.", comment: "")
            }
            self.showAlertMessage(title: NSLocalizedString("Success", comment: ""), message: message, actions: [dismissAction])
        }
    }

    @IBAction func toggleTooltip(_ sender: UIButton) {
        if sender == self.tooltip?.presentingView {
            self.tooltip?.dismiss(gesture: nil)
            self.tooltip = nil
            return
        }

        let message: String = sender == self.usernameIconButton ? NSLocalizedString("Your username is your MyKad No./ Passport No./ Passport No./ Business Registration No. [BRN]", comment: "") : NSLocalizedString("Your account number can be found on the first page of your bill as shown in the sample here.\n\nFor Astro IPTV service, your account number if the 8 digits as shown in the sample here.", comment: "")
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.getCustomFont(family: "DIN", style: .caption1) ?? UIFont.preferredFont(forTextStyle: .caption1),
                                                        .foregroundColor: UIColor.white]
        let attributedString = NSMutableAttributedString(string: message, attributes: attributes)

        let underlineWord: String = "here"
        let separator: Character = " "
        if message.contains(underlineWord) {
            //            var locationCounts = 0
            let underlineAttribute: [NSAttributedString.Key: Any] = [.underlineColor : UIColor.white,
                                                                    .underlineStyle: NSUnderlineStyle.single.rawValue]

            var count = 0
            let ranges: [NSRange] = message.split(separator: separator).flatMap { subString -> NSRange? in
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

    func textFieldDidEndEditing(_ textField: UITextField) {
        self.tooltip?.dismiss(gesture: nil)
    }

    @objc
    func didTappedAttributedLabel(gesture: UITapGestureRecognizer) {
        let text = self.noteLabel.text ?? String()
        let phoneNumber = "1 800 18 1818"
        let email = "cs@time.com.my"
        let phoneNumberRange = (text as NSString).range(of: phoneNumber)
        let emailRange = (text as NSString).range(of: email)
        if gesture.didTapAttributedTextInLabel(label: self.noteLabel, inRange: phoneNumberRange),
            let url = URL(string: "tel://\(phoneNumber.replacingOccurrences(of: " ", with: ""))") {
            UIApplication.shared.open(url)
        } else if gesture.didTapAttributedTextInLabel(label: self.noteLabel, inRange: emailRange),
            let url = URL(string: "mailto://\(email)") {
            UIApplication.shared.open(url)
        }
    }

    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var string = string
        if string == "" {
            textField.deleteBackward()
        } else {
            if textField == self.usernameTextField {
                string = string.alphaNumeric()
            } else if textField == self.accountTextField {
                string = string.toIntegerOnly()
            }
            textField.insertText(string)
        }

        self.updateUI()
        return false
    }
}

extension BaseAuthViewController: EasyTipViewDelegate {
    func easyTipViewDidDismiss(_ tipView: EasyTipView, touchLocation: CGPoint?) {
        let normaAccountRange = (tipView.text.string as NSString).range(of: "Your account number can be found on the first page of your bill as shown in the sample here.")
        let astroAccountRange = (tipView.text.string as NSString).range(of: "or Astro IPTV service, your account number if the 8 digits as shown in the sample here.")
        guard let touchLocation = touchLocation else {
            return
        }
        let effectiveTouchLocation: CGPoint = CGPoint(x: touchLocation.x - tipView.preferences.positioning.textHInset - tipView.preferences.positioning.bubbleHInset, y: touchLocation.y - tipView.preferences.positioning.textVInset - tipView.preferences.positioning.bubbleVInset)

        if tipView.didTapped(text: tipView.text, inRange: normaAccountRange, locationOfTouch: effectiveTouchLocation),
            let url = URL(string: "https://selfcare.time.com.my/images/2_time_bill.png") {
            self.openWebView(with: url, tintColor: UIColor.primary)

        } else if tipView.didTapped(text: tipView.text, inRange: astroAccountRange, locationOfTouch: effectiveTouchLocation),
            let url = URL(string: "https://selfcare.time.com.my/images/3_astro_bill.png") {
            self.openWebView(with: url, tintColor: UIColor.primary)
        }
    }
}
