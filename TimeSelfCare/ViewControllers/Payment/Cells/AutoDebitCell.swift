//
//  AutoDebitCell.swift
//  TimeSelfCare
//
//  Created by Loka on 04/12/2017.
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import UIKit

internal protocol AutoDebitCellDelegate: class {
    func modify(cell: AutoDebitCell, creditCard: CreditCard)
}

internal class AutoDebitCell: UITableViewCell {

    weak var delegate: AutoDebitCellDelegate?

    // swiftlint:disable implicitly_unwrapped_optional
    var creditCard: CreditCard!

    @IBOutlet private weak var debitCardImageView: UIImageView!
    @IBOutlet private weak var planNameLabel: UILabel!
    @IBOutlet private weak var cardNumberLabel: UILabel!
    // swiftlint:enable implicitly_unwrapped_optional

    func configure(with creditCard: CreditCard) {
        self.creditCard = creditCard
        switch creditCard.ccType ?? .unknown {
        case CreditCard.CcType.mastercard:
            self.debitCardImageView.image = #imageLiteral(resourceName: "ic_debit_mastercard")
        case CreditCard.CcType.visa:
            self.debitCardImageView.image = #imageLiteral(resourceName: "ic_debit_visa")
        case CreditCard.CcType.amex:
            self.debitCardImageView.image = #imageLiteral(resourceName: "ic_debit_amex")
        default:
            self.debitCardImageView.image = #imageLiteral(resourceName: "ic_debit_card_default_big")
        }

        let creditCardEndingNumber = creditCard.ccNo.substring(from: creditCard.ccNo.isEmpty ? 0 : creditCard.ccNo.count - 4)
        self.cardNumberLabel.text = String(format: NSLocalizedString("Card ending %@", comment: ""), creditCardEndingNumber)
        self.planNameLabel.text = "\(creditCard.account?.displayAccountNo ?? "") (\(creditCard.account?.title ?? ""))"
    }

    @IBAction func modifyCreditCard(_ sender: Any) {
        delegate?.modify(cell: self, creditCard: self.creditCard)
    }

}
