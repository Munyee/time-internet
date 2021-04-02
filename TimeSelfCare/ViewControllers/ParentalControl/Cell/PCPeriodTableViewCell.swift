//
//  PCPeriodTableViewCell.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 23/02/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import UIKit

class PCPeriodTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var radioImg: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setChosen(chosen: Bool) {
        if chosen {
            radioImg.image = UIImage(#imageLiteral(resourceName: "ic_tick"))
        } else {
            radioImg.image = UIImage(#imageLiteral(resourceName: "ic_unselect_radio"))
        }
    }

}
