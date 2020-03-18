//
//  CustomKeyboard+TextField.swift
//  ApptivityFramework
//
//  Created by LiSim on 28/10/2016.
//  Copyright © 2016 Apptivity Lab. All rights reserved.
//

import Foundation

public extension UITextField {

    func setupToolBar(title: String? = nil, titleColor: UIColor? = nil, cancelButtonText: String? = nil, doneButtonText: String? = nil, tintColor: UIColor? = nil, doneButtonAction: Selector? = nil, doneButtonTarget: Any? = nil) {
        let toolBar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        toolBar.backgroundColor = .white

        let doneButton: UIBarButtonItem = UIBarButtonItem(title: doneButtonText ?? NSLocalizedString("Done", comment: ""), style: .done, target: doneButtonTarget ?? self, action: doneButtonAction ?? #selector(self.doneButtonSelected))
        doneButton.tintColor = tintColor

        let cancelButton: UIBarButtonItem = UIBarButtonItem(title: cancelButtonText ?? NSLocalizedString("Cancel", comment: ""), style: .plain, target: self, action: #selector(self.cancelButtonSelected))
        cancelButton.tintColor = tintColor

        let flexibleSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        if let title: String = title {
            let titleItem: UIBarButtonItem = UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
            titleItem.tintColor = titleColor
            toolBar.items = [cancelButton, flexibleSpace, titleItem, flexibleSpace, doneButton]
        } else {
            toolBar.items = [cancelButton, flexibleSpace, doneButton]
        }

        toolBar.sizeToFit()
        self.inputAccessoryView = toolBar
    }

    public func setupPhoneKeyboard(title: String? = nil, titleColor: UIColor? = nil, cancelButtonText: String? = nil, doneButtonText: String? = nil, tintColor: UIColor? = nil, doneButtonAction: Selector? = nil, doneButtonTarget: Any? = nil) {
        self.setupToolBar(title:title, titleColor: titleColor, cancelButtonText: cancelButtonText, doneButtonText: doneButtonText, tintColor: tintColor, doneButtonAction: doneButtonAction, doneButtonTarget: doneButtonTarget)
        self.keyboardType = UIKeyboardType.numberPad
    }

    @objc func doneButtonSelected() {
        if self.delegate?.textFieldShouldReturn?(self) == nil {
            self.resignFirstResponder()
        }
    }

    @objc func cancelButtonSelected() {
        self.resignFirstResponder()
    }

    func hasValidInput(`where`: (String) -> Bool) -> Bool {
        return `where`(self.text ?? "")
    }
}
