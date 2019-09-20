//
//  SelectedImageCell.swift
//  TimeSelfCare
//
//  Created by Loka on 30/07/2018.
//  Copyright © 2018 Apptivity Lab. All rights reserved.
//

import UIKit

protocol SelectedImageCellDelegate: class {
    func selectedImageCell(_ cell: SelectedImageCell, didRemove info: [String: Any])
}

class SelectedImageCell: UICollectionViewCell {

    weak var delegate: SelectedImageCellDelegate?
    var info: [String: Any] = [:]

    @IBOutlet weak private var imageView: UIImageView!

    func configureCell(with info: [String: Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage {
            self.imageView.image = image
        }
        self.info = info
    }

    @IBAction func removeImage(_ sender: UIButton) {
        self.delegate?.selectedImageCell(self, didRemove: info)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
}
