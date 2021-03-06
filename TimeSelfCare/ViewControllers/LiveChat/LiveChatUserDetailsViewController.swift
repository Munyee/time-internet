//
//  LiveChatUserDetailsViewController.swift
//  TimeSelfCare
//
//  Created by Adrian Kok Jee Wai on 24/11/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class LiveChatUserDetailsViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var startChatBackgroundView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameErrorView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailErrorView: UIView!
    @IBOutlet weak var handphoneNumberTextField: UITextField!
    @IBOutlet weak var handphoneNumberErrorView: UIView!
    @IBOutlet weak var soNumberTextField: UITextField!
    
    var previousViewController: UIViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if titleLabel != nil {
            if UIScreen.main.bounds.size.height <= 568 {
                titleLabel.font = UIFont.getCustomFont(family: "DIN", style: .headline)
            }
        }
        
        IQKeyboardManager.shared.enable = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        IQKeyboardManager.shared.enable = false
    }
    
    @IBAction func startChatButtonTapped(_ sender: UIButton) {
        var isNameError = false
        var isEmailError = false
        var isHandphoneNumberError = false
        
        if let name = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), name != "" {
            isNameError = false
            nameErrorView.isHidden = true
        } else {
            isNameError = true
            nameErrorView.isHidden = false
        }
        
        if let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), email != "" {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

            let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            if emailPred.evaluate(with: email) {
                isEmailError = false
                emailErrorView.isHidden = true
            } else {
                isEmailError = true
                emailErrorView.isHidden = false
            }
        } else {
            isEmailError = true
            emailErrorView.isHidden = false
        }
        
        if let handphoneNumber = handphoneNumberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), handphoneNumber != "" {
            isHandphoneNumberError = false
            handphoneNumberErrorView.isHidden = true
        } else {
            isHandphoneNumberError = true
            handphoneNumberErrorView.isHidden = false
        }
        
        if !isNameError && !isEmailError && !isHandphoneNumberError, let name = nameTextField.text, let email = emailTextField.text, let handphoneNumber = handphoneNumberTextField.text {
            
            DispatchQueue.main.async {
                if let restoreID = FreshChatManager.shared.restoreID {
                    Freshchat.sharedInstance().identifyUser(withExternalID: email, restoreID: restoreID)
                } else {
                    let user = FreshchatUser.sharedInstance()
                    user.firstName = name
                    user.email = email
                    user.phoneNumber = handphoneNumber
                    if let soNumber = self.soNumberTextField.text, soNumber != "" {
                        Freshchat.sharedInstance().setUserPropertyforKey("so_number", withValue: soNumber)
                    }
                    Freshchat.sharedInstance().setUser(user)
                    Freshchat.sharedInstance().identifyUser(withExternalID: email, restoreID: nil)
                }
                
                let alert = UIAlertController(title: "Choose Option", message: nil, preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "Conversations", style: .default, handler: { (UIAlertAction) in
                    self.dismiss(animated: true, completion: {
                        if self.previousViewController != nil {
                            Freshchat.sharedInstance().showConversations(self.previousViewController)
                        }
                    })
                }))
                
                alert.addAction(UIAlertAction(title: "FAQ", style: .default, handler: { (UIAlertAction) in
                    self.dismiss(animated: true, completion: {
                        if self.previousViewController != nil {
                            Freshchat.sharedInstance().showFAQs(self.previousViewController)
                        }
                    })
                }))

                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))

                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    @IBAction func xButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}
