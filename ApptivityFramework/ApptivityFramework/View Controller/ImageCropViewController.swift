//
//  APTImageCropViewController.swift
//  APTImageCropViewController
//
//  Created by Li Theen Kok on 21/01/2016.
//  Copyright © 2016 Apptivity Lab. All rights reserved.
//

import UIKit

public protocol ImageCropDelegate: class {
    func imageCropViewController(_ imageCropViewController: ImageCropViewController, didChangeZoomScale zoomScale: CGFloat, resultingInResolution imageResolution: CGSize)
}

open class ImageCropViewController: UIViewController {

    open var image: UIImage! {
        didSet {
            if self.isViewLoaded {
                self.updateImageView()
            }
        }
    }

    open weak var delegate: ImageCropDelegate?
    open var targetImageSize: CGSize = CGSize(width: 500, height: 500) {
        didSet {
            if self.isViewLoaded {
                self.updateCropTargetView()
            }
        }
    }
    open var cropTargetBorderWidth: CGFloat = 1
    open var cropTargetBorderColor: UIColor? = UIColor.white
    open var maskColor: UIColor = UIColor.black
    open var maskAlpha: CGFloat = 0.6

    @IBOutlet fileprivate weak var scrollView: UIScrollView!
    @IBOutlet fileprivate weak var maskView: UIView!
    @IBOutlet fileprivate weak var cropTargetView: UIView!
    @IBOutlet fileprivate weak var cropTargetWidthConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var cropTargetHeightConstraint: NSLayoutConstraint!

    fileprivate weak var imageView: UIImageView!

    public convenience init(image: UIImage!, cropTargetBorderWidth: CGFloat = 1, cropTargetBorderColor: UIColor = UIColor.white, maskColor: UIColor = UIColor.black, maskAlpha: CGFloat = 0.6) {
        self.init()
        self.image = image

        self.cropTargetBorderWidth = cropTargetBorderWidth
        self.cropTargetBorderColor = cropTargetBorderColor
        self.maskColor = maskColor
        self.maskAlpha = maskAlpha
    }

    open override func loadView() {
        let rootView: UIView = UIView(frame: UIScreen.main.bounds)
        rootView.backgroundColor = UIColor.white

        let scrollView: UIScrollView = UIScrollView(frame: rootView.bounds)
        rootView.addSubview(scrollView)
        self.scrollView = scrollView

        // scrollView: Pin to sides
        rootView.addConstraints([
            NSLayoutConstraint(item: rootView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: scrollView, attribute: NSLayoutAttribute.left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: rootView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: scrollView, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: rootView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: scrollView, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: rootView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: scrollView, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0)
            ])

        let maskView: UIView = UIView(frame: rootView.bounds)
        rootView.addSubview(maskView)
        self.maskView = maskView

        // maskView: Pin to sides
        rootView.addConstraints([
            NSLayoutConstraint(item: maskView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: rootView, attribute: NSLayoutAttribute.left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: maskView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: rootView, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: maskView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: rootView, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: maskView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: rootView, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0)
            ])

        let cropTargetView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        rootView.addSubview(cropTargetView)
        self.cropTargetView = cropTargetView

        let cropTargetWidthConstraint: NSLayoutConstraint = NSLayoutConstraint(item: cropTargetView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: cropTargetView.frame.size.width)
        let cropTargetHeightConstraint: NSLayoutConstraint = NSLayoutConstraint(item: cropTargetView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: cropTargetView.frame.size.height)
        // cropTargetView: Fixed width, height constraints
        cropTargetView.addConstraints([cropTargetWidthConstraint, cropTargetHeightConstraint])
        self.cropTargetWidthConstraint = cropTargetWidthConstraint
        self.cropTargetHeightConstraint = cropTargetHeightConstraint

        // cropTargetView: CenterX, CenterY to self.view
        rootView.addConstraints([
            NSLayoutConstraint(item: cropTargetView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: rootView, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: cropTargetView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: rootView, attribute: NSLayoutAttribute.centerY, multiplier: 1.0, constant: 0)
            ])

        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.maskView.translatesAutoresizingMaskIntoConstraints = false
        self.cropTargetView.translatesAutoresizingMaskIntoConstraints = false

        self.view = rootView
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.delegate = self
    }

    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        self.updateCropTargetView()

        self.maskView.backgroundColor = self.maskColor
        self.maskView.isUserInteractionEnabled = false
        self.maskView.alpha = self.maskAlpha

