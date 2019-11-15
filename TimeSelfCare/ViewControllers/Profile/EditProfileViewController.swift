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

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet weak var emailTextField: VDTTextField!
    @IBOutlet weak var contactTextField: VDTTextField!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var updateButton: UIButton!
    
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
    }
    
    override func updateUI() {
        self.updateButton.isEnabled = self.hasAllTextFieldFilled && self.emailErrorLabel.text == nil
        self.updateButton.backgroundColor = self.updateButton.isEnabled ? .primary : .grey2
    }
    
    @IBAction func updateProfile(_ sender: Any) {
        
        APIClient.shared.editProfile(self.emailTextField.text!, contact: self.contactTextField.text!) { error in
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
