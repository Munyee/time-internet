//
//  NotificationSetting.swift
//  TimeSelfCareData
//
//  Created by Loka on 15/05/2018.
//  Copyright © 2018 Apptivity Lab. All rights reserved.
//

import Foundation

public class NotificationSetting: JsonRecord {
    public var methodsString: String?
    public var itemsString: String?
    public var methodOptions: [String: String] = [:]
    public var itemOptions: [String: String] = [:]
    public var deviceToken: String?

    public var accountNo: String?

    public required init?(with json: [String : Any]) {
        ((json["list_notification_method"] as? [String: String]) ?? [:]).forEach {
            self.methodOptions[$0.key] = $0.value
        }

        ((json["list_notification_item"] as? [String: String]) ?? [:]).forEach {
            self.itemOptions[$0.key] = $0.value
        }

        self.methodsString = json["notification_method"] as? String
        self.itemsString = json["notification_item"] as? String
        self.deviceToken = json["device_token_ios"] as? String
        self.accountNo = json["account_no"] as? String
    }

    public func toJson() -> [String : Any] {
        var json: [String : Any] = [:]

        // Attributes
        json["notification_method"] = self.methodsString
        json["notification_item"] = self.itemsString
        json["account_no"] = self.accountNo
        json["device_type"] = "ios"
        json["device_token"] = self.deviceToken
        return json
    }
}
