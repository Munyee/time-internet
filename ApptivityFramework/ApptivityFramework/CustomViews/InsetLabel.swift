//
//  InsetLabel.swift
//  Wanderclass
//
//  Created by Loka on 30/05/2017.
//  Copyright © 2017 AppLab. All rights reserved.
//

import UIKit

@IBDesignable
public class InsetLabel: UILabel {
    @IBInspectable public var topInset: CGFloat = 0
    @IBInspectable public var bottomInset: CGFloat = 0
    @IBInspectable public var leftInset: CGFloat = 10
    @IBInspectable public var rightInset: CGFloat = 10

    override public func drawText(in rect: CGRect) {
        let insets: UIEdgeInsets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }

    override public var intrinsicContentSize: CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        intrinsicSuperViewContentSize.height += topInset + bottomInset
        intrinsicSuperViewContentSize.width += leftInset + rightInset
        return intrinsicSuperViewContentSize
    }
}
