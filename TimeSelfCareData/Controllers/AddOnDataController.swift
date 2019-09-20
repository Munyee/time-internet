//  AddOnDataController.swift
//  TimeSelfCareData/Controllers
//
//  Opera House | Data - Data Controller
//  Updated 2017-11-17
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import Foundation
import Alamofire

public class AddOnDataController {
    private static let _sharedInstance: AddOnDataController = AddOnDataController()
    public static var shared: AddOnDataController {
        return _sharedInstance
    }

    var addOns: [AddOn] = []

    func loadAddOnData(
        path: String,
        body: [String: Any],
        completion: @escaping ListListener<AddOn>
        ) {
        APIClient.shared.postRequest(path: path, body: body) { (json: [String: Any], error: Error?) in
            var addOns: [AddOn] = []
            if var dataJSON = json["data"] as? [String: Any],
            var historyJSONDict = dataJSON["history"] as? [String: Any] {
                let addOnsJSON = historyJSONDict.keys.compactMap { key -> [String: Any]? in
                    var json = historyJSONDict[key] as? [String: Any]
                    json?["account_no"] = body["account_no"]

                    if let dates: [String] = ((json?["warranty"] as? String)?.components(separatedBy: " - "))?.compactMap({ $0 }),
                        let startDate = dates.first,
                        let endDate = dates.last {
                        json?["warranty_start_date"] = "\(startDate) 12:00 AM"
                        json?["warranty_end_date"] = "\(endDate) 12:00 AM"
                    }
                    if let infosJSON = json?["infos"] as? [String: Any] {
                        json?["image"] = infosJSON["images"]
                        if let featureJSONDict = infosJSON["features"] as? [String: Any] {
                            json?["features"] = featureJSONDict.keys.reduce("") { result, key -> String in
                                if let feature = featureJSONDict[key] as? String {
                                    return "\(result)-\(feature)\n"
                                }
                                return result
                            }
                        }
                    }
                    return json
                }
                addOns = self.processResponse(addOnsJSON)
            }
            completion(addOns, error)
        }
    }

    func processResponse(_ jsonArray: [[String : Any]]) -> [AddOn] {
        // AddOn belongs-to Account (account)
        var accountJsonArray: [[String : Any]] = []
        accountJsonArray = jsonArray.compactMap { $0["accounts_by_account_account_no"] as? [String : Any] }
        if !accountJsonArray.isEmpty {
            _ = AccountDataController.shared.processResponse(accountJsonArray)
        }

        // Process AddOn Data
        var addOns: [AddOn] = []
        addOns += self.process(jsonArray)
        self.insert(addOns)

        return addOns
    }

    private func process(_ jsonArray: [[String : Any]]) -> [AddOn] {
        return jsonArray.compactMap { AddOn(with: $0) }
    }

    private func insert(_ incomingAddOns: [AddOn]) {
        let allAddOns = incomingAddOns + self.addOns

        let incomingTimestamps: [Int] = incomingAddOns.compactMap { $0.timestamp }
        let existingTimestamps: [Int] = self.addOns.compactMap { $0.timestamp }

        let incomingUnionExistingTimestamps = Set<Int>(incomingTimestamps + existingTimestamps)
        self.addOns = incomingUnionExistingTimestamps.compactMap { (timestamp: Int) -> AddOn? in
            allAddOns.first { $0.timestamp == timestamp }
        }

        return
    }
}

public extension AddOnDataController {
    func getAddOn(by timestamp: Int) -> AddOn? {
        return self.addOns.first { $0.timestamp == timestamp }
    }

    func getAddOns(
        account: Account? = nil,
        searchText: String? = nil
        ) -> [AddOn] {
        var filteredItems = self.addOns

        if let account = account {
            filteredItems = filteredItems.filter { $0.accountNo == account.accountNo }
        }

        return filteredItems
    }

    func loadAddOns(
        profile: Profile? = nil,
        account: Account? = nil,
        completion: @escaping ListListener<AddOn>
        ) {
        let path = "get_account_addons"
        var body: [String: Any] = [:]
        body["username"] = profile?.username
        body["account_no"] = account?.accountNo
        self.loadAddOnData(
            path: path,
            body: body,
            completion: completion)
    }

}
