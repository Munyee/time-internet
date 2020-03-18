//
//  RightAttachmentCell.swift
//  TimeSelfCare
//
//  Created by Loka on 02/08/2018.
//  Copyright © 2018 Apptivity Lab. All rights reserved.
//

import UIKit

protocol ConversationAttachmentCellDelegate: class {
    func cell(_ cell: ConversationAttachmentCell, didSelectImage image: UIImage?, attachment: Attachment?)
}

class ConversationAttachmentCell: UITableViewCell {
    enum ImageAlignment {
        case left, right
    }

    weak var delegate: ConversationAttachmentCellDelegate?
    private var conversationImage: UIImage?
    private var attachment: Attachment?

    private weak var attachmentImageView: UIImageView!
    private weak var stackView: UIStackView!

    required init?(coder aDecoder: NSCoder) {
        fatalError("RightConversationCell init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.backgroundColor = .clear

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .trailing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
            ])
        self.stackView = stackView

        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .grey2
        imageView.cornerRadius = 4

        stackView.addArrangedSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 120),
            imageView.heightAnchor.constraint(equalToConstant: 120)
            ])
        self.attachmentImageView = imageView

        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(self.view), for: .touchUpInside)
        button.setTitle(nil, for: .normal)
        button.backgroundColor = .clear
        self.addSubview(button)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: imageView.topAnchor),
            button.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            button.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: imageView.trailingAnchor)
            ])
    }

    func configureCell(with attachment: Attachment, alignment: ImageAlignment = .right) {
        self.attachmentImageView.sd_setImage(with: attachment.url)
        switch alignment {
        case .left:
            self.stackView.alignment = .leading
        case .right:
            self.stackView.alignment = .trailing
        }
        self.attachment = attachment
    }

    func configureCell(with image: UIImage, alignment: ImageAlignment = .right) {
        self.attachmentImageView.image = image
        switch alignment {
        case .left:
            self.stackView.alignment = .leading
        case .right:
            self.stackView.alignment = .trailing
        }
        self.conversationImage = image
    }

    @objc
    func view() {
        self.delegate?.cell(self, didSelectImage: self.conversationImage ?? self.imageView?.image, attachment: self.attachment)
    }
}
