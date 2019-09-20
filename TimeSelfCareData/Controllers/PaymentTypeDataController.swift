//  PaymentTypeDataController.swift
//  TimeSelfCareData/Controllers
//
//  Opera House | Data - Data Controller
//  Updated 2017-11-13
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import Foundation
import Alamofire

public class PaymentTypeDataController {
    private static let _sharedInstance: PaymentTypeDataController = PaymentTypeDataController()
    public static var shared: PaymentTypeDataController {
        return _sharedInstance
    }

    var paymentTypes: [PaymentType] = []

    func loadPaymentTypeData(
        related: [String] = [],
        filters: [String] = [],
        order: [String] = [],
        offset: Int = 0,
        limit: Int = 1_000,
        completion: @escaping ListListener<PaymentType>
    ) {
        let combinedRelated = ([
                "banks_by_payment_type_typeId"
            ] + related).joined(separator: ",")

        let combinedFilter = ([
            ] + filters).joined(separator: " AND ")

        let combinedOrder = ([
            ] + order).joined(separator: ",")

        APIClient.shared
            .getRequest(
                path: "data/payment_types",
                filter: combinedFilter,
                related: combinedRelated,
                order: combinedOrder,
                offset: offset,
                limit: limit)
            .responseJSON { (response: DataResponse<Any>) in
                var paymentTypes: [PaymentType] = []
                var pagination = Pagination()
                var responseError: Error? = nil

                do {
                    let responseJSON = try APIClient.shared.JSONFromResponse(response: response)
                    if let resourceJSON = responseJSON["resource"] as? [[String : Any]] {
                        paymentTypes = self.processResponse(resourceJSON)
                    }
                    if let metadataJSON = responseJSON["meta"] as? [String: Any] {
                        pagination = Pagination(with: metadataJSON)
                    }
                } catch {
                    responseError = error
                    debugPrint("Error loading paymentTypes: \(error)")
                }

                completion(paymentTypes, responseError)
            }
    }

    func processResponse(_ jsonArray: [[String : Any]]) -> [PaymentType] {
        // Process PaymentType Data
        var paymentTypes: [PaymentType] = []
        paymentTypes += self.process(jsonArray)
        self.insert(paymentTypes)

        // PaymentType has-many Bank (banks)
        var banksJsonArray: [[String : Any]] = []
        banksJsonArray = jsonArray.flatMap { $0["banks_by_payment_type_typeId"] as? [[String : Any]] ?? [] }
        if !banksJsonArray.isEmpty {
            _ = BankDataController.shared.processResponse(banksJsonArray)
        }
        return paymentTypes
    }

    private func process(_ jsonArray: [[String : Any]]) -> [PaymentType] {
        return jsonArray.flatMap { PaymentType(with: $0) }
    }

    private func insert(_ incomingPaymentTypes: [PaymentType]) {
        let allPaymentTypes = incomingPaymentTypes + self.paymentTypes

        let incomingTypeids: [String] = incomingPaymentTypes.flatMap { $0.typeId.rawValue }
        let existingTypeids: [String] = self.paymentTypes.flatMap { $0.typeId.rawValue }

        let incomingUnionExistingTypeids = Set<String>(incomingTypeids + existingTypeids)
        self.paymentTypes = incomingUnionExistingTypeids.flatMap { (typeId: String) -> PaymentType? in
            allPaymentTypes.first { $0.typeId.rawValue == typeId }
        }

        return
    }
}

public extension PaymentTypeDataController {
    func getPaymentType(by typeId: String) -> PaymentType? {
        return self.paymentTypes.first { $0.typeId.rawValue == typeId }
    }

    func getPaymentTypes(
        account: Account? = nil
        ) -> [PaymentType] {
        var filteredItems = self.paymentTypes

        if let account = account {
            filteredItems = filteredItems.filter { $0.accountNo == account.accountNo }
        }

        return filteredItems
    }

    func loadPaymentTypes(
        typeId: String? = nil,
        searchText: String? = nil,
        order: [String] = [],
        offset: Int = 0,
        limit: Int = 1_000,
        completion: @escaping ListListener<PaymentType>
    ) {
        var filters: [String] = []

        if let typeId = typeId {
            filters.append("(typeId = \(typeId))")
        }

        self.loadPaymentTypeData(
            filters: filters,
            order: order,
            offset: offset,
            limit: limit,
            completion: completion)
    }

}
