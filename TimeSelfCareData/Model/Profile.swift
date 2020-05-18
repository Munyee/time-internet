//  Profile.swift
//  TimeSelfCareData/Model
//
//  Opera House | Data - Model Class
//  Updated 2017-11-13
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import Foundation

public class Profile: JsonRecord {
    public let username: String
    public var fullname: String?
    public var ic: String?
    public var brn: String?
    public var email: String?
    public var mobileNo: String?
    public var officeNo: String?
    public var contactPerson: String?
    public var billingAddress: String?
    public var todo: String?

    // Relationships
    public var accountsAccountNo: [String] = []

    public init() {
        self.username = String()
    }

    public required init?(with json: [String : Any]) {
        guard
            let username: String = json["username"] as? String
            else {
                debugPrint("ERROR: Failed to construct Profile from JSON\n\(json)")
                return nil
        }

        self.username = username
        self.fullname = json["fullname"] as? String
        self.ic = json["ic"] as? String
        self.brn = json["brn"] as? String
        self.email = json["email"] as? String
        self.mobileNo = json["mobile_no"] as? String
        self.officeNo = json["office_no"] as? String
        self.contactPerson = json["contact_person"] as? String
        self.billingAddress = json["billing_address"] as? String
        self.todo = json["todo"] as? String
    }

    public func toJson() -> [String : Any] {
        var json: [String : Any] = [:]

        // Attributes
        json["username"] = self.username
        json["fullname"] = self.fullname
        json["ic"] = self.ic
        json["brn"] = self.brn
        json["email"] = self.email
        json["mobile_no"] = self.mobileNo
        json["office_no"] = self.officeNo
        json["contact_person"] = self.contactPerson
        json["billing_address"] = self.billingAddress
        json["todo"] = self.todo

        return json
    }
}

public extension Profile {
    // accounts: Profile has-many Account
    var accounts: [Account] {
        return AccountDataController.shared.getAccounts(profile: self)
    }
}
