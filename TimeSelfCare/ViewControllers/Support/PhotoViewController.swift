//
//  PhotoViewController.swift
//  TimeSelfCare
//
//  Created by Loka on 03/07/2018.
//  Copyright © 2018 Apptivity Lab. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

    var image: UIImage?
    var attachment: Attachment?

    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let image = self.image {
            self.imageView.image = image
        } else if let attachment = self.attachment {
            self.activityIndicatorView.startAnimating()
            self.imageView.sd_setImage(with: attachment.url) { _, _, _, _ in
                self.activityIndicatorView.stopAnimating()
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let widthScale = self.view.bounds.width / self.imageView.bounds.width
        let heightScale = self.view.bounds.width / self.imageView.bounds.width
        let minScale = min(widthScale, heightScale)

        self.scrollView.minimumZoomScale = minScale
        self.scrollView.zoomScale = minScale
    }
}

extension PhotoViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
