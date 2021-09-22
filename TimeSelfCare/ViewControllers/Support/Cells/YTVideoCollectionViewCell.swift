//
//  YTVideoCollectionViewCell.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 06/08/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import UIKit

class YTVideoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var ytView: YTPlayerView!
    @IBOutlet weak var ytViewHeight: NSLayoutConstraint!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var duration: UILabel!
    
    var videoId = ""
}
