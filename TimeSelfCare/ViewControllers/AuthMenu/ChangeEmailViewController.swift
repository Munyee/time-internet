//
//  ChangeEmailViewController.swift
//  TimeSelfCare
//
//  Created by Loka on 16/11/2017.
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import UIKit

internal class ChangeEmailViewController: BaseAuthViewController {
    override var allRequiredTextFields: [VDTTextField] {
        return [emailAddressTextField]
    }

    @IBOutlet private weak var emailAddressTextField: VDTTextField!
    @IBOutlet private weak var proceedButton: UIButton!

    override func updateUI() {
        self.proceedButton.isEnabled = allRequiredTextFields.reduce(true) { $0 && !$1.inputText.isEmpty }
        self.proceedButton.backgroundColor = self.proceedButton.isEnabled ? .primary : .grey2
    }

    @IBAction func changeEmailAddress(_ sender: Any) {
        let hud = LoadingView().addLoading(toView: self.view)
        hud.showLoading()
        APIClient.shared.changeEmailAddress(AccountController.shared.profile.username, email: self.emailAddressTextField.inputText) { _, error in
            hud.hideLoading()
            if let error = error {
                self.showAlertMessage(with: error)
                return
            }

            if let profile = AuthUser.current?.person as? Profile {
                profile.todo = nil
                AuthUser.current?.person = profile
            }

            let storyboard = UIStoryboard(name: "Common", bundle: nil)
            if let confirmationVC = storyboard.instantiateViewController(withIdentifier: "ConfirmationViewController") as? ConfirmationViewController {
                confirmationVC.mode = .emailUpdated
                confirmationVC.actionBlock = {
                    UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
                }
                confirmationVC.modalPresentationStyle = .fullScreen
                self.present(confirmationVC, animated: true, completion: nil)
            }
        }
    }
}
