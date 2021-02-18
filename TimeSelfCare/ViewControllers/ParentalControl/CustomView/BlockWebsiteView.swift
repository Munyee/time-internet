//
//  BlockWebsiteView.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 18/02/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import UIKit

protocol BlockWebsiteViewDelegate {
    func didBeginEdit(separator: UIView)
    func didEndEdit(separator: UIView)
    func didEditChange(textField: UITextField)
}

class BlockWebsiteView: UIView {
    
    var delegate: BlockWebsiteViewDelegate?
    var primary = false
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var closeView: UIControl!
    @IBOutlet weak var closeImg: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var separator: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required init(allowRemove: Bool, isPrimary: Bool) {
        super.init(frame: .zero)
        commonInit()
        addDoneKeyboard()
        textField.delegate = self
        primary = isPrimary
        closeView.isHidden = !allowRemove
    }
    
    func addDoneKeyboard() {
        let toolBar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        toolBar.backgroundColor = UIColor.white
        let flexibleSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton: UIBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: .done, target: textField, action: #selector(textField.resignFirstResponder))
        doneButton.tintColor = textField.tintColor
        
        toolBar.items = [flexibleSpace, doneButton]
        toolBar.sizeToFit()
        textField.inputAccessoryView = toolBar
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("BlockWebsiteView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    @IBAction func editChange(_ textField: UITextField) {
        if primary {
            delegate?.didEditChange(textField: textField)
        }
    }
}

extension BlockWebsiteView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.didBeginEdit(separator: separator)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.didEndEdit(separator: separator)
    }
}
