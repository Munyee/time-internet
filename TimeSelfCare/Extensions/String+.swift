//
//  String+.swift
//  TimeSelfCare
//
//  Created by Loka on 13/12/2017.
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import Foundation

public extension String {
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }

    func toIntegerOnly() -> String {
        let allowedChars : Set<Character> =
            Set("1234567890".characters)
        return String(self.characters.filter { allowedChars.contains($0) })
    }

    var capitalizedFirstLetter: String {
        return prefix(1).uppercased() + dropFirst()
    }
}

public extension NSMutableAttributedString {

    public func setAsLink(textToFind:String, linkURL:String) -> Bool {

        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(.link, value: linkURL, range: foundRange)
            return true
        }
        return false
    }
}

extension NSAttributedString {
    internal convenience init?(html: String) {
        guard let data = html.data(using: String.Encoding.utf16, allowLossyConversion: false) else {
            // not sure which is more reliable: String.Encoding.utf16 or String.Encoding.unicode
            return nil
        }
        guard let attributedString = try? NSMutableAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) else {
            return nil
        }
        self.init(attributedString: attributedString)
    }
}
