//  CreditCardDataController.swift
//  TimeSelfCareData/Controllers
//
//  Opera House | Data - Data Controller
//  Updated 2017-11-13
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import Foundation
import Alamofire
import ApptivityFramework

public class CreditCardDataController {
    private static let _sharedInstance: CreditCardDataController = CreditCardDataController()
    public static var shared: CreditCardDataController {
        return _sharedInstance
    }

    var creditCards: [CreditCard] = []

    func loadCreditCardData(
        path: String,
        body: [String: Any],
        completion: @escaping ListListener<CreditCard>
        ) {
        APIClient.shared.postRequest(path: path, body: body) { (json: [String: Any], error: Error?) in
            var creditCards: [CreditCard] = []
            if var dataJSON = json["data"] as? [String: Any] {
                dataJSON["account_no"] = body["account_no"]
                creditCards = self.processResponse([dataJSON])
                if let creditCardTypeJSON = dataJSON["list_cc_type_id"] as? [String: String] {
                    creditCardTypeJSON.keys.forEach { key in
                        if creditCardTypeJSON[key] == CreditCard.CcType.mastercard.rawValue {
                            Installation.current().set(key, forKey: mastercardIdKey)
                        } else if creditCardTypeJSON[key] == CreditCard.CcType.visa.rawValue {
                            Installation.current().set(key, forKey: visaIdKey)
                        }
                    }
                }
            }

            completion(creditCards, error)
        }
    }

    func processResponse(_ jsonArray: [[String : Any]]) -> [CreditCard] {
        // CreditCard belongs-to Account (account)
        var accountJsonArray: [[String : Any]] = []
        accountJsonArray = jsonArray.compactMap { $0["accounts_by_account_no"] as? [String : Any] }
        if !accountJsonArray.isEmpty {
            _ = AccountDataController.shared.processResponse(accountJsonArray)
        }

        // CreditCard belongs-to Bank (bank)
        var bankJsonArray: [[String : Any]] = []
        bankJsonArray = jsonArray.compactMap { $0["banks_by_bank_bank_id"] as? [String : Any] }
        if !bankJsonArray.isEmpty {
            _ = BankDataController.shared.processResponse(bankJsonArray)
        }

        // Process CreditCard Data
        var creditCards: [CreditCard] = []
        creditCards += self.process(jsonArray)
        self.insert(creditCards)

        return creditCards
    }

    private func process(_ jsonArray: [[String : Any]]) -> [CreditCard] {
        return jsonArray.compactMap { CreditCard(with: $0) }
    }

    private func insert(_ incomingCreditCards: [CreditCard]) {
        let allCreditCards = incomingCreditCards + self.creditCards

        let incomingCcnos: [String] = incomingCreditCards.compactMap { $0.ccNo }

        // For AutoDebit cards, we only care for the new incoming sets
        // since we don't have a stable identifier for cards given than cards
        // can be modified.
        // let existingCcnos: [String] = self.creditCards.compactMap { $0.ccNo }

        let incomingUnionExistingCcnos = Set<String>(incomingCcnos)
        self.creditCards = incomingUnionExistingCcnos.compactMap { (ccNo: String) -> CreditCard? in
            allCreditCards.first { $0.ccNo == ccNo }
        }

        return
    }
}

public extension CreditCardDataController {
    func getCreditCard(by ccNo: String) -> CreditCard? {
        return self.creditCards.first { $0.ccNo == ccNo }
    }

    func getCreditCards(
        account: Account? = nil,
        bank: Bank? = nil,
        searchText: String? = nil
        ) -> [CreditCard] {
        var filteredItems = self.creditCards

        if let account = account {
            filteredItems = filteredItems.filter { $0.accountNo == account.accountNo }
        }

        if let bank = bank {
            filteredItems = filteredItems.filter { $0.bankBankId == bank.bankId }
        }

        return filteredItems
    }

    func loadCreditCards(
        account: Account? = nil,
        completion: @escaping ListListener<CreditCard>
        ) {
        let path = "get_account_autodebit_info"
        var body: [String: Any] = [:]
        body["username"] = AccountController.shared.profile.username
        body["account_no"] = AccountController.shared.selectedAccount?.accountNo
        self.loadCreditCardData(path: path, body: body, completion: completion)
    }

    func removeCreditCard(username: String, account: Account, completion: @escaping ((_ error: Error?) -> Void)) {
        APIClient.shared.removeAutoDebit(username, account: account) { (_, error: Error?) in
            if error == nil {
                self.creditCards = self.creditCards.filter { $0.accountNo != account.accountNo }
            }
            completion(error)
        }
    }

}
