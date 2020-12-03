//
//  InvoiceCell.swift
//  TimeSelfCare
//
//  Created by Loka on 04/12/2017.
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import UIKit

internal class InvoiceCell: UITableViewCell {
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var invoiceLabel: UILabel!
    @IBOutlet private weak var amountLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var imgView: UIImageView?
    
    func configureCell(with bill: Bill) {
        self.invoiceLabel.text = bill.invoiceNo
        self.amountLabel.text = bill.currentCharges?.currencyString(withSymbol: bill.currency ?? "RM", minimumFractionDigits: 2, maximumFractionDigits: 2)
        self.statusLabel.text = bill.invoiceStatus == .paid ? NSLocalizedString("PAID", comment: "") : NSLocalizedString("PAY NOW", comment: "")
        self.statusLabel.backgroundColor = bill.invoiceStatus == .paid ? .positive : .primary
        self.dateLabel.text = bill.invoiceDate?.string(usingFormat: "dd/MM/yyyy")
    }
}
