//
//  ChangePasswordViewController.swift
//  TimeSelfCare
//
//  Created by Loka on 29/11/2017.
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import UIKit
import MBProgressHUD

internal class ChangePasswordViewController: BaseAuthViewController {
    override var allRequiredTextFields: [VDTTextField] {
        return [self.currentPasswordTextField,
                self.newPasswordTextField,
                self.confirmNewPasswordTextField]
    }

    private var confirmationErrorMessage: String? {
        return self.newPasswordTextField.text == self.confirmNewPasswordTextField.text || (self.confirmNewPasswordTextField.text?.isEmpty ?? false) ? nil : NSLocalizedString("These passwords do not match. Please check and try again.", comment: "")
    }

    private var job: DispatchWorkItem?

    @IBOutlet private weak var currentPasswordTextField: VDTTextField!
    @IBOutlet private weak var newPasswordTextField: VDTTextField!
    @IBOutlet private weak var newPasswordErrorLabel: UILabel!
    @IBOutlet private weak var confirmNewPasswordTextField: VDTTextField!
    @IBOutlet private weak var confirmNewPasswordErrorLabel: UILabel!
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Change Password", comment: "")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back_arrow"), style: .plain, target: self, action: #selector(self.cancelChangePassword))

        Keyboard.addKeyboardChangeObserver(self)
    }

    override func updateUI() {
        self.saveButton.isEnabled = self.hasAllTextFieldFilled && self.confirmationErrorMessage == nil
        self.saveButton.backgroundColor = self.saveButton.isEnabled ? .primary : .grey2
    }

    @IBAction func toggleSecureTextVisibility(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let textField = self.allRequiredTextFields[sender.tag]
        textField.isSecureTextEntry = !textField.isSecureTextEntry
    }

    @objc
    func cancelChangePassword() {
        self.navigationController?.popViewController(animated: true)
    }

    func checkPasswordStrength() {
        if !self.newPasswordTextField.inputText.isEmpty {
            let password = self.newPasswordTextField.inputText
            APIClient.shared.verifyPasswordStrength(password) { passwordStrength in
                if password == self.newPasswordTextField.inputText {
                    self.newPasswordErrorLabel.text = String.localizedStringWithFormat("Password Strength: %@", passwordStrength ?? "")
                    self.newPasswordErrorLabel.isHidden = false
                }
            }
        } else {
            self.newPasswordErrorLabel.isHidden = true
        }

    }

    @IBAction func changePassword(_ sender: Any) {
        guard let username = AccountController.shared.selectedAccount?.profile?.username else {
            let error = NSError(domain: "TimeSelfCare", code: 500, userInfo: [NSLocalizedDescriptionKey: "Unexpected error has occured. Please try again later."])
            self.showAlertMessage(with: error)
            return
        }
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = NSLocalizedString("Changing Password..", comment: "")

        APIClient.shared.changePassword(username, currentPassword: self.currentPasswordTextField.inputText, newPassword: self.newPasswordTextField.inputText) { (error: Error?) in
            hud.hide(animated: true)
            if let error = error {
                self.showAlertMessage(with: error)
                return
            }
            let alertTitle = NSLocalizedString("Success", comment: "")
            let alertMessage = NSLocalizedString("You have successfully changed your password.", comment: "")
            let dismissAction = UIAlertAction(title: NSLocalizedString("Dismiss", comment: ""), style: .default) { _ in
                self.dismissVC()
            }
            self.showAlertMessage(title: alertTitle, message: alertMessage, actions: [dismissAction])
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        self.confirmNewPasswordErrorLabel.text = self.confirmationErrorMessage
        self.confirmNewPasswordErrorLabel.isHidden = self.confirmationErrorMessage == nil

    }

    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {
            textField.deleteBackward()
        } else {
            textField.insertText(string.alphaNumeric())
        }

        if textField == self.newPasswordTextField {
            self.job?.cancel()
            if textField.text?.isEmpty ?? true {
                self.newPasswordErrorLabel.isHidden = true
            } else {
                self.job = DispatchWorkItem(block: self.checkPasswordStrength)
                DispatchQueue.global(qos: .background).asyncAfter(deadline: DispatchTime.now() + 0.3, execute: self.job!) // swiftlint:disable:this force_unwrapping
            }
        }
        self.updateUI()
        return false
    }
}

extension ChangePasswordViewController: KeyboardChangeObserver {
    func keyboardChanging(endHeight: CGFloat, duration: TimeInterval) {
        self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: endHeight, right: 0)
    }
}
