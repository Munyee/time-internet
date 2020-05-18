//
//  PhotoView.swift
//  ApptivityFramework
//
//  Created by Li Theen Kok on 5/27/15.
//  Copyright (c) 2015 Apptivity Lab. All rights reserved.
//

import UIKit

public protocol PhotoViewDelegate: class {
    func photoView(_ photoView: PhotoView, didReceiveTap gestureRecognizer: UIGestureRecognizer)
}

public class PhotoView: UIView, MediaView {

    public var reuseIdentifier: String!
    public var index: Int = -1
    public weak var delegate: PhotoViewDelegate?
    private var singleTapGestureRecognizer: UITapGestureRecognizer!
    private var doubleTapGestureRecognizer: UITapGestureRecognizer!

    weak var contentScrollView: UIScrollView!
    weak var labelBackgroundView: UIView!
    weak var labelBackgroundGradientLayer: CALayer!
    @IBOutlet public weak var captionLabel: UILabel!
    @IBOutlet public weak var photoImageView: UIImageView!

    public override required init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    public func prepareForReuse() {
        self.contentScrollView.setZoomScale(1, animated: true)
    }

    private func setup() {
        if self.contentScrollView == nil {
            let aContentScrollView: UIScrollView = UIScrollView(frame: self.frame)
            self.addSubview(aContentScrollView)
            self.contentScrollView = aContentScrollView
            self.contentScrollView.delegate = self

            self.contentScrollView.minimumZoomScale = 1
            self.contentScrollView.maximumZoomScale = 5
        }

        if self.photoImageView == nil {
            let aPhotoImageView: UIImageView = UIImageView(frame: self.frame)
            aPhotoImageView.contentMode = UIViewContentMode.scaleAspectFit
            self.contentScrollView.addSubview(aPhotoImageView)
            self.photoImageView = aPhotoImageView
        }

        if self.captionLabel == nil {
            let aCaptionLabel: UILabel = UILabel(frame: CGRect(x: 8, y: self.frame.size.height - 8, width: self.frame.size.width - 16, height: 0))
            aCaptionLabel.textColor = UIColor.white
            self.addSubview(aCaptionLabel)
            self.captionLabel = aCaptionLabel
        }

        if self.labelBackgroundView == nil {
            let aBackgroundView: UIView = UIView(frame: CGRect(x: 0, y: self.frame.size.height, width: self.frame.size.width, height: 0))
            aBackgroundView.isUserInteractionEnabled = false
            self.insertSubview(aBackgroundView, belowSubview: self.captionLabel)
            self.labelBackgroundView = aBackgroundView

            let gradientLayer: CAGradientLayer = CAGradientLayer()
            gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.65).cgColor]
            self.labelBackgroundView.layer.addSublayer(gradientLayer)
            self.labelBackgroundGradientLayer = gradientLayer
        }

        self.setupGestureRecognizers()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        self.contentScrollView.frame = self.bounds

        var imageViewFrame: CGRect = self.photoImageView.frame
        imageViewFrame.size = self.contentScrollView.frame.size
        if self.contentScrollView.contentSize.width > imageViewFrame.size.width {
            imageViewFrame.size = self.contentScrollView.contentSize
        }

        if let image: UIImage = self.photoImageView.image {
            let imageSize: CGSize = image.size
            let widthToHeightRatio: CGFloat = imageSize.width / imageSize.height

            imageViewFrame.size.height = imageViewFrame.size.width * (1 / widthToHeightRatio)
        }
        if self.contentScrollView.zoomScale == 1 {
            imageViewFrame.origin = CGPoint(x: (self.contentScrollView.frame.size.width - imageViewFrame.size.width) / 2, y: (self.contentScrollView.frame.size.height - imageViewFrame.size.height) / 2)
        }

        self.photoImageView.frame = imageViewFrame

        if let captionText: String = self.captionLabel.text {
            if !captionText.isEmpty {
                let textBoundingRect: CGRect = (captionText as NSString).boundingRect(with: CGSize(width: self.frame.size.width - 16, height: self.frame.size.height - 16), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: self.captionLabel.font], context: nil)
                self.captionLabel.frame = CGRect(x: 8, y: self.frame.size.height - 8 - ceil(textBoundingRect.size.height), width: self.frame.size.width - 16, height: ceil(textBoundingRect.size.height))

                self.labelBackgroundView.frame = CGRect(x: 0, y: self.frame.size.height - (self.captionLabel.frame.size.height + 32), width: self.frame.size.width, height: self.captionLabel.frame.size.height + 32)
                self.labelBackgroundGradientLayer.frame = self.labelBackgroundView.bounds
            }
        }
    }

    private func setupGestureRecognizers() {
        self.singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.receiveSingleTap(_:)))
        self.singleTapGestureRecognizer.numberOfTapsRequired = 1

        self.doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.zoom(_:)))
        self.doubleTapGestureRecognizer.numberOfTapsRequired = 2

        self.singleTapGestureRecognizer.require(toFail: self.doubleTapGestureRecognizer)
        self.addGestureRecognizer(self.singleTapGestureRecognizer)
        self.addGestureRecognizer(self.doubleTapGestureRecognizer)
    }

    @objc
    private func receiveSingleTap(_ sender: Any) {
        self.delegate?.photoView(self, didReceiveTap: self.singleTapGestureRecognizer)
    }

    @objc
    private func zoom(_ sender: Any) {
        guard
            let tapGesture = sender as? UITapGestureRecognizer,
            tapGesture.state == .ended,
            self.photoImageView.image != nil
        else {
            return
        }
        
        if self.contentScrollView.zoomScale > 1 {
            self.contentScrollView.setZoomScale(1.0, animated: true)
        } else {
            let tappedLocation: CGPoint = self.doubleTapGestureRecognizer.location(in: self.photoImageView)
            let maximumZoomScale: CGFloat = self.contentScrollView.maximumZoomScale

            let zoomedWidth: CGFloat = self.photoImageView.frame.width / maximumZoomScale
            let zoomedHeight: CGFloat = self.photoImageView.frame.height / maximumZoomScale
            let imageRect: CGRect = CGRect(x: tappedLocation.x - (zoomedWidth / 2), y: tappedLocation.y - (zoomedHeight / 2), width: zoomedWidth, height: zoomedHeight)
            self.contentScrollView.zoom(to: imageRect, animated: true)
        }
    }
}

extension PhotoView: UIScrollViewDelegate {

    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.photoImageView
    }

    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        var boundingSize: CGSize = scrollView.contentSize
        if scrollView.frame.size.width > boundingSize.width {
            boundingSize.width = scrollView.frame.size.width
        }
        if (scrollView.frame.size.height > boundingSize.height) {
            boundingSize.height = scrollView.frame.size.height
        }

        self.photoImageView.frame = CGRect(x: (boundingSize.width - self.photoImageView.frame.size.width) / 2, y: (boundingSize.height - self.photoImageView.frame.size.height) / 2, width: self.photoImageView.frame.size.width, height: self.photoImageView.frame.size.height)
    }
}
