//
//  YTVideoCollectionViewCell.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 06/08/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import UIKit

class YTVideoView: UICollectionViewCell {
    @IBOutlet var mainContentView: UIView!
    @IBOutlet weak var ytViewHeight: NSLayoutConstraint!
    @IBOutlet weak var ytView: YTPlayerView!

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var type: UILabel!

    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    var videoId = ""
    var videoDuration = 0

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("YTVideoView", owner: self, options: nil)
        addSubview(mainContentView)
        mainContentView.frame = self.bounds
        mainContentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}
