//  Bill.swift
//  TimeSelfCareData/Model
//
//  Opera House | Data - Model Class
//  Updated 2017-11-13
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import Foundation

public class Bill: JsonRecord {
    static private let dateFormatter: DateFormatter = {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "MY")
        dateFormatter.dateFormat = "dd MMMM yyyy"
        return dateFormatter
    }()

    public enum InvoiceStatus: String {
        case paid = "Paid"
        case unpaid = "Unpaid"
        case unknown = "unknown"
    }

    public let invoiceNo: String
    public var invoiceStatus: Bill.InvoiceStatus?
    public var invoiceDate: Date?
    public var dueDate: Date?
    public var currency: String?
    public var previousBalance: Double?
    public var lastPayment: Double?
    public var adjustments: Double?
    public var overdueBalance: Double?
    public var currentCharges: Double?
    public var totalAmountDue: Double?
    public var totalOutstanding: Double?
    public var lastUpdated: Date?
    public var canMakePayment: Bool?
    public var pdf: String?

    // Relationships
    public var accountNo: String?
    public var paymentTypes: [String] = []

    public init() {
        self.invoiceNo = String()
    }

    public required init?(with json: [String : Any]) {
        guard
            let invoiceNo: String = json["invoice_no"] as? String
            else {
                debugPrint("ERROR: Failed to construct Bill from JSON\n\(json)")
                return nil
        }

        self.invoiceNo = invoiceNo
        if let invoiceStatusRawValue = json["invoice_status"] as? String,
            let invoiceStatus = InvoiceStatus(rawValue: invoiceStatusRawValue) {
            self.invoiceStatus = invoiceStatus
        }
        if let invoiceDateString: String = json["invoice_date"] as? String,
            let invoiceDate: Date = Bill.dateFormatter.date(from: invoiceDateString) {
            self.invoiceDate = invoiceDate
        }
        if let dueDateString: String = json["due_date"] as? String,
            let dueDate: Date = Bill.dateFormatter.date(from: dueDateString) {
            self.dueDate = dueDate
        }
        self.currency = json["currency"] as? String ?? "RM"
        if let previousBalanceString = json["previous_balance"] as? String {
            self.previousBalance = Double(previousBalanceString)
        }
        if let lastPaymentString = json["last_payment"] as? String {
            self.lastPayment = Double(lastPaymentString)
        }
        if let adjustmentString = json["adjustments"] as? String {
            self.adjustments = Double(adjustmentString)
        }
        if let overdueBalanceString = json["overdue_balance"] as? String {
            self.overdueBalance = Double(overdueBalanceString)
        }
        if let currentChargesString = json["current_charges"] as? String {
            self.currentCharges = Double(currentChargesString)
        } else if let currentChargesString = json["amount"] as? String {
            self.currentCharges = Double(currentChargesString)
        }

        if let totalAmountDueString = json["total_amount_due"] as? String {
            self.totalAmountDue = Double(totalAmountDueString)
        }
        if let totalOutstandingString = json["total_outstanding"] as? String {
             self.totalOutstanding = Double(totalOutstandingString)
        }

        if let lastUpdatedString: String = json["last_updated"] as? String,
            let lastUpdated: Date = Bill.dateFormatter.date(from: lastUpdatedString) {
            self.lastUpdated = lastUpdated
        }
        self.canMakePayment = json["can_make_payment"] as? Bool
        self.pdf = json["pdf_url"] as? String
        self.accountNo = json["account_no"] as? String
        if let paymentTypesString = json["payment_types"] as? String {
            self.paymentTypes = paymentTypesString.components(separatedBy: ",")
        }
    }

}

public extension Bill {
    // account: Bill belongs-to Account
    var account: Account? {
        if let accountAccountNo = self.accountNo {
            return AccountDataController.shared.getAccount(by: accountAccountNo)
        }
        return nil
    }

    // paymentTypes: Bill belongs-to-many PaymentType

}
