//  PaymentType.swift
//  TimeSelfCareData/Model
//
//  Opera House | Data - Model Class
//  Updated 2017-11-28
//  Copyright © Invalid date Apptivity Lab. All rights reserved.
//

import Foundation

public class PaymentType: JsonRecord {
    public enum TypeId: String {
        case fpx = "fpx"
        case cc = "cc"
        case unknown = "unknown"
    }

    public let typeId: PaymentType.TypeId
    public var minAmount: Double?

    // Relationships
    public var accountNo: String?

    public required init?(with json: [String : Any]) {
        guard
            let typeIdRawValue: String = json["type_id"] as? String,
            let typeId = TypeId(rawValue: typeIdRawValue)
            else {
                debugPrint("ERROR: Failed to construct PaymentType from JSON\n\(json)")
                return nil
        }

        self.typeId = typeId
        self.minAmount = json["min_amount"] as? Double
        self.accountNo = json["account_no"] as? String
    }

}

public extension PaymentType {
    // account: PaymentType belongs-to Account
    var account: Account? {
        if let accountNo = self.accountNo {
            return AccountDataController.shared.getAccount(by: accountNo)
        }
        return nil
    }

}
