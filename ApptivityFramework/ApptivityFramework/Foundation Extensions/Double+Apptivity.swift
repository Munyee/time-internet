//
//  Double+Apptivity.swift
//  ApptivityFramework
//
//  Created by AppLab on 16/11/2016.
//  Copyright © 2016 Apptivity Lab. All rights reserved.
//

import Foundation

public extension Double {

    public func currencyString(withSymbol currencySymbol: String, minimumFractionDigits: Int = 0, maximumFractionDigits: Int = 2) -> String {
        let currencyFormatter: NumberFormatter = NumberFormatter()
        currencyFormatter.currencySymbol = currencySymbol
        currencyFormatter.minimumFractionDigits = minimumFractionDigits
        currencyFormatter.maximumFractionDigits = maximumFractionDigits
        currencyFormatter.numberStyle = NumberFormatter.Style.currency
        currencyFormatter.groupingSeparator = ","

        return currencyFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}
