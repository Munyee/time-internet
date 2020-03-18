//  CreditCard.swift
//  TimeSelfCareData/Model
//
//  Opera House | Data - Model Class
//  Updated 2017-11-13
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import Foundation

public let mastercardIdKey: String = "mastercard_id"
public let visaIdKey: String = "visa_id"

public class CreditCard: JsonRecord {
    public enum CcType: String {
        case mastercard = "MasterCard"
        case visa = "Visa"
        case amex = "Amex"
        case unknown = "unknown"
    }

    public var ccType: CreditCard.CcType?
    public var ccNo: String
    public var ccName: String?
    public var ccExpiry: String?
    public var ccCvv: String?

    // Relationships
    public var accountNo: String?
    public var bankBankId: String?

    public required init?(with json: [String : Any]) {
        guard
            let ccNo: String = json["cc_no"] as? String
            else {
                debugPrint("ERROR: Failed to construct Bill from JSON\n\(json)")
                return nil
        }
        if let ccTypeRawValue = json["cc_type"] as? String,
            let ccType = CcType(rawValue: ccTypeRawValue) {
            self.ccType = ccType
        } else {
            if let cc_list = json["list_cc_type_id"] as? [String : Any],
                let cc_type_id = json["cc_type_id"] as? String,
                let ccTypeRawValue = cc_list[cc_type_id] as? String,
                let ccType = CcType(rawValue: ccTypeRawValue) {
                self.ccType = ccType
            }
        }
        self.ccNo = ccNo
        self.ccName = json["cc_name"] as? String
        self.ccExpiry = json["cc_expiry"] as? String
        self.ccCvv = json["cc_cvv"] as? String
        self.accountNo = json["account_no"] as? String
        self.bankBankId = json["bank_bank_id"] as? String
    }

}

public extension CreditCard {
    // account: CreditCard belongs-to Account
    var account: Account? {
        if let accountNo = self.accountNo {
            return AccountDataController.shared.getAccount(by: accountNo)
        }
        return nil
    }

    // bank: CreditCard belongs-to Bank
    var bank: Bank? {
        if let bankBankId = self.bankBankId {
            return BankDataController.shared.getBank(by: bankBankId)
        }
        return nil
    }
}

public extension String {
    func inferredCreditCardType() -> CreditCard.CcType {
        let mastercardRegex: NSRegularExpression?
        let visaRegex: NSRegularExpression?
        let amexRegex: NSRegularExpression?

        do {
            mastercardRegex = try NSRegularExpression(pattern: "^5[0-5]\\d{3,14}", options: [])
            visaRegex = try NSRegularExpression(pattern: "^4\\d{3,15}", options: [])
            amexRegex = try NSRegularExpression(pattern: "^3[47]\\d{3,13}", options: [])
        } catch {
            return CreditCard.CcType.unknown
        }

        let inputRange = NSRange(location: 0, length: self.count)
        if (mastercardRegex?.firstMatch(in: self, options: [], range: inputRange) != nil) {
            return CreditCard.CcType.mastercard
        } else if (visaRegex?.firstMatch(in: self, options: [], range: inputRange) != nil) {
            return CreditCard.CcType.visa
        } else if (amexRegex?.firstMatch(in: self, options: [], range: inputRange) != nil) {
            return CreditCard.CcType.amex
        }

        return CreditCard.CcType.unknown
    }

    func exactCreditCardType() -> CreditCard.CcType {
        let mastercardRegex: NSRegularExpression?
        let visaRegex: NSRegularExpression?
        let amexRegex: NSRegularExpression?

        do {
            mastercardRegex = try NSRegularExpression(pattern: "^5[0-5]\\d{14}", options: [])
            visaRegex = try NSRegularExpression(pattern: "^4\\d{15}", options: [])
            amexRegex = try NSRegularExpression(pattern: "^3[47]\\d{13}", options: [])
        } catch {
            return CreditCard.CcType.unknown
        }

        let inputRange = NSRange(location: 0, length: self.count)
        if (mastercardRegex?.firstMatch(in: self, options: [], range: inputRange) != nil) {
            return CreditCard.CcType.mastercard
        } else if (visaRegex?.firstMatch(in: self, options: [], range: inputRange) != nil) {
            return CreditCard.CcType.visa
        } else if (amexRegex?.firstMatch(in: self, options: [], range: inputRange) != nil) {
            return CreditCard.CcType.amex
        }

        return CreditCard.CcType.unknown
    }
}
