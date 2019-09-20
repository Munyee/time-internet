//  ServiceDataController.swift
//  TimeSelfCareData/Controllers
//
//  Opera House | Data - Data Controller
//  Updated 2017-11-13
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import Foundation
import Alamofire

extension Dictionary {
    mutating func update(other:Dictionary) {
        for (key, value) in other {
            self.updateValue(value, forKey:key)
        }
    }
}

public class ServiceDataController {
    private static let _sharedInstance: ServiceDataController = ServiceDataController()
    public static var shared: ServiceDataController {
        return _sharedInstance
    }

    var services: [Service] = []

    func loadServiceData(
        path: String,
        body: [String: Any],
        completion: @escaping ListListener<Service>
    ) {
        APIClient.shared
            .postRequest(path: path, body: body) { (json: [String: Any], error: Error?) in
                var services: [Service] = []
                if var dataJSON = json["data"] as? [String: Any],
                    var servicesJSONDict = dataJSON["services"] as? [String: Any] {
                    var servicesJSON = servicesJSONDict.keys.compactMap { servicesJSONDict[$0] as? [String: Any] }
                    servicesJSON = servicesJSON.map { serviceJSON -> [String: Any] in
                        var newServiceJSON = serviceJSON
                        newServiceJSON["account_no"] = body["account_no"]
                        return newServiceJSON
                    }
                    APIClient.shared.postRequest(path: "get_account_voices_info", body: body) { (voiceServicesResponseJSON: [String: Any], error: Error?) in
                        if var voiceDataJSON = voiceServicesResponseJSON["data"] as? [String: Any],
                            var voiceServicesJSONDict = voiceDataJSON["services"] as? [String: Any] {
                            let voiceServicesJSON: [[String: Any]] = voiceServicesJSONDict.keys.compactMap { voiceServicesJSONDict[$0] as? [String: Any] }
                            servicesJSON = servicesJSON.map { serviceJSON -> [String: Any] in
                                var voiceServiceJSON: [String: Any] = voiceServicesJSON.first { $0["service_id"] as? String == serviceJSON["service_id"] as? String } ?? [:]
                                voiceServiceJSON.update(other: serviceJSON)
                                return voiceServiceJSON
                            }
                        }
                        services = self.processResponse(servicesJSON)
                        completion(services, error)
                    }
                } else {
                    completion(services, error)
                }
            }
    }

    func processResponse(_ jsonArray: [[String : Any]]) -> [Service] {
        // Service belongs-to Account (account)
        var accountJsonArray: [[String : Any]] = []
        accountJsonArray = jsonArray.compactMap { $0["account_no"] as? [String : Any] }
        if !accountJsonArray.isEmpty {
            _ = AccountDataController.shared.processResponse(accountJsonArray)
        }

        // Process Service Data
        var services: [Service] = []
        services += self.process(jsonArray)
        self.insert(services)

        return services
    }

    private func process(_ jsonArray: [[String : Any]]) -> [Service] {
        return jsonArray.compactMap { Service(with: $0) }
    }

    private func insert(_ incomingServices: [Service]) {
        let allServices = incomingServices + self.services

        let incomingServiceids: [String] = incomingServices.compactMap { $0.serviceId }
        let existingServiceids: [String] = self.services.compactMap { $0.serviceId }

        let incomingUnionExistingServiceids = Set<String>(incomingServiceids + existingServiceids)
        self.services = incomingUnionExistingServiceids.compactMap { (serviceId: String) -> Service? in
            allServices.first { $0.serviceId == serviceId }
        }

        return
    }
}

public extension ServiceDataController {
    func getService(by serviceId: String) -> Service? {
        return self.services.first { $0.serviceId == serviceId }
    }

    func getServices(
        account: Account? = nil
        ) -> [Service] {
        var filteredItems = self.services

        if let account = account {
            filteredItems = filteredItems.filter { $0.accountNo == account.accountNo }
        }

        return filteredItems
    }

    func loadServices(
        profile: Profile? = nil,
        accountNo: String,
        completion: @escaping ListListener<Service>
    ) {
        let path = "get_account_services_info"
        var body: [String: Any] = [:]
        body["username"] = (profile ?? AccountController.shared.profile)?.username
        body["account_no"] = accountNo

        self.loadServiceData(path: path, body: body, completion: completion)
    }

}
