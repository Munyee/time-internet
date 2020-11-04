//
//  UIView+.swift
//  TimeSelfCare
//
//  Created by Loka on 13/12/2017.
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import Foundation

extension UIView {
    func didTapped(text: NSAttributedString, inRange targetRange: NSRange, locationOfTouch: CGPoint) -> Bool {
        // Create instances of NSLayoutManager(c), NSTextContainer(V) and NSTextStorage(M)
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: text)

        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        // Configure textContainer
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = 0
        textContainer.size = self.bounds.size

        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouch.x, y: locationOfTouch.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }

    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

extension UITapGestureRecognizer {

    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        return label.didTapped(text: label.attributedText!, inRange: targetRange, locationOfTouch: self.location(in: label)) // swiftlint:disable:this force_unwrapping
    }
}
