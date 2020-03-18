//
//  ImagePickerAssetCell.swift
//  Wanderclass
//
//  Created by AppLab on 18/11/2016.
//  Copyright © 2016 AppLab. All rights reserved.
//

import UIKit
import Photos

public class ImagePickerAssetCell: UICollectionViewCell {

    public override var isSelected: Bool {
        didSet {
            self.checkmarkImageView.isHidden = !isSelected
        }
    }

    private(set) var representedAssetIdentifier: String!
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var checkmarkImageView: UIImageView!

    public func setImage(_ image: UIImage?, forAssetIdentifier assetIdentifier: String) {
        self.thumbnailImageView.image = image
        self.representedAssetIdentifier = assetIdentifier
        self.checkmarkImageView.isHidden = !self.isSelected
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        self.thumbnailImageView.image = nil
        self.representedAssetIdentifier = nil
        self.checkmarkImageView.isHidden = true
    }
}
