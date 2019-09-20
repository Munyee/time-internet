//  BankDataController.swift
//  TimeSelfCareData/Controllers
//
//  Opera House | Data - Data Controller
//  Updated 2017-11-13
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import Foundation
import Alamofire

public class BankDataController {
    private static let _sharedInstance: BankDataController = BankDataController()
    public static var shared: BankDataController {
        return _sharedInstance
    }

    var banks: [Bank] = []

    func loadBankData(
        related: [String] = [],
        filters: [String] = [],
        order: [String] = [],
        offset: Int = 0,
        limit: Int = 1_000,
        completion: @escaping ListListener<Bank>
        ) {
        let combinedRelated = ([
            "payment_types_by_payment_type_typeId"
            ] + related).joined(separator: ",")

        let combinedFilter = ([
            ] + filters).joined(separator: " AND ")

        let combinedOrder = ([
            ] + order).joined(separator: ",")

        APIClient.shared
            .getRequest(
                path: "data/banks",
                filter: combinedFilter,
                related: combinedRelated,
                order: combinedOrder,
                offset: offset,
                limit: limit)
            .responseJSON { (response: DataResponse<Any>) in
                var banks: [Bank] = []
                var responseError: Error? = nil
                do {
                    let responseJSON = try APIClient.shared.JSONFromResponse(response: response)
                    if let resourceJSON = responseJSON["resource"] as? [[String : Any]] {
                        banks = self.processResponse(resourceJSON)
                    }
                } catch {
                    responseError = error
                    debugPrint("Error loading banks: \(error)")
                }
                completion(banks, responseError)
            }
    }

    func processResponse(_ jsonArray: [[String : Any]]) -> [Bank] {
        // Bank belongs-to PaymentType (paymentType)
        var paymentTypeJsonArray: [[String : Any]] = []
        paymentTypeJsonArray = jsonArray.flatMap { $0["payment_types_by_payment_type_type_id"] as? [String : Any] }
        if !paymentTypeJsonArray.isEmpty {
            _ = PaymentTypeDataController.shared.processResponse(paymentTypeJsonArray)
        }

        // Process Bank Data
        var banks: [Bank] = []
        banks += self.process(jsonArray)
        self.insert(banks)

        return banks
    }

    private func process(_ jsonArray: [[String : Any]]) -> [Bank] {
        return jsonArray.flatMap { Bank(with: $0) }
    }

    private func insert(_ incomingBanks: [Bank]) {
        let allBanks = incomingBanks + self.banks

        let incomingBankids: [String] = incomingBanks.flatMap { $0.bankId }
        let existingBankids: [String] = self.banks.flatMap { $0.bankId }

        let incomingUnionExistingBankids = Set<String>(incomingBankids + existingBankids)
        self.banks = incomingUnionExistingBankids.flatMap { (bankId: String) -> Bank? in
            allBanks.first { $0.bankId == bankId }
        }

        return
    }
}

public extension BankDataController {
    func getBank(by bankId: String) -> Bank? {
        return self.banks.first { $0.bankId == bankId }
    }

    func getBanks(
        paymentType: PaymentType? = nil,
        searchText: String? = nil
        ) -> [Bank] {
        var filteredItems = self.banks

        if let paymentType = paymentType {
            filteredItems = filteredItems.filter { $0.paymentTypeTypeId == paymentType.typeId.rawValue }
        }

        return filteredItems
    }

    func loadBanks(
        bankId: String? = nil,
        paymentType: PaymentType? = nil,
        searchText: String? = nil,
        order: [String] = [],
        offset: Int = 0,
        limit: Int = 1_000,
        completion: @escaping ListListener<Bank>
        ) {
        var filters: [String] = []

        if let bankId = bankId {
            filters.append("(bankId = \(bankId))")
        }

        if let paymentType = paymentType {
            filters.append("(payment_type_type_id ='\(paymentType.typeId)')")
        }

        self.loadBankData(
            filters: filters,
            order: order,
            offset: offset,
            limit: limit,
            completion: completion)
    }

}
