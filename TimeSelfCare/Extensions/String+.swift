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
