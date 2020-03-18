//
//  VoicePlanHeaderView.swift
//  TimeSelfCare
//
//  Created by Loka on 25/04/2018.
//  Copyright © 2018 Apptivity Lab. All rights reserved.
//

import UIKit

protocol VoicePlanHeaderViewDelegate: class {
    func voicePlanHeaderView(_ voicePlanHeaderView: VoicePlanHeaderView, didSelect serviceId: String)
}

class VoicePlanHeaderView: UITableViewHeaderFooterView {
    weak var delegate: VoicePlanHeaderViewDelegate?
    private var service: Service?
    private var isCollapsable: Bool = false
    private var arrowImageRotationAngle: CGFloat = -CGFloat.pi * 2

    // swiftlint:disable implicitly_unwrapped_optional
    private weak var serviceIdLabel: UILabel!
    private weak var planNameLabel: UILabel!
    private weak var priceLabel: UILabel!
    private weak var arrowImageView: UIImageView!
    private var tapGestureRecognizer: UITapGestureRecognizer!
    // swiftlint:enable implicitly_unwrapped_optional

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUI()
    }

    deinit {
        self.removeGestureRecognizer(self.tapGestureRecognizer)
    }

    private func setupUI() {

        self.contentView.backgroundColor = .white

        let stackView = UIStackView()
        stackView.spacing = 10
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .top

        let serviceIdLabel = UILabel()
        serviceIdLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        serviceIdLabel.textColor = .black
        serviceIdLabel.setContentHuggingPriority(UILayoutPriority(1_000), for: .horizontal)

        let planLabel = InsetLabel()
        planLabel.topInset = 5
        planLabel.bottomInset = 5
        planLabel.leftInset = 8
        planLabel.rightInset = 8
        planLabel.borderColor = .positive
        planLabel.layer.cornerRadius = 5
        planLabel.layer.borderWidth = 1
        planLabel.textColor = .positive
        planLabel.font = UIFont.preferredFont(forTextStyle: .caption2)
        planLabel.textAlignment = .center
        planLabel.numberOfLines = 0

        let priceLabel = UILabel()
        priceLabel.textColor = .black
        priceLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        priceLabel.textAlignment = .right

        let arrowImageView = UIImageView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 40, height: 40)))
        arrowImageView.clipsToBounds = true
        arrowImageView.contentMode = .scaleAspectFit
        arrowImageView.image = #imageLiteral(resourceName: "ic_arrow_down")

        stackView.addArrangedSubview(serviceIdLabel)
        stackView.addArrangedSubview(planLabel)
        stackView.addArrangedSubview(priceLabel)
        stackView.addArrangedSubview(arrowImageView)

        self.serviceIdLabel = serviceIdLabel
        self.planNameLabel = planLabel
        self.priceLabel = priceLabel
        self.arrowImageView = arrowImageView

        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        ])

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture(sender:)))
        self.addGestureRecognizer(tapGestureRecognizer)
        self.tapGestureRecognizer = tapGestureRecognizer
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.serviceIdLabel.text = nil
        self.planNameLabel.text = nil
        self.priceLabel.text = nil
        self.arrowImageView.image =  #imageLiteral(resourceName: "ic_arrow_down")
    }

    func configure(with service: Service, isCollapsed: Bool, isCollapsable: Bool) {
        self.service = service
        self.isCollapsable = isCollapsable
        self.arrowImageView.isHidden = !isCollapsable
        self.serviceIdLabel.text = service.serviceId
        self.planNameLabel.text = service.name
        self.priceLabel.text = service.pricePackage ?? "0.00"
    }

    @objc
    private func tapGesture(sender: AnyObject?) {
        guard self.isCollapsable else {
            return
        }
        self.startAnimation()
        self.delegate?.voicePlanHeaderView(self, didSelect: self.serviceIdLabel.text ?? "")
    }

    func startAnimation() {
        self.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3, animations: {
            self.arrowImageRotationAngle = self.arrowImageRotationAngle >= 0 ? -CGFloat.pi * 2 : CGFloat.pi
            self.arrowImageView.transform = CGAffineTransform(rotationAngle:  self.arrowImageRotationAngle)
        }, completion: { _ in
            self.isUserInteractionEnabled = true
        })
    }
}
