//
//  BillingInfoDetailViewController.swift
//  TimeSelfCare
//
//  Created by Loka on 30/04/2018.
//  Copyright © 2018 Apptivity Lab. All rights reserved.
//

import UIKit
import MBProgressHUD

class BillingInfoDetailComponentView: UIStackView {
    var billingComponent: BillingInfoDetailViewController.BillingComponent? {
        didSet {
            titleLabel.text = billingComponent?.title
        }
    }

    weak var billingInfo: BillingInfo? {
        didSet {
            subtitleLabel.text = {
                switch self.billingComponent {
                case .deposit?:
                    return "RM \(billingInfo?.deposit ?? "-")"
                case .billingMethod?:
                    return billingInfo?.billingMethodString
                case .billingCycle?:
                    return billingInfo?.billingCycle
                case .emailAddress?:
                    return billingInfo?.billingEmailAddress
                case .address?:
                    return billingInfo?.displayBillingAddress
                default:
                    return nil
                }
            }()
            subtitleLabel.text = subtitleLabel.text?.isEmpty ?? true ? "-" : subtitleLabel.text
        }
    }

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let underlineLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.axis = .vertical
        self.spacing = 5
        self.distribution = .fill

        self.titleLabel.textColor = .black
        self.titleLabel.font = UIFont.preferredFont(forTextStyle: .caption1)

        self.subtitleLabel.preferredMaxLayoutWidth = self.bounds.width
        self.subtitleLabel.numberOfLines = 0
        self.subtitleLabel.textColor = .black
        self.subtitleLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        self.subtitleLabel.text = "-"
        
        underlineLabel.backgroundColor = .grey2
        underlineLabel.heightAnchor.constraint(equalToConstant: 1.0).isActive = true

        self.addArrangedSubview(titleLabel)
        self.addArrangedSubview(subtitleLabel)
        self.addArrangedSubview(underlineLabel)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BillingInfoDetailViewController: TimeBaseViewController {
    enum BillingComponent {
        case deposit, billingMethod, billingCycle, emailAddress, address

        var title: String {
            switch self {
            case .deposit:
                return NSLocalizedString("Deposit", comment: "")
            case .billingMethod:
                return NSLocalizedString("Billing Method", comment: "")
            case .billingCycle:
                return NSLocalizedString("Billing Cycle", comment: "")
            case .emailAddress:
                return NSLocalizedString("Billing Email Address", comment: "")
            case .address:
                return NSLocalizedString("Billing Address", comment: "")
            }
        }

        static let allValues = [deposit, billingMethod, billingCycle, emailAddress, address]
    }

    var billingInfo: BillingInfo? {
        didSet {
            self.updateUI(with: billingInfo)
        }
    }

    @IBOutlet private weak var stackViewContainer: UIStackView!
    @IBOutlet weak var liveChatView: ExpandableLiveChatView!
    @IBOutlet weak var liveChatConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.billingInfo = BillingInfoDataController.shared.getBillingInfos(account: AccountController.shared.selectedAccount).first
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if (liveChatView.isExpand) {
            liveChatConstraint.constant = 0
        } else {
            liveChatConstraint.constant = -125
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let hud: MBProgressHUD? = self.billingInfo == nil ? MBProgressHUD.showAdded(to: self.view, animated: true) : nil
        hud?.label.text = NSLocalizedString("Loading...", comment: "")
        BillingInfoDataController.shared.loadBillingInfos(account: AccountController.shared.selectedAccount) { (billingInfo: [BillingInfo], error: Error?) in
            hud?.hide(animated: true)
            if let error = error {
                self.showAlertMessage(with: error)
                return
            }
            self.billingInfo = billingInfo.first
        }
    }

    private func setupUI() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back_arrow"), style: .plain, target: self, action: #selector(self.dismissVC(_:)))

        BillingComponent.allValues.forEach {
            let componentView = BillingInfoDetailComponentView()
            componentView.billingComponent = $0
            self.stackViewContainer.addArrangedSubview(componentView)
        }
        self.updateUI(with: self.billingInfo)
    }

    private func updateUI(with billingInfo: BillingInfo?) {
        self.stackViewContainer.subviews.forEach {
            let view = $0 as? BillingInfoDetailComponentView
            view?.billingInfo = billingInfo
        }

        let canEditBillingInfo: Bool = billingInfo?.canUpdateBillingMethod ?? false || billingInfo?.canUpdateBillingAddress ?? false
        self.navigationItem.rightBarButtonItem = canEditBillingInfo ? UIBarButtonItem(title: NSLocalizedString("Edit", comment: ""), style: .plain, target: self, action: #selector(self.editBillingInfo)) : nil
    }

    @objc
    func editBillingInfo() {
        let billingInfoViewController: BillingInfoFormViewController = UIStoryboard(name: "BillingInfo", bundle: nil).instantiateViewController()
        billingInfoViewController.billingInfo = self.billingInfo
        self.presentNavigation(billingInfoViewController, animated: true)
    }

}
