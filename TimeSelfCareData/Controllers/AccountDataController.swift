//  AccountDataController.swift
//  TimeSelfCareData/Controllers
//
//  Opera House | Data - Data Controller
//  Updated 2017-11-13
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import Foundation
import Alamofire

public class AccountDataController {
    private static let _sharedInstance: AccountDataController = AccountDataController()
    public static var shared: AccountDataController {
        return _sharedInstance
    }

    var accounts: [Account] = []

    func loadAccountData(
        path: String,
        body: [String: Any],
        completion: @escaping ListListener<Account>
    ) {
        APIClient.shared.postRequest(path: path, body: body) { (json: [String: Any], error: Error?) in
            var accounts: [Account] = []
            // API return format requires heave manipulation.
            guard var dataJSON = json["data"] as? [String: Any],
                let accountsJSON = dataJSON["accounts"] as? [String: Any] else {
                    completion(accounts, error)
                    return
            }

            let processedAccountsJSON: [[String: Any]] = accountsJSON.keys.compactMap {
                [
                    "account_no": $0,
                    "display_account_no": accountsJSON[$0] as? String
                ]
            }
            var fullAccountsJSON: [[String: Any]] = []
            processedAccountsJSON.forEach { accountJSON in
                var newBody = body
                newBody["account_no"] = accountJSON["account_no"]

                APIClient.shared.postRequest(path: "get_account_info", body: newBody) { (responseJSON: [String: Any], error: Error?) in
                    if var responseDataJSON = responseJSON["data"] as? [String: Any] {
                        responseDataJSON["title"] = responseDataJSON["account_label"]
                        responseDataJSON["account_no"] = newBody["account_no"]
                        responseDataJSON["profile_username"] = newBody["username"]
                        responseDataJSON.update(other: accountJSON)
                        fullAccountsJSON.append(responseDataJSON)
                    } else {
                        fullAccountsJSON.append(accountJSON)
                    }

                    if fullAccountsJSON.count == processedAccountsJSON.count {
                        accounts = self.processResponse(fullAccountsJSON)
                        completion(accounts, error)
                    }
                }
            }
        }
    }

    func processResponse(_ jsonArray: [[String : Any]]) -> [Account] {
        // Account belongs-to Profile (profile)
        var profileJsonArray: [[String : Any]] = []
        profileJsonArray = jsonArray.compactMap { $0["profile"] as? [String : Any] }
        if !profileJsonArray.isEmpty {
            _ = ProfileDataController.shared.processResponse(profileJsonArray)
        }

        // Process Account Data
        var accounts: [Account] = []
        accounts += self.process(jsonArray)
        self.insert(accounts)

        return accounts
    }

    private func process(_ jsonArray: [[String : Any]]) -> [Account] {
        return jsonArray.compactMap { Account(with: $0) }
    }

    private func insert(_ incomingAccounts: [Account]) {
        let allAccounts = incomingAccounts + self.accounts

        let incomingAccountnos: [String] = incomingAccounts.compactMap { $0.accountNo }
        let existingAccountnos: [String] = self.accounts.compactMap { $0.accountNo }

        let incomingUnionExistingAccountnos = Set<String>(incomingAccountnos + existingAccountnos)
        self.accounts = incomingUnionExistingAccountnos.compactMap { (accountNo: String) -> Account? in
            allAccounts.first { $0.accountNo == accountNo }
        }

        return
    }
}

public extension AccountDataController {
    func getAccount(by accountNo: String) -> Account? {
        return self.accounts.first { $0.accountNo == accountNo }
    }

    func getAccounts(
        profile: Profile? = nil,
        searchText: String? = nil
    ) -> [Account] {
        var filteredItems = self.accounts

        if let profile = profile {
            filteredItems = filteredItems.filter { $0.profileUsername == profile.username }
        }

        if let searchText = searchText {
            filteredItems = filteredItems.filter { $0.accountNo.lowercased().contains(searchText.lowercased()) }
        }

        return filteredItems
    }

    func loadAccounts(
        profile: Profile? = nil,
        completion: @escaping ListListener<Account>
        ) {
        let path = "get_accounts"
        var body: [String: Any] = [:]
        body["username"] = (profile ?? AccountController.shared.profile)?.username
        self.loadAccountData(
            path: path,
            body: body,
            completion: completion)
    }

    func loadConnectionStatus(account: Account, service: Service, completion: @escaping SimpleRequestListener) {
        let path = "check_conn_status"
        var body: [String: Any] = [:]
        body["account_no"] = account.accountNo
        body["username"] = account.profileUsername
        body["service_id"] = service.serviceId

        APIClient.shared.postRequest(path: path, body: body) { response, error in
            completion(response, error)
        }
    }
}
