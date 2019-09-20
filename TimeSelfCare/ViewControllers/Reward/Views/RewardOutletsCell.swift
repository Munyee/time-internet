//
//  RewardOutletsCell.swift
//  TimeSelfCare
//
//  Created by Loka on 20/08/2019.
//  Copyright © 2019 Apptivity Lab. All rights reserved.
//

import UIKit
import TimeSelfCareData

class RewardOutletsCell: UITableViewCell {
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var regionLabel: UILabel!

    private var outletStackViews: [UIView] = []

    func configure(with region: String, outlets: [String], icon: UIImage) {
        self.outletStackViews.forEach {
            self.stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        self.outletStackViews = []

        self.regionLabel.text = region
        self.regionLabel.isHidden = region == Reward.OutletGroup.ungrouped.rawValue

        outlets.forEach { outlet in
            let horizontalStackView = UIStackView()
            horizontalStackView.alignment = .center
            horizontalStackView.distribution = .fill
            horizontalStackView.spacing = 4

            let iconImageView = UIImageView(image: icon)
            iconImageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                NSLayoutConstraint(item: iconImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20),
                NSLayoutConstraint(item: iconImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20)
            ])

            let outletLabel = UILabel()
            outletLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
            outletLabel.numberOfLines = 0
            outletLabel.text = outlet
            outletLabel.textColor = .darkGrey

            horizontalStackView.addArrangedSubview(iconImageView)
            horizontalStackView.addArrangedSubview(outletLabel)

            self.outletStackViews.append(horizontalStackView)

            self.stackView.addArrangedSubview(horizontalStackView)
        }
    }
}
