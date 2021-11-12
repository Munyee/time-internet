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

    @IBOutlet private weak var itemLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UITextView!

    func configure(with description: String, icon: UIImage?, index: Int?) {
        self.iconView.image = icon
        self.iconView.isHidden = icon == nil
        self.itemLabel.isHidden = icon != nil

        if let index = index {
            self.itemLabel.text = "\(index)."
        } else {
            self.itemLabel.text = "•"
        }
        
        self.descriptionLabel.text = String(htmlEncodedString: description)
        self.descriptionLabel.dataDetectorTypes = .all
        self.descriptionLabel.isScrollEnabled = false
        self.descriptionLabel.textColor = .darkGray

        do {
            let attrStr = try NSMutableAttributedString(data: description.data(using: String.Encoding.unicode, allowLossyConversion: true)!, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            self.descriptionLabel.attributedText = attrStr
            self.descriptionLabel.font =  UIFont(name: "DIN-Light", size: 16)
        } catch {
            print(error)
        }
        
        self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.descriptionLabel.isScrollEnabled = false
        self.descriptionLabel.textContainerInset = .zero

    }
}
