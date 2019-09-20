//  AddOn.swift
//  TimeSelfCareData/Model
//
//  Opera House | Data - Model Class
//  Updated 2017-11-13
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import Foundation

public class AddOn: JsonRecord {
    static private let dateFormatter: DateFormatter = {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mma"
        return dateFormatter
    }()

    public let timestamp: Int
    public var datetime: Date?
    public var orderId: String?
    public var item: String?
    public var model: String?
    public var image: String?
    public var features: String?
    public var currency: String?
    public var price: Double?
    public var isUnderWarranty: Bool?
    public var warrantyStartDate: Date?
    public var warrantyEndDate: Date?

    // Relationships
    public var accountNo: String?

    public init() {
        self.timestamp = Int()
    }

    public required init?(with json: [String : Any]) {
        guard
            let timestamp: Int = json["timestamp"] as? Int
            else {
                debugPrint("ERROR: Failed to construct AddOn from JSON\n\(json)")
                return nil
        }

        self.timestamp = timestamp
        if let datetimeString: String = json["datetime"] as? String,
            let datetime: Date = AddOn.dateFormatter.date(from: datetimeString) {
            self.datetime = datetime
        }
        self.orderId = json["order_id"] as? String
        self.item = json["item"] as? String
        self.model = json["item_name"] as? String
        self.image = json["image"] as? String
        self.features = json["features"] as? String
        self.currency = json["currency"] as? String
        self.price = json["price"] as? Double
        self.isUnderWarranty = json["is_under_warranty"] as? Bool
        if let warrantyStartDateString: String = json["warranty_start_date"] as? String,
            let warrantyStartDate: Date = AddOn.dateFormatter.date(from: warrantyStartDateString) {
            self.warrantyStartDate = warrantyStartDate
        }
        if let warrantyEndDateString: String = json["warranty_end_date"] as? String,
            let warrantyEndDate: Date = AddOn.dateFormatter.date(from: warrantyEndDateString) {
            self.warrantyEndDate = warrantyEndDate
        }
        self.accountNo = json["account_no"] as? String
    }

}

public extension AddOn {
    // account: AddOn belongs-to Account
    var account: Account? {
        if let accountNo = self.accountNo {
            return AccountDataController.shared.getAccount(by: accountNo)
        }
        return nil
    }

}
