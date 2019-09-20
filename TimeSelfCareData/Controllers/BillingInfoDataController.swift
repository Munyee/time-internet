//  BillingInfoDataController.swift
//  TimeSelfCareData/Controllers
//
//  Opera House | Data - Data Controller
//  Updated 2018-02-23
//  Copyright © 2018 Apptivity Lab. All rights reserved.
//

import Foundation
import Alamofire

public class BillingInfoDataController {
    private static let _sharedInstance: BillingInfoDataController = BillingInfoDataController()
    public static var shared: BillingInfoDataController {
        return _sharedInstance
    }

    var billingInfos: [BillingInfo] = []

    func loadBillingInfoData(
        path: String,
        body: [String: Any],
        completion: @escaping ListListener<BillingInfo>
    ) {
        APIClient.shared
            .postRequest(path: path, body: body) { (json: [String: Any], error: Error?) in
                var billingInfo: [BillingInfo] = []
                if let dataJSON = json["data"] as? [String: Any],
                    let billingInfoJSON = dataJSON["billing_info"] as? [String: Any] {
                    var processedBillingInfoJSON = billingInfoJSON
                    processedBillingInfoJSON["can_update_billing_address"] = dataJSON["can_update_billing_address"]
                    processedBillingInfoJSON["can_update_billing_method"] = dataJSON["can_update_billing_method"]
                    processedBillingInfoJSON["account_no"] = body["account_no"]

                    processedBillingInfoJSON["list_billing_method"] = dataJSON["list_billing_method"]
                    billingInfo = self.processResponse([processedBillingInfoJSON])

                }
                completion(billingInfo, error)
            }
    }

    func processResponse(_ jsonArray: [[String : Any]]) -> [BillingInfo] {
        var billingInfos: [BillingInfo] = []
        billingInfos += self.process(jsonArray)
        self.insert(billingInfos)

        return billingInfos
    }

    private func process(_ jsonArray: [[String : Any]]) -> [BillingInfo] {
        return jsonArray.compactMap { BillingInfo(with: $0) }
    }

    private func insert(_ incomingBillingInfos: [BillingInfo]) {
        let allBillingInfos = incomingBillingInfos + self.billingInfos

        let incoming: [String] = incomingBillingInfos.compactMap { $0.accountNo }
        let existing: [String] = self.billingInfos.compactMap { $0.accountNo }

        let incomingUnionExisting = Set<String>(incoming + existing)
        self.billingInfos = incomingUnionExisting.compactMap { (accountNo: String ) -> BillingInfo? in
            allBillingInfos.first { $0.accountNo == accountNo }
        }

        let sortedList = self.billingInfos
        self.billingInfos = sortedList
        return
    }

    public func reset() {
        self.billingInfos.removeAll()
    }
}

public extension BillingInfoDataController {
    func getBillingInfo(by accountNo: String) -> BillingInfo? {
        return self.billingInfos.first { $0.accountNo == accountNo }
    }

    func getBillingInfos(
        account: Account? = nil,
        searchText: String? = nil
    ) -> [BillingInfo] {
        var filteredItems = self.billingInfos

        if let account = account {
            filteredItems = filteredItems.filter { $0.accountNo == account.accountNo }
        }

        return filteredItems
    }

    func loadBillingInfos(
        account: Account? = nil,
        completion: @escaping ListListener<BillingInfo>
    ) {
        let path = "get_account_billing_info"
        let body = [
            "username": AccountController.shared.profile?.username,
            "account_no": account?.accountNo,
            "blub": "yes"
        ]
        self.loadBillingInfoData(path: path, body: body, completion: completion)
    }

    func updateBillingInfo(billingInfo: BillingInfo, completion: @escaping SimpleRequestListener) {
        var body: [String: Any] = [
            "username": AccountController.shared.profile?.username,
            "blub": "yes"
        ]
        for (key, value) in billingInfo.toJson() {
            body[key] = value
        }
        APIClient.shared.postRequest(path: "change_billing_info", body: body) { (_, error: Error?) in
            completion(error)
        }
    }

}
