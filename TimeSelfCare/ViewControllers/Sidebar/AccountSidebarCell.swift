//
//  SidebarCell.swift
//  TimeSelfCare
//
//  Created by Loka on 10/11/2017.
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import UIKit

internal class AccountSidebarCell: UITableViewCell {

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!

    func configureCell(with account: Account) {
        self.titleLabel.text = account.accountNo
        self.descriptionLabel.text = account.title

        self.titleLabel.textColor = account.isSelected ? .primary : .black
        self.descriptionLabel.textColor = account.isSelected ? .primary : .black
        self.iconImageView.image = account.isSelected ? #imageLiteral(resourceName: "ic_radio_selected") : #imageLiteral(resourceName: "ic_radio_unselect")
    }
}

extension Account {
    var isSelected: Bool {
        return self.accountNo == AccountController.shared.selectedAccount?.accountNo
    }
}
