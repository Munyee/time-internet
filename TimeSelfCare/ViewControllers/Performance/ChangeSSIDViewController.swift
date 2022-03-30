//
//  ChangeSSIDViewController.swift
//  TimeSelfCare
//
//  Created by Loka on 17/05/2018.
//  Copyright © 2018 Apptivity Lab. All rights reserved.
//

import UIKit

class ChangeSSIDViewController: TimeBaseViewController {

    @IBOutlet private weak var submitButton: UIButton!
    @IBOutlet private weak var ssidNameTextField: VDTTextField!
    @IBOutlet private weak var ssidConfirmPasswordTextField: VDTTextField!
    @IBOutlet private weak var ssidPasswordTextField: VDTTextField!
    @IBOutlet private weak var passwordVisibilityButton: UIButton!
    @IBOutlet private weak var confirmPasswordVisibilityButton: UIButton!
    @IBOutlet private weak var ssidErrorLabel: UILabel!
    @IBOutlet private weak var passwordErrorLabel: UILabel!
    @IBOutlet private weak var confirmPasswordErrorLabel: UILabel!
    @IBOutlet private weak var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back_arrow"), style: .plain, target: self, action: #selector(self.dismissVC(_:)))
        self.title = NSLocalizedString("Change SSID", comment: "")
        Keyboard.addKeyboardChangeObserver(self)
    }

    @IBAction func togglePasswordVisibiity(_ sender: UIButton) {
        let textField: UITextField = sender == passwordVisibilityButton ? self.ssidPasswordTextField : self.ssidConfirmPasswordTextField
        textField.isSecureTextEntry = !textField.isSecureTextEntry
        let image = textField.isSecureTextEntry ? #imageLiteral(resourceName: "ic_visibility") : #imageLiteral(resourceName: "ic_hide_visibility")
        sender.setImage(image, for: .normal)
    }

    @IBAction func changeSsid(_ sender: Any) {
        let account = AccountController.shared.selectedAccount
        guard let ssid = SsidDataController.shared.getSsids(account: account).first else {
            // TODO: handle error here.
            return
        }
        let hud = LoadingView().addLoading(toView: self.view)
        hud.showLoading()

        ssid.name = self.ssidNameTextField.text
        ssid.password = self.ssidPasswordTextField.text

        SsidDataController.shared.updateSsid(ssid: ssid) { _, error in
            hud.hideLoading()
            if let error = error {
                self.showAlertMessage(with: error)
                return
            }

            let confirmationVC: ConfirmationViewController = UIStoryboard(name: TimeSelfCareStoryboard.common.filename, bundle: nil).instantiateViewController()
            confirmationVC.mode = .infoUpdated
            confirmationVC.actionBlock = {
                self.dismissVC()
            }
            confirmationVC.modalPresentationStyle = .fullScreen
            self.present(confirmationVC, animated: true, completion: nil)
        }
    }

    @IBAction func handleTextChange(_ sender: UITextField) {
        let inputText: String = sender.text ?? ""
        switch sender {
        case self.ssidNameTextField:
            if inputText.isEmpty {
                self.ssidErrorLabel.isHidden = true
            } else {
                if inputText.count < 8 || inputText.count > 20 {
                    self.ssidErrorLabel.text = NSLocalizedString("Your WiFi Network Name (SSID) must be at least 8 but no more than 20 characters in length", comment: "")
                } else if inputText.contains(",") {
                    ssidErrorLabel.text = NSLocalizedString("Your WiFi Network Name (SSID) must not contain a comma (,)", comment: "")
                } else {
                    ssidErrorLabel.text = String()
                }
                self.ssidErrorLabel.isHidden = (ssidErrorLabel.text ?? "").isEmpty
            }
        case self.ssidPasswordTextField:
            if inputText.isEmpty {
                self.passwordErrorLabel.isHidden = true
            } else {
                if inputText.count < 8 || inputText.count > 32 {
                    self.passwordErrorLabel.text = NSLocalizedString("Your password must be at least 8 but no more than 32 characters in length.", comment: "")
                } else if inputText.contains(",") {
                    passwordErrorLabel.text = NSLocalizedString("Your password must not contain a comma (,)", comment: "")
                } else {
                    passwordErrorLabel.text = String()
                }
                self.passwordErrorLabel.isHidden = (passwordErrorLabel.text ?? "").isEmpty
                if !(self.ssidConfirmPasswordTextField.text ?? "").isEmpty {
                    self.confirmPasswordErrorLabel.text = self.ssidConfirmPasswordTextField.text == self.ssidPasswordTextField.text ? nil : NSLocalizedString("These passwords do not match. Please check and try again.", comment: "")
                    self.confirmPasswordErrorLabel.isHidden = (self.confirmPasswordErrorLabel.text ?? "").isEmpty
                }
            }
        case self.ssidConfirmPasswordTextField:
            if inputText.isEmpty {
                self.confirmPasswordErrorLabel.isHidden = true
            } else {
                self.confirmPasswordErrorLabel.text = self.ssidConfirmPasswordTextField.text == self.ssidPasswordTextField.text ? nil : NSLocalizedString("These passwords do not match. Please check and try again.", comment: "")
                self.confirmPasswordErrorLabel.isHidden = (self.confirmPasswordErrorLabel.text ?? "").isEmpty
            }
        default:
            break
        }

        let textFields: [UITextField] = [self.ssidNameTextField, self.ssidPasswordTextField, self.ssidConfirmPasswordTextField]
        let hasFilledAll: Bool = textFields.reduce(true) { $0 && !($1.text?.isEmpty ?? true) }

        self.submitButton.isEnabled = hasFilledAll && self.ssidErrorLabel.isHidden && self.passwordErrorLabel.isHidden && self.confirmPasswordErrorLabel.isHidden
        self.submitButton.backgroundColor = self.submitButton.isEnabled ? .primary : .grey2
    }
}

extension ChangeSSIDViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let textFields = [self.ssidNameTextField, self.ssidPasswordTextField]
        if textField.returnKeyType == .done {
            textField.resignFirstResponder()
        } else {
            (textFields.first { $0 != textField })??.becomeFirstResponder()
        }
        return true
    }
}

extension ChangeSSIDViewController: KeyboardChangeObserver {
    func keyboardChanging(endHeight: CGFloat, duration: TimeInterval) {
        self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: endHeight, right: 0)
    }
}
