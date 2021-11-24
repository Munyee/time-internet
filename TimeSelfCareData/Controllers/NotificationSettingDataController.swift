//  BillingInfoDataController.swift
//  TimeSelfCareData/Controllers
//
//  Opera House | Data - Data Controller
//  Updated 2018-02-23
//  Copyright © 2018 Apptivity Lab. All rights reserved.
//

import Foundation
import Alamofire
import ApptivityFramework

public class NotificationSettingDataController {
    private static let _sharedInstance: NotificationSettingDataController = NotificationSettingDataController()
    public static var shared: NotificationSettingDataController {
        return _sharedInstance
    }

    var notificationSettings: [NotificationSetting] = []

    func loadNotificationSettingData(
        path: String,
        body: [String: Any],
        completion: @escaping ListListener<NotificationSetting>
        ) {
        APIClient.shared
            .postRequest(path: path, body: body) { (json: [String: Any], error: Error?) in
                var notificationSettings: [NotificationSetting] = []
                if var dataJSON = json["data"] as? [String: Any] {
                    dataJSON["account_no"] = body["account_no"]
                    notificationSettings = self.processResponse([dataJSON])
                }

                if let deviceToken = Installation.current().valueForKey("deviceToken") as? String,
                    let notificationSetting = notificationSettings.first,
                    deviceToken != notificationSetting.deviceToken {
                    notificationSetting.deviceToken = deviceToken
                    self.updateNotificationSetting(notificationSetting: notificationSetting)
                }

                completion(notificationSettings, error)
            }
    }

    func processResponse(_ jsonArray: [[String : Any]]) -> [NotificationSetting] {
        var notififcationSettings: [NotificationSetting] = []
        notififcationSettings += self.process(jsonArray)
        self.insert(notififcationSettings)

        return notififcationSettings
    }

    private func process(_ jsonArray: [[String : Any]]) -> [NotificationSetting] {
        return jsonArray.compactMap { NotificationSetting(with: $0) }
    }

    private func insert(_ incomingNotificationSettings: [NotificationSetting]) {
        let allNotificationSettings = incomingNotificationSettings + self.notificationSettings

        let incoming: [String] = incomingNotificationSettings.compactMap { $0.accountNo }
        let existing: [String] = self.notificationSettings.compactMap { $0.accountNo }

        let incomingUnionExisting = Set<String>(incoming + existing)
        self.notificationSettings = incomingUnionExisting.compactMap { (accountNo: String ) -> NotificationSetting? in
            allNotificationSettings.first { $0.accountNo == accountNo }
        }

        let sortedList = self.notificationSettings
        self.notificationSettings = sortedList
        return
    }

    public func reset() {
        self.notificationSettings.removeAll()
    }
}

public extension NotificationSettingDataController {
    func getNotificationSetting(by accountNo: String) -> NotificationSetting? {
        return self.notificationSettings.first { $0.accountNo == accountNo }
    }

    func getNotificationSettings(
        account: Account? = nil,
        searchText: String? = nil
        ) -> [NotificationSetting] {
        var filteredItems = self.notificationSettings

        if let account = account {
            filteredItems = filteredItems.filter { $0.accountNo == account.accountNo }
        }

        return filteredItems
    }

    func loadNotificationSettings(
        account: Account? = nil,
        completion: @escaping ListListener<NotificationSetting>
        ) {
        let path = "get_account_notification_info"
        let body = [
            "username": AccountController.shared.profile?.username,
            "account_no": account?.accountNo
        ]
        self.loadNotificationSettingData(path: path, body: body, completion: completion)
    }

    func updateNotificationSetting(notificationSetting: NotificationSetting, completion: SimpleRequestListener? = nil) {
        var body: [String: Any] = [:]
        body["username"] = AccountController.shared.profile?.username
        body["app_version"] = Installation.appVersion
        for (key, value) in notificationSetting.toJson() {
            body[key] = value
        }
        APIClient.shared.postRequest(path: "change_notification_info", body: body) { response, error in
            completion?(response, error)
        }
    }

}
