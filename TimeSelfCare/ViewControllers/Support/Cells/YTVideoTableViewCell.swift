//
//  YTVideoTableViewCell.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 09/08/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import UIKit

class YTVideoTableViewCell: UITableViewCell {

    @IBOutlet weak var ytView: YTPlayerView!
    @IBOutlet weak var ytViewHeight: NSLayoutConstraint!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var duration: UILabel!
    
    var videoId = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
