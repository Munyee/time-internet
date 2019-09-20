//  Bank.swift
//  TimeSelfCareData/Model
//
//  Opera House | Data - Model Class
//  Updated 2017-11-13
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import Foundation

public class Bank: JsonRecord {
    public let bankId: String
    public var name: String?

    // Relationships
    public var paymentTypeTypeId: String?

    public init() {
        self.bankId = String()
    }

    public required init?(with json: [String : Any]) {
        guard
            let bankId: String = json["bank_id"] as? String
        else {
            debugPrint("ERROR: Failed to construct Bank from JSON\n\(json)")
            return nil
        }

        self.bankId = bankId
        self.name = json["name"] as? String
        self.paymentTypeTypeId = json["payment_type_type_id"] as? String
    }

}

public extension Bank {
    // paymentType: Bank belongs-to PaymentType
    var paymentType: PaymentType? {
        if let paymentTypeTypeId = self.paymentTypeTypeId {
            return PaymentTypeDataController.shared.getPaymentType(by: paymentTypeTypeId)
        }
        return nil
    }

}
