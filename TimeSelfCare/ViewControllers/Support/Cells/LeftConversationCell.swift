//
//  LeftConversationCell.swift
//  TimeSelfCare
//
//  Created by Loka on 22/06/2018.
//  Copyright © 2018 Apptivity Lab. All rights reserved.
//

import UIKit

class LeftConversationCell: UITableViewCell {
    // swiftlint:disable implicitly_unwrapped_optional
    private weak var conversationLabel: UILabel!
    // swiftlint:enable implicitly_unwrapped_optional

    required init?(coder aDecoder: NSCoder) {
        fatalError("LeftConversationCell init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.backgroundColor = .clear

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
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
        self.conversationLabel = label
        stackView.addArrangedSubview(label)

        self.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            stackView.rightAnchor.constraint(greaterThanOrEqualTo: self.rightAnchor, constant: -10),
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }

    func configureCell(with conversation: Conversation) {
        self.conversationLabel.text = conversation.body
    }
}
