//
//  GradientView.swift
//  ApptivityFramework
//
//  Created by Jason Khong on 26/06/2018.
//  Copyright © 2018 Apptivity Lab. All rights reserved.
//

import UIKit

@IBDesignable
public class GradientView: UIView {
    @IBInspectable var topColor: UIColor = UIColor.black.withAlphaComponent(0.0) {
        didSet {
            setNeedsLayout()
        }
    }
    @IBInspectable var bottomColor: UIColor = UIColor.black.withAlphaComponent(0.8) {
        didSet {
            setNeedsLayout()
        }
    }
    var gradientLayer: CAGradientLayer {
        return self.layer as! CAGradientLayer // swiftlint:disable:this force_cast
    }

    override public class var layerClass: Swift.AnyClass {
        return CAGradientLayer.self
    }

    override public func awakeFromNib() {
        super.awakeFromNib()

        self.gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        self.gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
    }
}
