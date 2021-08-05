//
//  RoundedDesignables.swift
//  ApptivityFramework
//
//  Created by AppLab on 24/10/2016.
//  Copyright © 2016 Apptivity Lab. All rights reserved.
//

import UIKit

public extension UIView  {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = (newValue > 0)
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable public var borderColor: UIColor? {
        get {
            if let borderColor = layer.borderColor {
                return UIColor(cgColor: borderColor)
            } else {
                return nil
            }
        }
        set {
            if let newValue = newValue {
                layer.borderColor = newValue.cgColor
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.masksToBounds = false
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 0)
            layer.shadowOpacity = 0.3
            layer.cornerRadius = 14
            layer.shadowRadius = newValue
        }
    }
}


@IBDesignable
public class RoundedButton: UIButton {}

@IBDesignable
public class RoundedTextField: UITextField {}

@IBDesignable
public class RoundedImageView: UIImageView {}

@IBDesignable
public class RoundedTextView: UITextView {}

@IBDesignable
public class RoundedLabel: UILabel {}

@IBDesignable
public class RoundedView: UIView {}
