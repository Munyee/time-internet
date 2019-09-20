//
//  FABCell.swift
//  TimeSelfCare
//
//  Created by Loka on 04/12/2017.
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import UIKit

class FABCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!

    func configureCell(title: String) {
        self.titleLabel.text = title
    }
}
