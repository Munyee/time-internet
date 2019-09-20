//
//  RewardCell.swift
//  TimeSelfCare
//
//  Created by Loka on 03/07/2019.
//  Copyright © 2019 Apptivity Lab. All rights reserved.
//

import UIKit

class RewardCell: UITableViewCell {
    @IBOutlet private weak var iconView: UIImageView!

    @IBOutlet private weak var descriptionLabel: UILabel!

    func configure(with description: String, icon: UIImage?, index: Int?) {
        self.iconView.image = icon
        self.iconView.isHidden = icon == nil
        self.descriptionLabel.text = icon != nil
            ? description.htmlAttributedString?.string
            : "\(index != nil ? "\(index!). " : "•  ") \(description.htmlAttributedString?.string ?? "")" 
    }
}
