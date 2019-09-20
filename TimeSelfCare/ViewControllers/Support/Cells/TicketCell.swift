//
//  TicketCell.swift
//  TimeSelfCare
//
//  Created by Loka on 18/06/2018.
//  Copyright © 2018 Apptivity Lab. All rights reserved.
//

import UIKit

class TicketCell: UITableViewCell {
    @IBOutlet private weak var dateTimeLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!

    func configure(with ticket: Ticket) {
        self.dateTimeLabel.text = ticket.displayDateTime
        self.titleLabel.text = ticket.subject
        self.detailLabel.text = ticket.detail
        self.statusLabel.text = ticket.statusString
        self.statusLabel.isHidden = ticket.statusString?.isEmpty ?? true
        self.statusLabel.backgroundColor = ["open"].contains(ticket.statusString?.lowercased()) ? .positive : .grey2
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.statusLabel.isHidden = false
        self.dateTimeLabel.text = String()
        self.titleLabel.text = String()
        self.detailLabel.text = String()
        self.statusLabel.text = String()
        self.statusLabel.backgroundColor = .darkGrey
    }
}
