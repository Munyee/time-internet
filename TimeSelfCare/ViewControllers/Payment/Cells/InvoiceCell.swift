//
//  InvoiceCell.swift
//  TimeSelfCare
//
//  Created by Loka on 04/12/2017.
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import UIKit

internal class InvoiceCell: UITableViewCell {

    @IBOutlet private weak var dayLabel: UILabel!
    @IBOutlet private weak var monthLabel: UILabel!
    @IBOutlet private weak var invoiceLabel: UILabel!
    @IBOutlet private weak var amountLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!

    func configureCell(with bill: Bill) {
        self.invoiceLabel.text = bill.invoiceNo
        self.amountLabel.text = bill.currentCharges?.currencyString(withSymbol: bill.currency ?? "RM", minimumFractionDigits: 2, maximumFractionDigits: 2)
        self.statusLabel.text = bill.invoiceStatus == .paid ? NSLocalizedString("PAID", comment: "") : NSLocalizedString("PAY NOW", comment: "")
        self.statusLabel.backgroundColor = bill.invoiceStatus == .paid ? .grey2 : .positive
        self.dayLabel.text = bill.invoiceDate?.string(usingFormat: "d")
        self.monthLabel.text = bill.invoiceDate?.string(usingFormat: "MMM").uppercased()
    }
}
