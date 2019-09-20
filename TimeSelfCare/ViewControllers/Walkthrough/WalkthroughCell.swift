//
//  WalkthroughCell.swift
//  TimeSelfCare
//
//  Created by Loka on 09/11/2017.
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import UIKit

internal class WalkthroughCell: UICollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView!

    public func configureCell(with image: UIImage) {
        imageView.image = image
    }
}
