//
//  TutorialContentCell.swift
//  TutorialContentCell
//
//  Created by Li Theen Kok on 26/05/2016.
//  Copyright © 2016 Apptivity Lab. All rights reserved.
//

import UIKit

open class TutorialContentCell: UICollectionViewCell {

    open var content: TutorialContent! {
        didSet {
            self.titleLabel.text = self.content.title
            self.bodyLabel.text = self.content.body
            self.deviceImageView.image = self.content.screenshotImage
            self.popupImageView.image = self.content.popupImage

            self.popupOrigin = self.content.popupOrigin
            self.popupTargetPosition = self.content.popupTargetPosition

            self.resetPopup()
        }
    }

    open var popupOrigin: CGPoint?
    open var popupTargetPosition: CGPoint?
    open var popupTargetSize: CGSize!

    @IBOutlet open weak var titleLabel: UILabel!
    @IBOutlet open weak var bodyLabel: UILabel!
    @IBOutlet open weak var deviceImageView: UIImageView!
    @IBOutlet open weak var popupImageView: UIImageView!

    @IBOutlet weak var popupLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var popupTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var popupWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var popupHeightConstraint: NSLayoutConstraint!

    override open func awakeFromNib() {
        super.awakeFromNib()
        self.resetPopup()

        self.popupImageView.backgroundColor = UIColor.clear
        self.deviceImageView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
    }

    open func resetPopup() {
        self.popupImageView.alpha = 0
        self.popupLeftConstraint.constant = 0
        self.popupTopConstraint.constant = 0
        self.popupWidthConstraint.constant = 0
        self.popupHeightConstraint.constant = 0
    }

    open func animatePopup() {

        if let popupOrigin: CGPoint = self.popupOrigin, let popupTargetPosition: CGPoint = self.popupTargetPosition {
            self.popupWidthConstraint.constant = 0.2 * self.popupTargetSize.width
            self.popupHeightConstraint.constant = 0.2 * self.popupTargetSize.height
            self.layoutIfNeeded()

            self.popupLeftConstraint.constant = (popupOrigin.x * self.deviceImageView.frame.size.width) - (self.popupWidthConstraint.constant / 2)
            self.popupTopConstraint.constant = popupOrigin.y * self.deviceImageView.frame.size.height - (self.popupHeightConstraint.constant / 2)
            self.layoutIfNeeded()

            self.popupImageView.alpha = 0

            UIView.animate(withDuration: 0.5, delay: 0.3, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                self.popupWidthConstraint.constant = self.popupTargetSize.width
                self.popupHeightConstraint.constant = self.popupTargetSize.height

                self.popupLeftConstraint.constant = (popupTargetPosition.x * self.deviceImageView.frame.size.width) - (self.popupTargetSize.width / 2)
                self.popupTopConstraint.constant = (popupTargetPosition.y * self.deviceImageView.frame.size.height)

                self.popupImageView.alpha = 1

                self.layoutIfNeeded()
                }, completion: { (completed: Bool) in

            })
        }
    }
}
