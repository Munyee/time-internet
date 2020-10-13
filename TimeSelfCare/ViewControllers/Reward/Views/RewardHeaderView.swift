//
//  RewardHeaderView.swift
//  TimeSelfCare
//
//  Created by Loka on 03/07/2019.
//  Copyright © 2019 Apptivity Lab. All rights reserved.
//

import UIKit

protocol RewardHeaderViewDelegate: class {
    func toggleSection(_ header: RewardHeaderView, section: Reward.Section)
}

class RewardHeaderView: UITableViewHeaderFooterView {
    private var section: Reward.Section = .howToRedeem
    weak var delegate: RewardHeaderViewDelegate?

    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var arrowImageView: UIImageView!

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapHeader(_:)))
        addGestureRecognizer(tapGestureRecognizer)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapHeader(_:)))
        addGestureRecognizer(tapGestureRecognizer)
    }

    func configure(with rewardSection: Reward.Section, isCollapsed: Bool) {
        self.logoImageView.image = rewardSection.icon
        self.section = rewardSection
        self.titleLabel.text = rewardSection.title

        self.titleLabel.font = isCollapsed
            ? UIFont.preferredFont(forTextStyle: .body)
            : UIFont.preferredFont(forTextStyle: .body).bold()

        self.arrowImageView.image = isCollapsed ? #imageLiteral(resourceName: "ic_arrow_down.png") : #imageLiteral(resourceName: "ic_arrow.png")
    }

    func setCollapsed(_ isCollapsed: Bool) {
        self.titleLabel.font = isCollapsed
            ? UIFont.preferredFont(forTextStyle: .body)
            : UIFont.preferredFont(forTextStyle: .body).bold()
        self.arrowImageView.rotate(isCollapsed ? .pi / 2 : .pi * 1.5)
    }

    @objc
    func tapHeader(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let header = gestureRecognizer.view as? RewardHeaderView else {
            return
        }

        delegate?.toggleSection(self, section: self.section)
    }

}

extension UIView {
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")

        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false

        animation.fillMode = CAMediaTimingFillMode.forwards

        self.layer.add(animation, forKey: nil)
    }
}

extension UIFont {
    func withTraits(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        if let descriptor = fontDescriptor.withSymbolicTraits(traits) {
            return UIFont(descriptor: descriptor, size: 0)
        }
        return self
    }

    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }

    func italic() -> UIFont {
        return withTraits(traits: .traitItalic)
    }
}
