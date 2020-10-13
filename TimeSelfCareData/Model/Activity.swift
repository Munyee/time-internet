//  Activity.swift
//  TimeSelfCareData/Model
//
//  Opera House | Data - Model Class
//  Updated 2018-03-05
//  Copyright © 2018 Apptivity Lab. All rights reserved.
//

import Foundation

public class Activity: JsonRecord {
    public enum Status: String {
        case paid = "paid"
        case unpaid = "unpaid"
        case open = "open"
        case closed = "closed"

        // reward
        case available = "available"
        case grabbed = "grabbed"
        case redeemed = "redeemed"
        case fullyGrabbed = "fully_grabbed"

        case unknown
    }

    public enum ActivityType: String {
        case newBill = "New Bill"
        case ticket = "Ticket"
        case newMessage = "New Message"
        case rewards = "TIME Rewards"
        case billing = "Billing"
        case addOns = "Add Ons"
        case broadbandPlan = "Broadband Plan"
        case voicePlan = "Voice Plan"
        case huae = "Hook Up & Earn"
    }

    public var id: String
    public var type: ActivityType
    public var line1: String?
    public var line2: String?
    public var status: String?
    public var isNew: Bool = false

    public var isActionable: Bool {
        switch self.type {
        case .newBill,
             .ticket,
             .rewards,
             .billing,
             .addOns,
             .huae:
           return true
        default:
            return false
        }
    }

    // Relationships
    public var profileUsername: String
    public var accountNo: String?

    public required init?(with json: [String: Any]) {
        guard
            let id = json["id"] as? String,
            let activityTypeStr = json["activity"] as? String,
            let activityType = ActivityType(rawValue: activityTypeStr),
            let profileUsername = json["profile_username"] as? String
        else {
                debugPrint("ERROR: Failed to construct Activity from JSON\n\(json)")
                return nil
        }

        self.id = id
        self.type = activityType

        self.line1 = json["line1"] as? String
        self.line2 = json["line2"] as? String
        self.status = json["status"] as? String
        self.isNew = json["is_new"] as? Bool ?? false
        self.accountNo = json["account_no"] as? String
        self.profileUsername = profileUsername
    }

}

public extension Activity {
    // profile: Activity belongs-to Profile
    var profile: Profile? {
        return ProfileDataController.shared.getProfile(by: self.profileUsername)
    }

    // account: Activity belongs-to Account
    var account: Account? {
        if let accountNo = self.accountNo {
            return AccountDataController.shared.getAccount(by: accountNo)
        }
        return nil
    }
}
