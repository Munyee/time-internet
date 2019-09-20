//  Ssid.swift
//  TimeSelfCareData/Model
//
//  Opera House | Data - Model Class
//  Updated 2018-03-05
//  Copyright © 2018 Apptivity Lab. All rights reserved.
//

import Foundation

public class Ssid: JsonRecord {
    public var name: String?
    public var isEnabled: Bool?
    public var password: String?

    // Relationships
    public var accountNo: String
    public var serviceId: String

    public required init?(with json: [String: Any]) {
        guard
            let accountNo = json["account_no"] as? String,
            let serviceId = json["service_id"] as? String
        else {
                return nil
        }
        self.name = json["name"] as? String
        self.isEnabled = json["is_enabled"] as? Bool
        self.password = json["password"] as? String
        self.accountNo = accountNo
        self.serviceId = serviceId
    }

    public func toJson() -> [String: Any] {
        var json: [String: Any] = [:]

        // Attributes
        json["ssid_username"] = self.name
        json["ssid_password"] = self.password
        json["account_no"] = self.accountNo
        json["service_id"] = self.serviceId
        return json
    }
}

public extension Ssid {
    // account: Ssid belongs-to Account
    var account: Account? {
        return AccountDataController.shared.getAccount(by: self.accountNo)
    }

    // service: Ssid belongs-to Service
    var service: Service? {
        return ServiceDataController.shared.getService(by: self.serviceId)
    }
}
