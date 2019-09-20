//
//  UIFont+.swift
//  TimeSelfCare
//
//  Created by Loka on 28/11/2017.
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import UIKit

public extension UIFont {
    class func setCustomFont() {
        let fontName = "DIN"
        UILabel.appearance().customFont = fontName
        UITextView.appearance().customFont = fontName
        UITextField.appearance().customFont = fontName
    }

    class func getCustomFont(family: String, style: UIFont.TextStyle) -> UIFont? {
        if let url = Bundle.main.url(forResource: family, withExtension: "plist"),
            let dict = NSDictionary(contentsOf: url) as? [String: Any],
            let fontDict = dict[style.rawValue] as? [String: Any],
            let fontSize = fontDict["fontSize"] as? CGFloat,
            let fontName = fontDict["fontName"] as? String,
            let font = UIFont(name: fontName, size: fontSize) {
            return font
        }
        return nil
    }
}

public extension UILabel {
    @objc var customFont: String {
        set {
            if let style: UIFont.TextStyle = self.font?.fontDescriptor.object(forKey: .textStyle) as? UIFont.TextStyle,
                let font = UIFont.getCustomFont(family: newValue, style: style) {
                self.adjustsFontForContentSizeCategory = true
                self.font = font
            }
        }
        get {
            return self.font.familyName
        }
    }
}

public extension UITextField {
    @objc var customFont: String {
        set {
            if let style: UIFont.TextStyle = self.font?.fontDescriptor.object(forKey: .textStyle) as? UIFont.TextStyle,
                let font = UIFont.getCustomFont(family: newValue, style: style) {
                self.adjustsFontForContentSizeCategory = true
                self.font = font
            }
        }
        get {
            return self.font?.familyName ?? String()
        }
    }
}

public extension UITextView {
    @objc var customFont: String {
        set {
            if let style: UIFont.TextStyle = self.font?.fontDescriptor.object(forKey: .textStyle) as? UIFont.TextStyle,
                let font = UIFont.getCustomFont(family: newValue, style: style) {
                self.adjustsFontForContentSizeCategory = true
                self.font = font
            }
        }
        get {
            return self.font?.familyName ?? String()
        }
    }
}
