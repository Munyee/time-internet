//  SsidDataController.swift
//  TimeSelfCareData/Controllers
//
//  Opera House | Data - Data Controller
//  Updated 2018-02-23
//  Copyright © 2018 Apptivity Lab. All rights reserved.
//

import Foundation
import Alamofire

public class SsidDataController {
    private static let _sharedInstance: SsidDataController = SsidDataController()
    public static var shared: SsidDataController {
        return _sharedInstance
    }

    var ssids: [Ssid] = []

    func loadSsidData(
        path: String,
        body: [String: Any],
        completion: @escaping ListListener<Ssid>
        ) {
        APIClient.shared
            .postRequest(path: path, body: body) { (_: [String: Any], error: Error?) in
                var ssid: [Ssid] = []
                var json: [String: Any] = [:]
                json["is_enabled"] = error == nil
                json["account_no"] = body["account_no"]
                json["service_id"] = body["service_id"]
                ssid = self.processResponse([json])
                completion(ssid, nil)
            }
    }

    func processResponse(_ jsonArray: [[String: Any]]) -> [Ssid] {
        // Process Ssid Data
        var ssids: [Ssid] = []
        ssids += self.process(jsonArray)
        self.insert(ssids)

        return ssids
    }

    private func process(_ jsonArray: [[String: Any]]) -> [Ssid] {
        return jsonArray.compactMap { Ssid(with: $0) }
    }

    private func insert(_ incomingSsids: [Ssid]) {
        let allSsids = incomingSsids + self.ssids

        let incoming: [String] = incomingSsids.compactMap { $0.accountNo }
        let existing: [String] = self.ssids.compactMap { $0.accountNo }

        let incomingUnionExisting = Set<String>(incoming + existing)
        self.ssids = incomingUnionExisting.compactMap { (accountNo: String ) -> Ssid? in
            allSsids.first { $0.accountNo == accountNo }
        }
    }

    public func reset() {
        self.ssids.removeAll()
    }
}

public extension SsidDataController {
    func getSsid(by accountNo: String) -> Ssid? {
        return self.ssids.first { $0.accountNo == accountNo }
    }

    func getSsids(
        account: Account? = nil,
        service: Service? = nil
        ) -> [Ssid] {
        var filteredItems = self.ssids

        if let account = account {
            filteredItems = filteredItems.filter { $0.accountNo == account.accountNo }
        }
        if let service = service {
            filteredItems = filteredItems.filter { $0.serviceId == service.serviceId }
        }
        return filteredItems
    }

    func loadSsids(
        account: Account? = nil,
        service: Service? = nil,
        completion: @escaping ListListener<Ssid>
        ) {
        let path = "check_ssid"
        var body: [String: Any] = [:]
        body["username"] = account?.profileUsername
        body["account_no"] = account?.accountNo
        body["service_id"] = service?.serviceId

        self.loadSsidData(path: path, body: body, completion: completion)
    }

    func updateSsid(ssid: Ssid, completion: @escaping SimpleRequestListener) {
        var body: [String: Any] = [:]
        body["username"] = ssid.account?.profileUsername
        for (key, value) in ssid.toJson() {
            body[key] = value
        }
        APIClient.shared.postRequest(path: "change_ssid", body: body) { (_, error: Error?) in
            completion(error)
        }
    }
}
