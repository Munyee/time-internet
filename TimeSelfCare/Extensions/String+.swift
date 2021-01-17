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
    
   init(htmlEncodedString: String) {
        self.init()
    
        guard let encodedData = htmlEncodedString.data(using: .utf8) else {
            self = htmlEncodedString
            return
        }

        let attributedOptions: [NSAttributedString.DocumentReadingOptionKey : Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]

        do {
            let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
            self = attributedString.string
        }
        catch {
            print("Error: \(error)")
            self = htmlEncodedString
        }
    }
    
    func htmlAttributdString() -> NSAttributedString? {
        
        let style = "<style> body { font-family: 'DIN-Light'; font-size: 16px; } b {font-family: 'DIN-Bold'; font-size: 16px;} i {font-family: 'D-DIN-Italic'; font-size: 16px;} </style>"
        let styledHtml = style + self
        
        guard let data = styledHtml.data(using: .utf8) else {
            return nil
        }
        
        return try? NSAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil
        )
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
