//
//  UIStoryboard+.swift
//  TimeSelfCare
//
//  Created by Loka on 15/05/2018.
//  Copyright © 2018 Apptivity Lab. All rights reserved.
//

import Foundation

enum TimeSelfCareStoryboard: String, Storyboard {
    case activity
    case billingInfo
    case profile
    case common
    case payment
    case main
    case summary
    case walkthrough
    case authMenu
    case performance
    case diagnosis
    case support
    case reward

    var filename: String {
        return rawValue.capitalizedFirstLetter
    }

}
