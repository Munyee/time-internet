//
//  ServiceSideBarCell.swift
//  TimeSelfCare
//
//  Created by Loka on 11/06/2018.
//  Copyright © 2018 Apptivity Lab. All rights reserved.
//

import UIKit

internal class ServiceSidebarCell: UITableViewCell {
    enum ServiceType {
        case support
        case hookup
        case reward
        case livechat

        var image: UIImage? {
            switch self {
            case .support:
                return #imageLiteral(resourceName: "ic_support")
            case .hookup:
                return #imageLiteral(resourceName: "ic_huae")
            case .reward:
                return #imageLiteral(resourceName: "ic_sidebar_rewards")
            case .livechat:
                return #imageLiteral(resourceName: "ic_chat_bubble_black")
            }
        }

        var name: String? {
            switch self {
            case .support:
                return NSLocalizedString("Support", comment: "")
            case .reward:
                return NSLocalizedString("Reward", comment: "")
            case .hookup:
                return NSLocalizedString("Hook Up & Earn", comment: "")
            case .livechat:
                return NSLocalizedString("Live Chat", comment: "")
            }
        }
    }

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!

    func configure(with type: ServiceType) {
        self.iconImageView.image = type.image
        self.nameLabel.text = type.name
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.iconImageView.image = nil
        self.nameLabel.text = String()
    }
}
