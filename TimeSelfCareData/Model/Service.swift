//  Service.swift
//  TimeSelfCareData/Model
//
//  Opera House | Data - Model Class
//  Updated 2017-11-13
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import Foundation

public class Service: JsonRecord {
    public enum Category: String {
        case broadband = "broadband"
        case broadbandAstro = "broadband_astro"
        case voice = "voice"
        case unknown = "unknown"
    }

    public enum ServiceStatus: String {
        case active = "active"
        case inactive = "inactive"
        case unknown = "unknown"
    }

    public let serviceId: String
    public var category: Service.Category?
    public var name: String?
    public var pricePackage: String?
    public var address: String?
    public var serviceStatus: Service.ServiceStatus?
    public var isClear: Bool?
    public var isThf: Bool?
    public var thfQrcodeCode: String?
    public var thfQrcodeUrl: String?
    public var thfQrcodeGenCount: Int?
    public var haveFreeminutes: Bool?
    public var freeMinutesTotal: String?
    public var freeMinutesBalance: String?
    public var freeMinutesUnit: String?

    // Relationships
    public var accountNo: String?

    public init() {
        self.serviceId = String()
    }

    public required init?(with json: [String : Any]) {
        guard
            let serviceId: String = json["service_id"] as? String
            else {
                debugPrint("ERROR: Failed to construct Service from JSON\n\(json)")
                return nil
        }

        self.serviceId = serviceId
        if let categoryRawValue = json["category"] as? String,
            let category = Category(rawValue: categoryRawValue) {
            self.category = category
        }
        self.name = json["name"] as? String
        self.pricePackage = json["price"] as? String
        self.address = json["address"] as? String
        if let serviceStatusRawValue = json["service_status"] as? String,
            let serviceStatus = ServiceStatus(rawValue: serviceStatusRawValue) {
            self.serviceStatus = serviceStatus
        }
        self.isClear = json["is_clear"] as? Bool
        self.isThf = json["is_thf"] as? Bool
        self.thfQrcodeCode = json["thf_qrcode_code"] as? String
        self.thfQrcodeUrl = json["thf_qrcode_url"] as? String
        if let genCountString = json["thf_qrcode_gen_count"] as? String {
            self.thfQrcodeGenCount = Int(genCountString)
        }
        self.haveFreeminutes = json["have_freeminutes"] as? Bool
        self.freeMinutesTotal = json["freeminutes_total"] as? String
        self.freeMinutesBalance = json["freeminutes_balance"] as? String
        self.freeMinutesUnit = json["freeminutes_unit"] as? String
        self.accountNo = json["account_no"] as? String
    }

}

public extension Service {
    // account: Service belongs-to Account
    var account: Account? {
        if let accountNo = self.accountNo {
            return AccountDataController.shared.getAccount(by: accountNo)
        }
        return nil
    }

}
