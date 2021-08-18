//
//  BaseAuthViewController.swift
//  TimeSelfCare
//
//  Created by Loka on 17/11/2017.
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import UIKit

internal class BaseAuthViewController: TimeBaseViewController, UITextFieldDelegate {
    var allRequiredTextFields: [VDTTextField] { return [] }
    var hasAllTextFieldFilled: Bool {
        return self.allRequiredTextFields.reduce(true) { $0 && !$1.inputText.isEmpty }
    }

    @IBOutlet weak private var customNavigationBar: UINavigationBar?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.customNavigationBar?.shadowImage = UIImage()

        self.allRequiredTextFields.forEach { $0.delegate = self }
    }

    func updateUI() {}

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let textFields: [VDTTextField] = self.allRequiredTextFields
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
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {
            textField.deleteBackward()
        } else {
            textField.insertText(string)
        }
        self.updateUI()
        return false
    }

    @IBAction func dismiss() {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.navigationController?.popViewController(animated: true)
        }
    }
}
