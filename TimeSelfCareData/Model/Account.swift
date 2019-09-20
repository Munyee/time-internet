//  Account.swift
//  TimeSelfCareData/Model
//
//  Opera House | Data - Model Class
//  Updated 2017-11-13
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import Foundation

public class Account: JsonRecord {
    public enum CustSegment: String {
        case residential = "residential"
        case business = "business"
        case astro = "astro"
        case unknown = "unknown"
    }

    public enum AccountStatus: String {
        case active = "active"
        case inactive = "inactive"
        case suspend = "suspended"
        case restrict = "restricted"
        case unknown = "unknown"

        public var displayText: String {
            switch self {
            case .active:
                return NSLocalizedString("ACTIVE", comment: "")
            case .inactive:
                return NSLocalizedString("INACTIVE", comment: "")
            case .suspend:
                return NSLocalizedString("SUSPENDED", comment: "")
            case .restrict:
                return NSLocalizedString("RESTRICTED", comment: "")
            case .unknown:
                return NSLocalizedString("UNKNOWN", comment: "")
            }
        }
    }

    public let accountNo: String
    public var displayAccountNo: String?
    public var custSegment: Account.CustSegment?
    public var accountStatus: Account.AccountStatus?
    public var showBill: Bool?
    public var title: String?
    public var showAutoDebit: Bool?

    // Relationships
    public var profileUsername: String?

    public init(accountNo: String) {
        self.accountNo = String()
    }

    public required init?(with json: [String : Any]) {
        guard
            let accountNo: String = json["account_no"] as? String
        else {
            debugPrint("ERROR: Failed to construct Account from JSON\n\(json)")
            return nil
        }

        self.accountNo = accountNo
        self.displayAccountNo = json["display_account_no"] as? String
        if let custSegmentRawValue = json["cust_segment"] as? String,
            let custSegment = CustSegment(rawValue: custSegmentRawValue) {
            self.custSegment = custSegment
        }
        if let accountStatusRawValue = json["account_status"] as? String,
            let accountStatus = AccountStatus(rawValue: accountStatusRawValue) {
            self.accountStatus = accountStatus
        }
        self.showBill = json["show_bill"] as? Bool
        self.profileUsername = json["profile_username"] as? String
        self.title = json["title"] as? String
        self.showAutoDebit = {
            return json["show_autodebit"] as? Bool
        } ()
    }

}

public extension Account {
    // profile: Account belongs-to Profile
    var profile: Profile? {
        if let profileUsername = self.profileUsername {
            return ProfileDataController.shared.getProfile(by: profileUsername)
        }
        return nil
    }

    // autodebitCard: Account has-one CreditCard
    var autodebitCard: CreditCard? {
        return CreditCardDataController.shared.getCreditCards(account: self).first
    }

    // services: Account has-many Service
    var services: [Service] {
        return ServiceDataController.shared.getServices(account: self)
    }

    // addons: Account has-many AddOn
    var addons: [AddOn] {
        return AddOnDataController.shared.getAddOns(account: self)
    }
}
