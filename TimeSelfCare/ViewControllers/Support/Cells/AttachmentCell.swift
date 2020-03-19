//
//  AttachmentCell.swift
//  TimeSelfCare
//
//  Created by Loka on 21/06/2018.
//  Copyright © 2018 Apptivity Lab. All rights reserved.
//

import UIKit

protocol AttachmentCellDelegate: class {
    func cell(_ cell: AttachmentCell, didRemove mediaInfo: [String: Any])
}

class AttachmentCell: UICollectionViewCell {
    weak var delegate: AttachmentCellDelegate?

    var image: UIImage? {
        return self.imageView.image
    }

    var mediaInfo: [String: Any] = [:]

    private weak var imageView: UIImageView! // swiftlint:disable:this implicitly_unwrapped_optional
    private weak var removeButton: UIButton! // swiftlint:disable:this implicitly_unwrapped_optional
    private weak var removeImageView: UIImageView! // swiftlint:disable:this implicitly_unwrapped_optional

    override init(frame: CGRect) {
        super.init(frame: frame)
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        self.addSubview(imageView)
        imageView.clipsToBounds = true
        imageView.backgroundColor = .grey2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.0, constant: -16),
            imageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1.0, constant: -16),
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        self.imageView = imageView

        let removeImageView = UIImageView()
        removeImageView.image = #imageLiteral(resourceName: "ic_remove_photo")
        self.addSubview(removeImageView)
        self.removeImageView = removeImageView
        removeImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            removeImageView.widthAnchor.constraint(equalToConstant: 20),
            removeImageView.heightAnchor.constraint(equalToConstant: 20),
            removeImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            removeImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0)
        ])

        let removeButton = UIButton()
        removeButton.addTarget(self, action: #selector(self.removeImage), for: .touchUpInside)
        self.addSubview(removeButton)
        self.removeButton = removeButton
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            removeButton.widthAnchor.constraint(equalToConstant: 40),
            removeButton.heightAnchor.constraint(equalToConstant: 40),
            removeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            removeButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 0)
        ])

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("AttachmentCell init(coder:) has not been implemented")
    }

    func configureCell(with info: [String: Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage {
            self.imageView.image = image
        }
        self.mediaInfo = info
    }

    func configureCell(with attachment: Attachment) {
        self.removeImageView.isHidden = true
        self.removeButton.isHidden = true
        self.imageView.sd_setImage(with: attachment.url, placeholderImage: nil)
    }

    @objc
    func removeImage() {
        self.delegate?.cell(self, didRemove: self.mediaInfo)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
}
