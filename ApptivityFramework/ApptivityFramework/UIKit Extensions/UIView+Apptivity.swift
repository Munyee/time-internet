//
//  UIView+Apptivity.swift
//  ApptivityFramework
//
//  Created by AppLab on 13/12/2016.
//  Copyright © 2016 Apptivity Lab. All rights reserved.
//

import UIKit

// MARK: Gradient Layer
public enum GradientDirection {
    case horizontal
    case vertical
    case diagonalLeft
    case diagonalRight
    case custom(startPoint: CGPoint, endPoint: CGPoint)
    
    var startPoint: CGPoint {
        let defaultPoint: CGPoint = CGPoint(x: 0, y: 0.5)
        switch self {

        case .horizontal:
            return defaultPoint
        case .vertical:
            return CGPoint(x: 0.5, y: 0)
        case .diagonalLeft:
            return CGPoint(x: 0, y: 0)
        case .diagonalRight:
            return CGPoint(x: 1, y: 0)
        case .custom(let startPoint, _):
            if (startPoint.x < 0.0 || startPoint.x > 1.0) || (startPoint.y < 0.0 || startPoint.y > 1.0) {
                return defaultPoint
            }
            
            return startPoint
        }
    }
    
    var endPoint: CGPoint {
        let defaultPoint: CGPoint = CGPoint(x: 1, y: 0.5)
        switch self {

        case .horizontal:
            return defaultPoint
        case .vertical:
            return CGPoint(x: 0.5, y: 1)
        case .diagonalLeft:
            return CGPoint(x: 1, y: 1)
        case .diagonalRight:
            return CGPoint(x: 0, y: 1)
        case .custom(_, let endPoint):
            if (endPoint.x < 0.0 || endPoint.x > 1.0) || (endPoint.y < 0.0 || endPoint.y > 1.0) {
                return defaultPoint
            }
            
            return endPoint
        }
    }
}

public extension UIView {
    public class func from<T>(nibName: String, bundle: Bundle?) -> T? {
        var instance: T? = nil
        for object in UINib(nibName: nibName, bundle: bundle).instantiate(withOwner: nil, options: nil) {
            if object is T {
                instance = object as? T
                break
            }
        }
        
        return instance
    }

    func applyGradient(colors: [UIColor], direction: GradientDirection? = GradientDirection.horizontal, locations: [NSNumber]? = nil, name: String? = nil) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colors.map { $0.cgColor }

        if let direction: GradientDirection = direction {
            gradient.startPoint = direction.startPoint
            gradient.endPoint = direction.endPoint
        }

        gradient.locations = locations
        gradient.name = name
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }

    func applyRoundedCorner(cornerRadius: CGFloat) {
        if cornerRadius > 0 {
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
        }
    }

    func applyShadow(color: UIColor, offset: CGSize, opacity: Float? = nil, radius: CGFloat? = nil) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity ?? 0.32
        self.layer.shadowRadius = radius ?? 0
        self.layer.masksToBounds = false
    }
}
