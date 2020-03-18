//
//  CentredImageButton.swift
//  TimeSelfCare
//
//  Created by Aarief on 02/11/2017.
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import UIKit

// https://stackoverflow.com/a/22621613

@IBDesignable
internal class CentredImageButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()

        guard
            let imageViewSize = self.imageView?.frame.size,
            let titleLabelSize = self.titleLabel?.frame.size else {
                return
        }

        let margin: CGFloat = 16.0
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.titleLabel?.minimumScaleFactor = 0.5

        let totalHeight = imageViewSize.height + titleLabelSize.height + margin

        self.imageEdgeInsets = UIEdgeInsets(
            top: -(totalHeight - imageViewSize.height),
            left: 0.0,
            bottom: 0.0,
            right: -titleLabelSize.width
        )

        self.titleEdgeInsets = UIEdgeInsets(
            top: 0.0,
            left: -imageViewSize.width,
            bottom: -(totalHeight - titleLabelSize.height),
            right: 0.0
        )

        self.contentEdgeInsets = UIEdgeInsets(
            top: 0.0,
            left: 0.0,
            bottom: titleLabelSize.height,
            right: 0.0
        )
    }

}
