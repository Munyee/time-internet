//  BillingInfo.swift
//  TimeSelfCareData/Model
//
//  Opera House | Data - Model Class
//  Updated 2018-03-05
//  Copyright © 2018 Apptivity Lab. All rights reserved.
//

import Foundation

public class BillingInfo: JsonRecord {
    public var deposit: String?
    public var billingCycle: String?
    public var billingEmailAddress: String?
    public var block: String?
    public var level: String?
    public var unit: String?
    public var building: String?
    public var billAddress2: String?
    public var billAddress3: String?
    public var billZip: String?
    public var billCity: String?
    public var billState: String?
    public var billCountry: String = NSLocalizedString("MALAYSIA", comment: "") // Hardcoded to Malaysia
    public var displayBillingAddress: String?
    public var billingMethod: Int?
    public var canUpdateBillingMethod: Bool?
    public var canUpdateBillingAddress: Bool?
    public var billingMethodOptions: [Int: String] = [:]
    public var accountNo: String?

    public var billingMethodString: String? {
        get {
            if let billingMethod = billingMethod {
                return billingMethodOptions[billingMethod]
            }
            return nil
        }
        set {
            self.billingMethod = billingMethodOptions.keys.first { billingMethodOptions[$0] == newValue }
        }
    }

    public required init?(with json: [String : Any]) {
        ((json["list_billing_method"] as? [String: String]) ?? [:]).forEach {
            if let key = Int($0.key) {
                self.billingMethodOptions[key] = $0.value
            }
        }

        self.deposit = json["deposit"] as? String
        self.billingCycle = json["billing_cycle"] as? String
        self.billingEmailAddress = json["billing_email_address"] as? String
        self.block = json["block"] as? String
        self.level = json["level"] as? String
        self.unit = json["unit"] as? String
        self.building = json["building_name"] as? String
        self.billAddress2 = json["bill_address2"] as? String
        self.billAddress3 = json["bill_address3"] as? String
        self.billZip = json["bill_zip"] as? String
        self.billCity = json["bill_city"] as? String
        self.billState = json["bill_state"] as? String
        self.displayBillingAddress = json["billing_address_string"] as? String
        self.billingMethod = json["billing_method"] as? Int
        self.canUpdateBillingMethod = json["can_update_billing_method"] as? Bool
        self.canUpdateBillingAddress = json["can_update_billing_address"] as? Bool
        self.accountNo = json["account_no"] as? String
    }

    public func toJson() -> [String : Any] {
        var json: [String : Any] = [:]

        // Attributes
        json["billing_email_address"] = self.billingEmailAddress
        json["block"] = self.block
        json["level"] = self.level
        json["unit"] = self.unit
        json["building_name"] = self.building
        json["bill_address2"] = self.billAddress2
        json["bill_address3"] = self.billAddress3
        json["bill_zip"] = self.billZip
        json["bill_city"] = self.billCity
        json["bill_state"] = self.billState
        json["billing_method"] = self.billingMethod
        json["account_no"] = self.accountNo
        return json
    }
}

public extension BillingInfo {
    // account: BillingInfo belongs-to Account
    var account: Account? {
        if let accountNo = self.accountNo {
            return AccountDataController.shared.getAccount(by: accountNo)
        }
        return nil
    }

}
