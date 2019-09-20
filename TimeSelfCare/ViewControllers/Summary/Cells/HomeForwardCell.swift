//
//  HomeForwardCell.swift
//  TimeSelfCare
//
//  Created by Loka on 06/12/2017.
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import UIKit

class HomeForwardCell: UITableViewCell {
    @IBOutlet private weak var serviceIdLabel: UILabel!
    @IBOutlet private weak var planNameLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!

    func configure(with service: Service) {
        self.serviceIdLabel.text = service.serviceId
        self.planNameLabel.text = service.name

        self.priceLabel.text = service.pricePackage ?? "0.00"
    }
}
