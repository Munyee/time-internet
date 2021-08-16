//
//  ActivityTableViewCell.swift
//  TimeSelfCare
//
//  Created by Loka on 14/05/2018.
//  Copyright © 2018 Apptivity Lab. All rights reserved.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var unreadStatusImageView: UIImageView!
    @IBOutlet private weak var actionableIndicatorImageView: UIImageView!
    @IBOutlet private weak var line2Label: UILabel!
    @IBOutlet var bottomLineLabel: UILabel!
    
    func configure(with activity: Activity) {
        self.titleLabel.text = activity.type == .launchExternalApp ? String(htmlEncodedString: activity.title ?? "") : String(htmlEncodedString: activity.type.rawValue ?? "")
        self.detailLabel.text = String(htmlEncodedString: activity.line1 ?? "")
        self.line2Label.text = String(htmlEncodedString: activity.line2 ?? "")
        self.statusLabel.text = activity.status
        self.statusLabel.isHidden = self.statusLabel.text?.isEmpty ?? true
       // self.statusLabel.borderColor = Activity.Status(rawValue: activity.status?.lowercased() ?? "")?.color ?? Activity.Status.unknown.color
        self.statusLabel.backgroundColor = Activity.Status(rawValue: activity.status?.lowercased() ?? "")?.color ?? Activity.Status.unknown.color
        self.unreadStatusImageView.image = activity.isNew ? #imageLiteral(resourceName: "ic_new_notifications") : nil
        self.actionableIndicatorImageView.isHidden = !activity.isActionable
    }

    func markAsRead() {
        self.unreadStatusImageView.image = nil
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.text = String()
        self.detailLabel.text = String()
        self.unreadStatusImageView.image = nil
    }
}

extension Activity.Status {
    var color: UIColor {
        switch self {
        case .open:
            return .positive
        case .available, .unpaid:
            return .primary
        case .redeemed, .fullyGrabbed:
            return .turquoise
        default:
            return .grey2
        }
    }
}
