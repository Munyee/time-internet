//  ActivityDataController.swift
//  TimeSelfCareData/Controllers
//
//  Opera House | Data - Data Controller
//  Updated 2018-02-23
//  Copyright © 2018 Apptivity Lab. All rights reserved.
//

import Foundation
import Alamofire

public class ActivityDataController {
    private static let _sharedInstance: ActivityDataController = ActivityDataController()
    public static var shared: ActivityDataController {
        return _sharedInstance
    }

    var activities: [Activity] = []

    func loadActivityData(
        path: String,
        body: [String: Any],
        completion: @escaping ListListener<Activity>
        ) {
        APIClient.shared.postRequest(path: path, body: body) { (json: [String: Any], error: Error?) in
            DispatchQueue.global(qos: .background).async {
                var activities: [Activity] = []
                if let dataJSON = json["data"] as? [String: Any],
                    let activityJSONDict = dataJSON["notification_center"] as? [String: Any] {

                    let activityJSONArray: [[String: Any]] = activityJSONDict.keys.compactMap {
                        var activityJSON = activityJSONDict[$0] as? [String: Any]
                        
                        if body["filter"] as? String == "huae" {
                            return activityJSON
                        }
                        
                        activityJSON?["account_no"] = body["account_no"]
                        activityJSON?["profile_username"] = AccountController.shared.profile?.username
                        return activityJSON
                    }
                    activities = self.processResponse(activityJSONArray)
                }
                DispatchQueue.main.async {
                    completion(activities, error)
                }
            }
        }
    }

    func processResponse(_ jsonArray: [[String: Any]]) -> [Activity] {
        var activities: [Activity] = []
        activities += self.process(jsonArray)
        self.insert(activities)

        return activities
    }

    private func process(_ jsonArray: [[String: Any]]) -> [Activity] {
        return jsonArray.compactMap { Activity(with: $0) }
    }

    private func insert(_ incomingActivities: [Activity]) {
        self.activities = incomingActivities.sorted { $0.id > $1.id }
    }

    public func reset() {
        self.activities.removeAll()
    }
}

public extension ActivityDataController {
    func getActivities(
        account: Account? = nil,
        filter: String? = nil
        ) -> [Activity] {
        var filteredItems = self.activities
        
        if filter == "huae" {
            return filteredItems
        }

        if let account = account {
            filteredItems = filteredItems.filter {
                $0.accountNo == account.accountNo
            }
        }

        return filteredItems
    }

    func loadActivities(
        account: Account? = nil,
        filter: String? = "",
        completion: @escaping ListListener<Activity>
        ) {
        let path = "get_account_notification_center"
        let body = [
            "username": AccountController.shared.profile?.username,
            "account_no": account?.accountNo,
            "filter": filter
        ]
        self.loadActivityData(path: path, body: body as [String : Any], completion: completion)
    }

    func markActivityAsRead(for activity: Activity, account: Account? = nil) {
        let path = "click_notification_center"
        let body = [
            "username": AccountController.shared.profile?.username,
            "account_no": account?.accountNo,
            "target_id": "\(activity.id)"
        ]

        self.activities.first { $0.id == activity.id }?.isNew = false
        APIClient.shared.postRequest(path: path, body: body as [String : Any], completion: nil)
    }
}
