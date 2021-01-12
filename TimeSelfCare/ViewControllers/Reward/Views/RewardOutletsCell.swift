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
            horizontalStackView.spacing = 8

            let iconImageView = UIImageView(image: icon)
            iconImageView.translatesAutoresizingMaskIntoConstraints = false
            iconImageView.contentMode = .scaleAspectFit
            NSLayoutConstraint.activate([
                NSLayoutConstraint(item: iconImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20),
                NSLayoutConstraint(item: iconImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20)
            ])
            
            let outletTextView = UITextView()
            outletTextView.font = UIFont.preferredFont(forTextStyle: .subheadline)
            outletTextView.dataDetectorTypes = .all
            outletTextView.text = String(htmlEncodedString: outlet)
            outletTextView.textColor = .darkGray
            
            do {
                let attrStr = try NSMutableAttributedString(data: outlet.data(using: String.Encoding.unicode, allowLossyConversion: true)!, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
                outletTextView.attributedText = attrStr
            } catch {
                print(error)
            }
            
            outletTextView.translatesAutoresizingMaskIntoConstraints = false
            outletTextView.isScrollEnabled = false

            horizontalStackView.addArrangedSubview(iconImageView)
            horizontalStackView.addArrangedSubview(outletTextView)

            self.outletStackViews.append(horizontalStackView)
            self.stackView.addArrangedSubview(horizontalStackView)
        }
    }
}
