//
//  EditProfileViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 14/11/2019.
//  Copyright © 2019 Apptivity Lab. All rights reserved.
//

import UIKit
import MBProgressHUD

class EditProfileViewController: BaseAuthViewController {

    private var job: DispatchWorkItem?

    @IBOutlet private weak var accountNumberLabel: UILabel!
    @IBOutlet private weak var fullnameLabel: UILabel!
    @IBOutlet private weak var businessRegistrationNumberLabel: UILabel!
    @IBOutlet private weak var fullNameKeyLabel: UILabel!
    @IBOutlet private weak var businessRegistrationNumberKeyLabel: UILabel!

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var contactPersonTextField: UITextField!
    @IBOutlet private weak var contactTextField: UITextField!
    @IBOutlet private weak var contactOfficeTextField: UITextField!
    @IBOutlet private weak var emailErrorLabel: UILabel!
    @IBOutlet private weak var updateButton: UIButton!

    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var contactPersonStackView: UIStackView!
    @IBOutlet private weak var contactOfficeStackView: UIStackView!
    @IBOutlet private weak var emailStackView: UIStackView!
    
    private var emailValidation: String? {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self.emailTextField.text) ? nil : "Please enter valid email address"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("EDIT PROFILE", comment: "")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back_arrow"), style: .plain, target: self, action: #selector(self.cancelEditProfile))
        
        Keyboard.addKeyboardChangeObserver(self)

        let selectedAccount = AccountController.shared.selectedAccount
        let profile = selectedAccount?.profile

        if selectedAccount?.custSegment == .residential {
            stackView.removeArrangedSubview(contactPersonStackView)
            contactPersonStackView.removeFromSuperview()
            stackView.removeArrangedSubview(contactOfficeStackView)
            contactOfficeStackView.removeFromSuperview()
        }

        self.fullNameKeyLabel.text = selectedAccount?.custSegment == .residential ? NSLocalizedString("Name", comment: "") : NSLocalizedString("Company Name", comment: "")
        self.businessRegistrationNumberKeyLabel.text = selectedAccount?.custSegment == .residential ? NSLocalizedString("MyKad No./ Passport No.", comment: "") : NSLocalizedString("Business Registration Number", comment: "")
        self.businessRegistrationNumberLabel.text = selectedAccount?.profileUsername ?? "-"
        self.accountNumberLabel.text = selectedAccount?.accountNo ?? "-"
        self.fullnameLabel.text = profile?.fullname ?? "-"
        self.contactPersonTextField.text = profile?.contactPerson ?? ""
        self.contactTextField.text = profile?.mobileNo ?? ""
        self.contactOfficeTextField.text = profile?.officeNo
        self.emailTextField.text = profile?.email ?? ""
        self.emailErrorLabel.text = nil
        updateUI()
    }
    
    override func updateUI() {
        self.updateButton.isEnabled = self.hasAllTextFieldFilled && self.emailErrorLabel.text == nil
        self.updateButton.backgroundColor = self.updateButton.isEnabled ? .primary : .grey2
    }
    
    @IBAction func updateProfile(_ sender: Any) {

        let alert = UIAlertController(title: "Change Confirmation", message: "Area you sure you want to proceed", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in

        }))

        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            guard let username = AccountController.shared.selectedAccount?.profile?.username else {
                    let error = NSError(domain: "TimeSelfCare", code: 500, userInfo: [NSLocalizedDescriptionKey: "Unexpected error has occured. Please try again later."])
                    self.showAlertMessage(with: error)
                    return
                }
            
            var body = [
                "email": self.emailTextField.text ?? "",
                "mobile_no": self.contactTextField.text ?? "",
                "username" : username,
                "account_no": self.accountNumberLabel.text ?? ""
            ]
            
            let selectedAccount = AccountController.shared.selectedAccount

            if selectedAccount?.custSegment == .business {
                body["contact_person"] = self.contactPersonTextField.text ?? ""
                body["office_no"] = self.contactOfficeTextField.text ?? ""
            }
            
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)

            APIClient.shared.editProfile(body) { _, error in
                hud.hide(animated: true)
                if let error = error {
                    let confirmationVC: ConfirmationViewController = UIStoryboard(name: TimeSelfCareStoryboard.common.filename, bundle: nil).instantiateViewController()
                    confirmationVC.mode = .profileFailed
                    confirmationVC.descriptionText = error.localizedDescription
                    confirmationVC.actionBlock = {
                        confirmationVC.dismissVC()
                    }
                    confirmationVC.modalPresentationStyle = .fullScreen
                    self.present(confirmationVC, animated: true, completion: nil)
                    return
                }
                
                let confirmationVC: ConfirmationViewController = UIStoryboard(name: TimeSelfCareStoryboard.common.filename, bundle: nil).instantiateViewController()
                confirmationVC.mode = .profileUpdated
                confirmationVC.actionBlock = {
                    confirmationVC.dismissVC()
                    self.navigationController?.popViewController(animated: true)
                }
                confirmationVC.modalPresentationStyle = .fullScreen
                self.present(confirmationVC, animated: true, completion: nil)
            }
        }))

        self.present(alert, animated: true, completion: nil)
    }

    @objc func cancelEditProfile() {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func textFieldChange(_ sender: Any) {
        self.emailErrorLabel.text = self.emailValidation
        self.emailErrorLabel.isHidden = self.emailValidation == nil
        self.updateUI()
    }
    
}

extension EditProfileViewController: KeyboardChangeObserver {
    func keyboardChanging(endHeight: CGFloat, duration: TimeInterval) {
        self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: endHeight, right: 0)
    }
}
