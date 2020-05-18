//
//  LeftConversationCell.swift
//  TimeSelfCare
//
//  Created by Loka on 22/06/2018.
//  Copyright © 2018 Apptivity Lab. All rights reserved.
//

import UIKit

class RightConversationCell: UITableViewCell {

    private let imageWidth: CGFloat = 120
    private let collectionViewLineSpacing: CGFloat = 5
    // swiftlint:disable implicitly_unwrapped_optional
    private var conversation: Conversation!

    private weak var dateLabel: UILabel!
    private weak var conversationLabel: UILabel!
    private weak var statusButton: UIButton!
    private weak var activityIndicatorView: UIActivityIndicatorView!
    // swiftlint:enable implicitly_unwrapped_optional

    required init?(coder aDecoder: NSCoder) {
        fatalError("RightConversationCell init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.backgroundColor = .clear

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .trailing
        stackView.distribution = .equalSpacing
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false

        let label = InsetLabel()
        label.topInset = 8
        label.bottomInset = 8
        label.leftInset = 8
        label.rightInset = 8
        label.layer.cornerRadius = 10
        label.numberOfLines = 0
        label.layer.masksToBounds = true
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.preferredMaxLayoutWidth = 250
        label.textAlignment = .left
        self.conversationLabel = label
        stackView.addArrangedSubview(label)

        self.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
            ])
    }

    func configureCell(with conversation: Conversation) {
        self.conversation = conversation

        self.conversationLabel.text = conversation.body
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.conversationLabel.text = String()
    }
}
