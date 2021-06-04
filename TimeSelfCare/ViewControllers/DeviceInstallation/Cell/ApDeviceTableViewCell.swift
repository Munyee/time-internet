 //
//  ApDeviceTableViewCell.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 08/04/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import UIKit

class ApDeviceTableViewCell: UITableViewCell {

    @IBOutlet weak var apImage: UIImageView!
    @IBOutlet weak var apName: UILabel!
    @IBOutlet weak var lanMac: UILabel!
    @IBOutlet weak var dateAndTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
