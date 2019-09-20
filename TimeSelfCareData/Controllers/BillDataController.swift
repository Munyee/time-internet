//  BillDataController.swift
//  TimeSelfCareData/Controllers
//
//  Opera House | Data - Data Controller
//  Updated 2017-11-13
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import Foundation
import Alamofire

public class BillDataController {
    private static let _sharedInstance: BillDataController = BillDataController()
    public static var shared: BillDataController {
        return _sharedInstance
    }

    var bills: [Bill] = []

        func loadBillData(
            path: String,
            body: [String: Any],
            completion: @escaping ListListener<Bill>
        ) {
        APIClient.shared.postRequest(path: path, body: body) { (json: [String: Any], error: Error?) in
            var bills: [Bill] = []
            if var dataJSON = json["data"] as? [String: Any] {
                if let billJSON = dataJSON["bill"] as? [String: Any] {
                   var processedBillJSON = billJSON
                    processedBillJSON["account_no"] = body["account_no"]
                   bills = self.processResponse([processedBillJSON])
                } else if let billJSONDict = dataJSON["bills"] as? [String: Any] {
                    let billJSONArray: [[String: Any]] = billJSONDict.keys.compactMap {
                        var billJSON = billJSONDict[$0] as? [String: Any]
                        billJSON?["account_no"] = body["account_no"]
                        return billJSON
                    }
                    bills = self.processResponse(billJSONArray)
                }

                var paymentTypeJSONArray: [[String: Any]] = []
                let keys = ["fpx", "cc"]
                keys.forEach { key in
                    var paymentTypeJSON: [String: Any] = [:]
                    paymentTypeJSON["type_id"] = key
                    paymentTypeJSON["account_no"] = body["account_no"]
                    paymentTypeJSON["min_amount"] = Double((dataJSON[key] as? [String: Any])?["min_amount"] as? String ?? "1.00")
                    paymentTypeJSONArray.append(paymentTypeJSON)
                }
                _ = PaymentTypeDataController.shared.processResponse(paymentTypeJSONArray)

                var bankJSONArray: [[String: Any]] = []
                if let fpxJSONArray = dataJSON["fpx"] as? [String:Any],
                    let bankIdsJSON = fpxJSONArray["list_bank_id"] as? [String: Any] {
                    for bankId in bankIdsJSON.keys {
                        var bankJSON: [String: Any] = [:]
                        bankJSON["bank_id"] = bankId
                        bankJSON["name"] = bankIdsJSON[bankId]
                        bankJSONArray.append(bankJSON)
                    }
                }
                 _ = BankDataController.shared.processResponse(bankJSONArray)
            }
            completion(bills, error)
        }
    }

    func processResponse(_ jsonArray: [[String : Any]]) -> [Bill] {
        // Bill belongs-to Account (account)
        var accountJsonArray: [[String : Any]] = []
        accountJsonArray = jsonArray.compactMap { $0["accounts_by_account_no"] as? [String : Any] }
        if !accountJsonArray.isEmpty {
            _ = AccountDataController.shared.processResponse(accountJsonArray)
        }

        // Bill belongs-to-many PaymentType (paymentTypes)
        // Cannot load/process related belongs-to-many

        // Process Bill Data
        var bills: [Bill] = []
        bills += self.process(jsonArray)
        self.insert(bills)

        return bills
    }

    private func process(_ jsonArray: [[String : Any]]) -> [Bill] {
        return jsonArray.compactMap { Bill(with: $0) }
    }

    private func insert(_ incomingBills: [Bill]) {
        let allBills = incomingBills + self.bills

        let incomingInvoicenos: [String] = incomingBills.compactMap { $0.invoiceNo }
        let existingInvoicenos: [String] = self.bills.compactMap { $0.invoiceNo }

        let incomingUnionExistingInvoicenos = Set<String>(incomingInvoicenos + existingInvoicenos)
        self.bills = incomingUnionExistingInvoicenos.compactMap { (invoiceNo: String) -> Bill? in
            allBills.first { $0.invoiceNo == invoiceNo }
        }

        return
    }
}

public extension BillDataController {
    func getBill(by invoiceNo: String) -> Bill? {
        return self.bills.first { $0.invoiceNo == invoiceNo }
    }

    func getBills(
        account: Account? = nil,
        paymentType: PaymentType? = nil,
        searchText: String? = nil
    ) -> [Bill] {
        var filteredItems = self.bills

        if let account = account {
            filteredItems = filteredItems.filter { $0.accountNo == account.accountNo }
        }

        if let paymentType = paymentType {
            filteredItems = filteredItems.filter {
                $0.paymentTypes
                    .split(separator: ",")
                    .contains { "\($0)" == paymentType.typeId.rawValue }
            }
        }

        return filteredItems
    }

    func loadBills(
        invoiceNo: String? = nil,
        account: Account? = nil,
        paymentType: PaymentType? = nil,
        completion: @escaping ListListener<Bill>
    ) {
        let path = "get_account_bill_info"
        var body: [String: Any] = [:]
        body["username"] =  AccountController.shared.profile?.username
        body["account_no"] = account?.accountNo
        self.loadBillData(path: path, body: body, completion: completion)
    }

    func loadPastBills(
        account: Account? = nil,
        completion: @escaping ListListener<Bill>
        ) {
        let path = "get_account_past_bills"
        var body: [String: Any] = [:]
        body["username"] =  AccountController.shared.profile?.username
        body["account_no"] = account?.accountNo
        self.loadBillData(path: path, body: body, completion: completion)
    }
}
