//
//  ConversationFooterView.swift
//  TimeSelfCare
//
//  Created by Loka on 06/08/2018.
//  Copyright © 2018 Apptivity Lab. All rights reserved.
//

import UIKit

protocol ConversationFooterViewDelegate: class {
    func footerView(_ footerView: ConversationFooterView, resend conversation: Conversation)
}

class ConversationFooterView: UITableViewHeaderFooterView {
    enum Alignment {
        case left, right
    }

    private var conversation: Conversation!
    weak var delegate: ConversationFooterViewDelegate?

    // swiftlint:disable implicitly_unwrapped_optional
    private weak var dateLabel: UILabel!
    private weak var stackView: UIStackView!
    private weak var statusButton: UIButton!
    private weak var activityIndicatorView: UIActivityIndicatorView!
    // swiftlint:enable implicitly_unwrapped_optional

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .trailing
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView = stackView

        let dateLabel = UILabel()
        dateLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        dateLabel.textAlignment = .right
        self.dateLabel = dateLabel
        stackView.addArrangedSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
            ])

        let statusButton = UIButton()
        statusButton.translatesAutoresizingMaskIntoConstraints = false
        statusButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .caption2)
        statusButton.setTitleColor(.black, for: .normal)
        statusButton.titleLabel?.textAlignment = .right
        statusButton.addTarget(self, action: #selector(self.resendConversation), for: .touchUpInside)
        self.addSubview(statusButton)
        NSLayoutConstraint.activate([
            statusButton.widthAnchor.constraint(equalToConstant: 80),
            statusButton.bottomAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 6),
            statusButton.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: 0)
            ])
        self.statusButton = statusButton

        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .white
        self.statusButton.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.statusButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.statusButton.centerYAnchor)
            ])
        self.activityIndicatorView = activityIndicator
        self.activityIndicatorView.isHidden = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("ConversationFooterView init(coder:) has not been implemented")
    }

    func configure(with conversation: Conversation, alignment: Alignment = .right) {
        self.conversation = conversation
        self.dateLabel.text = conversation.datetime
        self.activityIndicatorView.isHidden = true
        self.stackView.alignment = alignment == .right ? .trailing : .leading

        self.statusButton.isHidden = alignment == .left
        switch conversation.status {
        case .sending:
            self.statusButton.setTitle(NSLocalizedString(String(), comment: ""), for: .normal)
            self.activityIndicatorView.isHidden = false
            self.activityIndicatorView.startAnimating()
        case .failed:
            self.statusButton.setTitle(NSLocalizedString("Not Delivered", comment: ""), for: .normal)
        default:
            self.statusButton.setTitle(NSLocalizedString("Delivered", comment: ""), for: .normal)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.dateLabel.text = nil
        self.activityIndicatorView.isHidden = true
        self.stackView.alignment = .trailing

        self.statusButton.isHidden = true
    }

    @objc
    private func resendConversation() {
        guard let conversation = self.conversation else {
            return
        }
        conversation.status = .sending
        self.configure(with: conversation)
        delegate?.footerView(self, resend: conversation)
    }
}
