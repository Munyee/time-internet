//
//  FloatingMenuItem.swift
//  TimeSelfCareData
//
//  Created by Loka on 30/04/2018.
//  Copyright © 2018 Apptivity Lab. All rights reserved.
//

import Foundation

public enum FloatingMenuItem {
    case invoices
    case autoDebit
    case billingInfo
    case activateHomeForward
    case changeSsid
    case runDiagnostics
    case all
    case inprogress
    case activated
    case unsuccessful

    public var title: String {
        switch self {
        case .invoices:
            return NSLocalizedString("Bills", comment: "")
        case .autoDebit:
            return NSLocalizedString("Auto Debit", comment: "")
        case .billingInfo:
            return NSLocalizedString("Billing Info", comment: "")
        case .activateHomeForward:
            return NSLocalizedString("Activate Home Forward", comment: "")
        case .changeSsid:
            return NSLocalizedString("Change SSID", comment: "")
        case .runDiagnostics:
            return NSLocalizedString("Run Diagnostics", comment: "")
        case .all:
            return NSLocalizedString("All", comment: "")
        case .activated:
            return NSLocalizedString("Activated", comment: "")
        case .inprogress:
            return NSLocalizedString("In Progress", comment: "")
        case .unsuccessful:
            return NSLocalizedString("Unsuccessful", comment: "")

        }
    }
}
