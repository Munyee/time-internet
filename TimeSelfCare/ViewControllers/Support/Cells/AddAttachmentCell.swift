//
//  AddAttachmentCell.swift
//  TimeSelfCare
//
//  Created by Loka on 21/06/2018.
//  Copyright © 2018 Apptivity Lab. All rights reserved.
//

import UIKit

class AddAttachmentCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        let borderView = UIView()
        borderView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(borderView)
        NSLayoutConstraint.activate([
            borderView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            borderView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            borderView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            borderView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
        ])

        let border = CAShapeLayer()
        border.strokeColor = UIColor.grey.cgColor
        border.fillColor = nil
        border.lineDashPattern = [2, 2]
        let pathRect = CGRect(x: 8, y: 8, width: self.bounds.width - 16, height: self.bounds.height - 16)
        border.path = UIBezierPath(rect: pathRect).cgPath
        self.layer.addSublayer(border)

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 5
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])

        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "ic_add_photo")
        stackView.addArrangedSubview(imageView)

        let label = UILabel()
        label.text = NSLocalizedString("Add Photo", comment: "")
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        stackView.addArrangedSubview(label)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("AddAttachmentCell init(coder:) has not been implemented")
    }
}
