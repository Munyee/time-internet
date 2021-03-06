//
//  AddOnCell.swift
//  TimeSelfCare
//
//  Created by Loka on 28/11/2017.
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import UIKit

internal class AddOnCell: UITableViewCell {

    @IBOutlet private weak var productLabel: UILabel!
    @IBOutlet private weak var modelLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private var rowDividerLabel: UILabel!
    
    func configure(with addOn: AddOn) {
        self.productLabel.text = addOn.item
        self.modelLabel.text = addOn.model
        if let isUnderWarranty = addOn.isUnderWarranty {
            self.statusLabel.isHidden = false
            self.statusLabel.text = isUnderWarranty ? NSLocalizedString("UNDER WARRANTY", comment: "") : NSLocalizedString("OUT OF WARRANTY", comment: "")
            self.statusLabel.backgroundColor = isUnderWarranty ? .positive  : .grey2
        } else {
            self.statusLabel.isHidden = true
        }
    }
    
    func displayRowUnderline(with index:Int, arrayList:Array<Any>)  {
        if index == arrayList.count - 1 {
            self.rowDividerLabel.backgroundColor = .white
        } else {
            self.rowDividerLabel.backgroundColor = .lightGray
        }
    }
}
