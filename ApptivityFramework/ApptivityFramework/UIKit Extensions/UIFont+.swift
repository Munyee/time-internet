//
//  UILabel+.swift
//  ApptivityFramework
//
//  Created by Loka on 25/09/2017.
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import UIKit

// To use custom font with dynamic text functionality
// Without setting text style, the default UIFontTextStyle is CTFontRegularUsage
// The size CTFontRegularUsage is 13point

public extension UIFont {
    class func customFont(forFamily family: String, style: UIFontTextStyle) -> UIFont? {
        if let url = Bundle.main.url(forResource: family, withExtension: "plist"),
            let dict = NSDictionary(contentsOf: url) as? [String: Any],
            let fontDict = dict[style.rawValue] as? [String: Any],
            let fontSize = fontDict["fontSize"] as? CGFloat,
            let fontName = fontDict["fontName"] as? String {
            let font: UIFont

            if fontName == "System" {
                font = UIFont.systemFont(ofSize: fontSize)
            } else if fontName == "boldSystem" {
                font = UIFont.boldSystemFont(ofSize: fontSize)
            } else if let newFont = UIFont(name: fontName, size: fontSize){
                font = newFont
            } else {
                return nil
            }

            if #available(iOS 11.0, *) {
                return UIFontMetrics(forTextStyle: style).scaledFont(for: font)
            } else {
                // Fallback on earlier versions
                return font
            }
        }
        return nil
    }

    class func setCustomFont(with name: String) {
        UILabel.appearance().customFont = name
        UITextView.appearance().customFont = name
        UITextField.appearance().customFont = name
    }
}

public extension UILabel {
    @objc var customFont: String {
        get {
            return self.font?.familyName ?? String()
        }
        set {
            if let style: UIFontTextStyle = self.font?.fontDescriptor.object(forKey: .textStyle) as? UIFontTextStyle, let font: UIFont = UIFont.customFont(forFamily: newValue, style: style) {
                if #available(iOS 10.0, *) {
                    self.adjustsFontForContentSizeCategory = true
                }
                self.font = font
            }
        }
    }
}

public extension UITextView {
    @objc var customFont: String {
        get {
            return self.font?.familyName ?? String()
        }
        set {
            if let style: UIFontTextStyle = self.font?.fontDescriptor.object(forKey: .textStyle) as? UIFontTextStyle, let font: UIFont = UIFont.customFont(forFamily: newValue, style: style) {
                if #available(iOS 10.0, *) {
                    self.adjustsFontForContentSizeCategory = true
                }
                self.font = font
            }
        }
    }
}

public extension UITextField {
    @objc var customFont: String {
        get {
            return self.font?.familyName ?? String()
        }
        set {
            if let style: UIFontTextStyle = self.font?.fontDescriptor.object(forKey: .textStyle) as? UIFontTextStyle, let font: UIFont = UIFont.customFont(forFamily: newValue, style: style) {
                if #available(iOS 10.0, *) {
                    self.adjustsFontForContentSizeCategory = true
                }
                self.font = font
            }
        }
    }
}
