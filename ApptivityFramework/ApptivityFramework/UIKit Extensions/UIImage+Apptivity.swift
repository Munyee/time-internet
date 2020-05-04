//
//  UIImage+Apptivity.swift
//  ApptivityFramework
//
//  Created by Li Theen Kok on 30/11/2016.
//  Copyright © 2016 Apptivity Lab. All rights reserved.
//

import UIKit
import CoreImage
import CoreGraphics

public extension UIImage {

    public func resizedTo(size: CGSize, interpolationQuality: CGInterpolationQuality) -> UIImage! {
        var drawTransposed: Bool = false

        switch self.imageOrientation {
        case UIImageOrientation.left, UIImageOrientation.leftMirrored, UIImageOrientation.right, UIImageOrientation.rightMirrored:
            drawTransposed = true

        default:
            drawTransposed = false
        }

        if let image = self.imageResizedTo(newSize: size, transform: self.transformForOrientation(orientation: self.imageOrientation, scaledToSize: size), drawTransposed: drawTransposed, interpolationQuality: interpolationQuality) {
            return image
        } else {
            return self
        }
    }

    public func resizedTo(maximumDimension: CGFloat) -> UIImage! {
        if self.size.width < maximumDimension && self.size.height < maximumDimension {
            return self
        }

        let scale: CGFloat = max(maximumDimension / self.size.width, maximumDimension / self.size.height)
        return self.scaledTo(scale: scale)
    }

    public func scaledTo(scale: CGFloat) -> UIImage! {
        return self.resizedTo(size: CGSize(width: scale * self.size.width, height: scale * self.size.height), interpolationQuality: CGInterpolationQuality.high)
    }

    private func transformForOrientation(orientation: UIImageOrientation, scaledToSize newSize: CGSize) -> CGAffineTransform {
        var transform: CGAffineTransform = CGAffineTransform.identity

        switch orientation {
        case UIImageOrientation.down, UIImageOrientation.downMirrored:
            transform = CGAffineTransform.identity.translatedBy(x: newSize.width, y: newSize.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
        case UIImageOrientation.left, UIImageOrientation.leftMirrored:
            transform = CGAffineTransform.identity.translatedBy(x: newSize.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi / 2))
        case UIImageOrientation.right, UIImageOrientation.rightMirrored:
            transform = CGAffineTransform.identity.translatedBy(x: 0, y: newSize.height)
            transform = transform.rotated(by: CGFloat(-Double.pi / 2))
        default:
            break
        }

        switch orientation {
        case UIImageOrientation.upMirrored, UIImageOrientation.downMirrored:
            transform = transform.translatedBy(x: newSize.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case UIImageOrientation.leftMirrored, UIImageOrientation.rightMirrored:
            transform = transform.translatedBy(x: newSize.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        default:
            break
        }

        return transform
    }

    private func imageResizedTo(newSize: CGSize, transform: CGAffineTransform, drawTransposed: Bool, interpolationQuality: CGInterpolationQuality) -> UIImage! {

        let newRect: CGRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height).integral
        let transposedRect = CGRect(x: 0, y: 0, width: newRect.size.height, height: newRect.size.width)

        guard let imageRef: CGImage! = self.cgImage else {
            return
        }

        // Build a context that's the same dimensions as the new size
        let bitmap: CGContext = CGContext(data: nil, width: Int(newRect.size.width), height: Int(newRect.size.height), bitsPerComponent: imageRef.bitsPerComponent, bytesPerRow: 0, space: imageRef.colorSpace ?? CGColorSpaceCreateDeviceRGB(), bitmapInfo: imageRef.bitmapInfo.rawValue)!

        // Rotate and/or flip the image if required by its orientation
        bitmap.concatenate(transform)

        // Set the quality level to use when rescaling
        bitmap.interpolationQuality = interpolationQuality

        // Draw into the context; this scales the image
        bitmap.draw(imageRef, in: drawTransposed ? transposedRect : newRect)

        // Get the resized image from the context and a UIImage
        let newImageRef: CGImage = bitmap.makeImage()!
        let newImage: UIImage! = UIImage(cgImage: newImageRef)

        return newImage;
    }
}


// MARK: - CIImage Extensions
public extension CIImage {

    public func UIImage(withScale scale: CGFloat, interpolationQuality: CGInterpolationQuality = CGInterpolationQuality.none) -> UIImage? {
        guard let CGImage = CIContext(options: nil).createCGImage(self, from: self.extent) else {
            return nil
        }

        UIGraphicsBeginImageContextWithOptions(CGSize(width: self.extent.size.width * scale, height: self.extent.size.height * scale), true, scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }

        context.interpolationQuality = interpolationQuality
        context.draw(CGImage, in: context.boundingBoxOfClipPath)

        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
}
