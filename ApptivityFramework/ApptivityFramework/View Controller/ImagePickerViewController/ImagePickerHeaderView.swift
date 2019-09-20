//
//  ImagePickerHeaderView.swift
//  Wanderclass
//
//  Created by AppLab on 18/11/2016.
//  Copyright © 2016 AppLab. All rights reserved.
//

import UIKit

public class ImagePickerHeaderView: UICollectionReusableView {

    @IBOutlet public weak var revealButton: UIButton!
    @IBOutlet public weak var cameraButton: UIButton!
    @IBOutlet public weak var libraryButton: UIButton!
    @IBOutlet public weak var cameraButtonView: UIView!
    @IBOutlet public weak var libraryButtonView: UIView!

    public func setButtonsHidden(_ hidden: Bool) {
        self.cameraButton.superview!.isHidden = hidden
        self.libraryButton.superview!.isHidden = hidden
    }
}
