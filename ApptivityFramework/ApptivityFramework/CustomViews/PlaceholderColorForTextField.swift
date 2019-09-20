//
//  PlaceholderColorForTextField.swift
//  ApptivityFramework
//
//  Created by Loka on 28/10/2016.
//  Copyright © 2016 Apptivity Lab. All rights reserved.
//

import UIKit

extension UIColor {
    var coreImageColor: CIColor {
        return CIColor(color: self)
    }
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let color = coreImageColor
        return (color.red, color.green, color.blue, color.alpha)
    }
}

@IBDesignable
class PlaceholderColorForTextfield: UITextField {

    @IBInspectable var placeholderTextColor: UIColor? {
        set {
            if var newValue = newValue {
                let maxAlphaValue: CGFloat = 0.6
                if newValue.components.alpha > maxAlphaValue {
                    newValue = UIColor(red: newValue.components.red
                        , green: newValue.components.green, blue: newValue.components.blue, alpha: maxAlphaValue)
                }
                self.attributedPlaceholder = NSAttributedString(string: placeholder ?? String(), attributes: [NSAttributedStringKey.foregroundColor: newValue])
            }
        }
        get {
            if let color = self.attributedPlaceholder?.attributes(at: 0, effectiveRange: nil)[NSAttributedStringKey.foregroundColor] as? UIColor {
                return color
            }
            return UIColor.lightGray
        }
    }
}

