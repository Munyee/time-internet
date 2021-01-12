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
    @IBOutlet private var rowDividerLabel: UILabel!
    
    func configure(with ticket: Ticket) {
        self.dateTimeLabel.text = ticket.datetime
        self.titleLabel.text = ticket.subject
        self.detailLabel.text = ticket.category
        self.statusLabel.text = ticket.statusString
        self.statusLabel.isHidden = ticket.statusString?.isEmpty ?? true
        
        if ["open"].contains(ticket.statusString?.lowercased()) {
            self.statusLabel.backgroundColor = .positive
        } else if ["closed"].contains(ticket.statusString?.lowercased()) {
            self.statusLabel.backgroundColor = .grey2
        } else {
            self.statusLabel.backgroundColor = .primary
        }
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
