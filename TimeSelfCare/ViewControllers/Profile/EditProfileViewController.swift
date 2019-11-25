//
//  EditProfileViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 14/11/2019.
//  Copyright © 2019 Apptivity Lab. All rights reserved.
//

import UIKit

class EditProfileViewController: BaseAuthViewController {

    private var job: DispatchWorkItem?

    @IBOutlet private weak var accountNumberLabel: UILabel!
    @IBOutlet private weak var fullnameLabel: UILabel!
    @IBOutlet private weak var businessRegistrationNumberLabel: UILabel!
    @IBOutlet private weak var fullNameKeyLabel: UILabel!
    @IBOutlet private weak var businessRegistrationNumberKeyLabel: UILabel!

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var emailTextField: VDTTextField!
    @IBOutlet private weak var contactPersonTextField: VDTTextField!
    @IBOutlet private weak var contactTextField: VDTTextField!
    @IBOutlet private weak var contactOfficeTextField: VDTTextField!
    @IBOutlet private weak var emailErrorLabel: UILabel!
    @IBOutlet private weak var updateButton: UIButton!

    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var contactPersonStackView: UIStackView!
    @IBOutlet private weak var contactOfficeStackView: UIStackView!
    @IBOutlet weak var emailStackView: UIStackView!

    override var allRequiredTextFields: [VDTTextField] {
        return [self.emailTextField,
                self.contactTextField]
    }
    
    private var emailValidation: String? {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self.emailTextField.text) ? nil : "Please enter valid email address"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Edit Profile", comment: "")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back_arrow"), style: .plain, target: self, action: #selector(self.cancelEditProfile))
        
        Keyboard.addKeyboardChangeObserver(self)

        let selectedAccount = AccountController.shared.selectedAccount
        let profile = selectedAccount?.profile

        if selectedAccount?.custSegment == .residential {
            stackView.removeArrangedSubview(contactPersonStackView)
            contactPersonStackView.removeFromSuperview()
            stackView.removeArrangedSubview(contactOfficeStackView)
            contactOfficeStackView.removeFromSuperview()
            stackView.removeArrangedSubview(emailStackView)
            stackView.insertArrangedSubview(emailStackView, at: 3)
        }

        self.fullNameKeyLabel.text = selectedAccount?.custSegment == .residential ? NSLocalizedString("Name", comment: "") : NSLocalizedString("Company Name", comment: "")
        self.businessRegistrationNumberKeyLabel.text = selectedAccount?.custSegment == .residential ? NSLocalizedString("MyKad No./ Passport No.", comment: "") : NSLocalizedString("Business Registration Number", comment: "")
        self.businessRegistrationNumberLabel.text = selectedAccount?.profileUsername ?? "-"
        self.accountNumberLabel.text = selectedAccount?.accountNo ?? "-"
        self.fullnameLabel.text = profile?.fullname ?? "-"
        self.contactPersonTextField.text = profile?.contactPerson ?? ""
        self.contactTextField.text = profile?.mobileNo ?? ""
        self.contactOfficeTextField.text = profile?.officeNo ?? ""
        self.emailTextField.text = profile?.email ?? ""
    }
    
    override func updateUI() {
        self.updateButton.isEnabled = self.hasAllTextFieldFilled && self.emailErrorLabel.text == nil
        self.updateButton.backgroundColor = self.updateButton.isEnabled ? .primary : .grey2
    }
    
    @IBAction func updateProfile(_ sender: Any) {

        guard let username = AccountController.shared.selectedAccount?.profile?.username else {
            let error = NSError(domain: "TimeSelfCare", code: 500, userInfo: [NSLocalizedDescriptionKey: "Unexpected error has occured. Please try again later."])
            self.showAlertMessage(with: error)
            return
        }

        APIClient.shared.editProfile(username, email: self.emailTextField.text ?? "", contact: self.contactTextField.text ?? "") { error in
//            hud.hide(animated: true)
            if let error = error {
                self.showAlertMessage(with: error)
                return
            }
        }
    }

    @objc func cancelEditProfile() {
        self.navigationController?.popViewController(animated: true)
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