        self.cropTargetView.backgroundColor = UIColor.clear
        self.cropTargetView.layer.borderWidth = self.cropTargetBorderWidth
        self.cropTargetView.layer.borderColor = self.cropTargetBorderColor?.cgColor
        self.cropTargetView.isUserInteractionEnabled = false

        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
    }

    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.updateImageView()
        self.updateMaskView()
    }

    open override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    fileprivate func updateCropTargetView() {
        let widthRatio: CGFloat = self.view.frame.size.width / (self.targetImageSize.width - (2 * self.cropTargetBorderWidth))
        let heightRatio: CGFloat = self.view.frame.size.height / (self.targetImageSize.height - (2 * self.cropTargetBorderWidth))
        let appliedRatio: CGFloat = min(widthRatio, heightRatio)

        self.cropTargetWidthConstraint.constant = appliedRatio * (self.targetImageSize.width - (2 * self.cropTargetBorderWidth))
        self.cropTargetHeightConstraint.constant = appliedRatio * (self.targetImageSize.height - (2 * self.cropTargetBorderWidth))
    }

    fileprivate func updateMaskView() {
        let path: UIBezierPath = UIBezierPath(rect: self.view.bounds)
        let cropPath: UIBezierPath = UIBezierPath(rect: self.cropTargetView.frame)
        path.append(cropPath)

        let maskLayer: CAShapeLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        maskLayer.fillRule = kCAFillRuleEvenOdd
        maskLayer.fillColor = UIColor.white.cgColor

        self.maskView.layer.mask = maskLayer
    }

    fileprivate func updateImageView() {
        let widthRatio: CGFloat = self.cropTargetView.frame.size.width / self.image.size.width
        let heightRatio: CGFloat = self.cropTargetView.frame.size.height / self.image.size.height
        let appliedRatio: CGFloat = max(widthRatio, heightRatio)

        if self.imageView == nil {
            let imageView: UIImageView = UIImageView()
            self.scrollView.addSubview(imageView)
            self.imageView = imageView
        }

        self.imageView.frame = CGRect(x: self.cropTargetView.frame.origin.x, y: self.cropTargetView.frame.origin.y, width: appliedRatio * self.image.size.width, height: appliedRatio * self.image.size.height)
        self.imageView.image = self.image

        self.scrollView.contentSize = CGSize(width: self.imageView.frame.size.width + (2 * self.imageView.frame.origin.x), height: self.imageView.frame.size.height + (2 * self.imageView.frame.origin.y))
        self.scrollView.maximumZoomScale = min(self.image.size.width / self.cropTargetView.frame.size.width, self.image.size.height / self.cropTargetView.frame.size.height)

        self.scrollView.setContentOffset(CGPoint(x: (self.scrollView.contentSize.width - self.view.frame.size.width) / 2, y: (self.scrollView.contentSize.height - self.view.frame.size.height) / 2), animated: false)
    }

    open func cropImage() -> UIImage! {
        let widthRatio: CGFloat = self.image.size.width / self.imageView.frame.size.width
        let heightRatio: CGFloat = self.image.size.height / self.imageView.frame.size.height
        let appliedRatio: CGFloat = min(widthRatio, heightRatio)

        let targetCropArea: CGRect = CGRect(
            x: appliedRatio * self.scrollView.contentOffset.x,
            y: appliedRatio * self.scrollView.contentOffset.y,
            width: (self.cropTargetView.frame.size.width / self.imageView.frame.size.width) * self.image.size.width,
            height: (self.cropTargetView.frame.size.height / self.imageView.frame.size.height) * self.image.size.height
        )

        let croppedImage: UIImage = UIImage(cgImage: self.image.cgImage!.cropping(to: targetCropArea)!)

        UIGraphicsBeginImageContextWithOptions(self.targetImageSize, true, 1)
        let context: CGContext! = UIGraphicsGetCurrentContext()
        context.scaleBy(x: 1, y: -1)
        context.translateBy(x: 0, y: -self.targetImageSize.height)
        context.saveGState()

        context.draw(croppedImage.cgImage!, in: CGRect(x: 0, y: 0, width: self.targetImageSize.width, height: self.targetImageSize.height))
        let result: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        return result
    }
}

// MARK: - UIScrollViewDelegate
extension ImageCropViewController: UIScrollViewDelegate {

    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }

    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.scrollView.contentSize = CGSize(width: self.imageView.frame.size.width + (2 * self.imageView.frame.origin.x), height: self.imageView.frame.size.height + (2 * self.imageView.frame.origin.y))

        let zoomScale: CGFloat = scrollView.zoomScale
        let actualResolution: CGSize = CGSize(width: (1 / zoomScale) * self.image.size.width, height: (1 / zoomScale) * self.image.size.height)
        self.delegate?.imageCropViewController(self, didChangeZoomScale: zoomScale, resultingInResolution: actualResolution)
    }
}
