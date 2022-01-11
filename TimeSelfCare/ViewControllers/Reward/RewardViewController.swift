//
//  RewardViewController.swift
//  TimeSelfCare
//
//  Created by Loka on 03/07/2019.
//  Copyright © 2019 Apptivity Lab. All rights reserved.
//

import UIKit
import MBProgressHUD

class RewardViewController: TimeBaseViewController {

    private var rewards: [Reward] = [] {
        didSet {
            
            if rewards.count >= 1 {
                self.yearsView.isHidden = false
                self.yearsConstraint.constant = 60
                self.rewards = self.rewards.sorted { $0.year ?? 0 > $1.year ?? 0 }
                self.yearLabel1.text = String(format: "%d", self.rewards[0].year ?? "")
                self.yearLabel1.textColor = UIColor.primary
                if rewards.count >= 2, self.rewards[1].status != .notAvailable {
                    self.yearLabel2.text = String(format: "%d", self.rewards[1].year ?? "")
                    self.yearLabel2.textColor = UIColor.gray
                } else {
                    self.yearLabel2.text = ""
                }
                self.reward = self.rewards[0]
            } else {
                self.reward = self.rewards.sorted { $0.year ?? 0 > $1.year ?? 0 }.first
            }
            
            guard let reward = self.reward else {
                return
            }

            displayReward(reward: reward)
        }
    }

//    private var reward: Reward? {
//        return self.rewards.sorted { $0.year ?? 0 > $1.year ?? 0 }.first
//    }

    private var count: Int = 0

    private var sectionCollapsed: [Bool] = []
    private var sections: [Reward.Section] {
        return self.reward?.sections ?? []
    }

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: NSLocalizedString("Pull to refresh", comment: ""))
        refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        return refreshControl
    }()

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var tableHeaderImageView: UIImageView!
    @IBOutlet private weak var rewardNameLabel: UILabel!
    @IBOutlet private weak var validityLabel: UILabel!
    @IBOutlet private weak var actionButton: UIButton!
    @IBOutlet private weak var congratulationStackView: UIStackView!
    @IBOutlet private weak var footerInfoLabel: UILabel!
    @IBOutlet private weak var footerStackView: UIStackView!
    @IBOutlet private weak var voucherStackView: UIStackView!
    @IBOutlet private weak var voucherCodeLabel: UILabel!
    @IBOutlet private weak var validityPeriodStackView: UIStackView!
    @IBOutlet private weak var rewardVoucherDetailsStackView: UIStackView!
    @IBOutlet weak var liveChatView: ExpandableLiveChatView!
    @IBOutlet weak var liveChatConstraint: NSLayoutConstraint!
    @IBOutlet private weak var yearsView: UIView!
    @IBOutlet private weak var yearLabel1: UILabel!
    @IBOutlet private weak var yearLabel2: UILabel!
    @IBOutlet private weak var yearsConstraint: NSLayoutConstraint!
    
    private var reward: Reward?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("TIME REWARDS", comment: "")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back_arrow"), style: .done, target: self, action: #selector(self.dismissVC(_:)))

        self.tableView.addSubview(self.refreshControl)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 50

        self.tableView.register(UINib(nibName: "RewardHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "RewardHeaderView")
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if liveChatView.isExpand {
            liveChatConstraint.constant = 0
        } else {
            liveChatConstraint.constant = -125
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.yearsConstraint.constant = 0
        self.yearsView.isHidden = true
        self.refresh()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if let headerView = self.tableView.tableHeaderView {
            let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height

            var headerFrame = headerView.frame

            if height != headerFrame.size.height { // To avoid infinite loop
                headerFrame.size.height = height
                headerView.frame = headerFrame
                tableView.tableHeaderView = headerView
            }
        }

        if let footerView = self.tableView.tableFooterView {
            let height = footerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height

            var footerFrame = footerView.frame

            if height != footerFrame.size.height { // To avoid infinite loop
                footerFrame.size.height = height
                footerView.frame = footerFrame
                tableView.tableFooterView = footerView
            }
        }
    }

    @objc
    private func refresh() {
        self.rewards = RewardDataController.shared.getRewards(account: AccountController.shared.selectedAccount)

        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = NSLocalizedString("Loading...", comment: "")

        RewardDataController.shared.loadRewards(account: AccountController.shared.selectedAccount) { (rewards: [Reward], error: Error?) in
            hud.hide(animated: true)
            self.refreshControl.endRefreshing()
            if let error = error {
                self.showAlertMessage(with: error)
                return
            }

            self.rewards = rewards
        }
    }

    @IBAction func actionButtonTapped(_ sender: Any) {
        guard
            let reward = self.reward,
            let status = reward.status else {
            return
        }
        switch status {
        case .available:
            let messageTitle = NSLocalizedString("Confirmation", comment: "")
            let message = NSLocalizedString("Are you sure you want to grab this reward?", comment: "")

            let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .default, handler: nil)
            let grabAction = UIAlertAction(title: NSLocalizedString("Grab", comment: ""), style: .default) { _ in
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                hud.label.text = NSLocalizedString("Grabbing...", comment: "")
                RewardDataController.shared.grabReward(reward,
                                                       account: AccountController.shared.selectedAccount) { _, error in
                                                        hud.hide(animated: true)
                                                        if let error = error {
                                                            self.showAlertMessage(with: error)
                                                            return
                                                        }
                                                        self.refresh()
                }
            }
            self.showAlertMessage(title: messageTitle, message: message, actions: [cancelAction, grabAction])

        case .grabbed:
            let confimationVC: RewardConfirmationViewController = UIStoryboard(name: TimeSelfCareStoryboard.reward.filename, bundle: nil).instantiateViewController()
            confimationVC.reward = self.reward
            self.presentNavigation(confimationVC, animated: true)
        default:
            return
        }
    }
    
    func displayReward(reward: Reward) {
        
        self.reward = reward
        if let imagePath = reward.image {
            self.tableHeaderImageView.sd_setImage(with: URL(string: imagePath), completed: nil)
        } else {
            self.tableHeaderImageView.image = UIImage()
        }
        self.sectionCollapsed = [Bool](repeating: true, count: reward.sections.count)
        self.rewardNameLabel.text = String(htmlEncodedString: reward.name ?? "")
        self.validityLabel.text = String(htmlEncodedString: reward.validityPeriod ?? "")

        self.validityPeriodStackView.axis = reward.status == .grabbed ? .vertical : .horizontal

        for (index, view) in self.voucherStackView.arrangedSubviews.enumerated() {
            if (index != 0) {
                self.voucherStackView.removeArrangedSubview(view)
                view.removeFromSuperview()
            }
        }

        if (reward.status != .expired) {
            if let voucherCodes = reward.code?.filter({ $0.isValidURL == false }) {
                for voucherCode in voucherCodes {
                    if let voucherLabel = UINib(nibName: "VoucherLabel", bundle:nil).instantiate(withOwner: nil, options: nil)[0] as? VoucherLabel {
                        voucherLabel.text = String(htmlEncodedString: voucherCode ?? "")
                        self.voucherStackView.addArrangedSubview(voucherLabel)
                    }
                }
            }
        }

        let shouldHideVoucher = reward.code == nil || reward.status == .redeemed
        self.voucherStackView.isHidden = shouldHideVoucher
        self.voucherStackView.arrangedSubviews.forEach {
            $0.isHidden = shouldHideVoucher
        }

        self.tableView.reloadData()
        self.actionButton.setTitle(reward.status?.buttonTitle ?? "", for: .normal)

        let buttonActionable = reward.status == .available || (reward.status == .grabbed && self.reward?.canRedeem == true)
        self.actionButton.isEnabled = buttonActionable
        self.actionButton.backgroundColor = buttonActionable ? .primary : .grey2

        self.footerInfoLabel.text = String(htmlEncodedString: reward.status?.footerInfo ?? "")
        self.footerInfoLabel.isHidden = reward.status?.footerInfo == nil
        self.footerInfoLabel.textColor = reward.status?.footerInfoColor ?? .grey

        let shouldHideFooter: Bool = (reward.status == .grabbed && (self.reward?.canRedeem == false || self.reward?.canRedeem == nil))
        self.actionButton.isHidden = shouldHideFooter
        self.footerInfoLabel.isHidden = shouldHideFooter
        self.footerStackView.isHidden = shouldHideFooter
        self.tableView.tableFooterView?.isHidden = shouldHideFooter
        self.tableView.sectionHeaderHeight = UITableView.automaticDimension
        self.tableView.estimatedSectionHeaderHeight = 62

        self.congratulationStackView.isHidden = reward.status != .grabbed
        self.congratulationStackView.arrangedSubviews.forEach {
            $0.isHidden = reward.status != .grabbed
        }
    }
    
    @IBAction func actYear1(_ sender: Any) {
        self.yearLabel1.textColor = UIColor.primary
        self.yearLabel2.textColor = UIColor.gray
        displayReward(reward: self.rewards[0])
    }
    
    @IBAction func actYear2(_ sender: Any) {
        if rewards.count >= 2, self.rewards[1].status != .notAvailable {
            self.yearLabel1.textColor = UIColor.gray
            self.yearLabel2.textColor = UIColor.primary
            displayReward(reward: self.rewards[1])
        }
    }
}

extension RewardViewController: UITableViewDataSource, UITableViewDelegate {
    private func data(for section: Reward.Section) -> [String]? {
        switch section {
        case .howToRedeem:
            return self.reward?.howToRedeem
        case .outlets:
            return self.reward?.outlets?.keys.compactMap { $0 }
        case .termsAndConditions:
            return self.reward?.termsAndConditions
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sectionCollapsed[section] ? 0 : data(for: self.sections[section])?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellSection = self.sections[indexPath.section]

        if cellSection == .outlets,
            let cell = tableView.dequeueReusableCell(withIdentifier: "RewardOutletsCell") as? RewardOutletsCell,
            let outlets = self.reward?.outlets {

            let region = Array(outlets.keys.sorted())[indexPath.row]
            cell.configure(with: region, outlets: outlets[region] ?? [], icon: #imageLiteral(resourceName: "ic_location.png"))
            return cell
        }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RewardCell") as? RewardCell else {
            return UITableViewCell()
        }

        let description = self.data(for: cellSection)![indexPath.item] // swiftlint:disable:this force_unwrapping

        cell.configure(with: description,
                       icon: cellSection == .outlets ? #imageLiteral(resourceName: "ic_location.png") : nil,
                       index: cellSection == .termsAndConditions ? indexPath.item + 1 : nil)
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "RewardHeaderView") as? RewardHeaderView {
            if section < self.sections.count {
                headerView.configure(with: self.sections[section], isCollapsed: self.sectionCollapsed[section])
                headerView.delegate = self
            }
            return headerView
        }
        return nil
    }
}

extension RewardViewController: RewardHeaderViewDelegate {
    func toggleSection(_ header: RewardHeaderView, section: Reward.Section) {
        let index = self.sections.firstIndex { $0 == section } ?? 0
        self.sectionCollapsed[index] = !self.sectionCollapsed[index]

        if index < 0 {
            return
        }
        guard self.tableView.numberOfSections > 0 else {
           return
       }

       tableView.reloadSections(IndexSet(integer: index), with: .automatic)
    }
}

extension Reward {

    enum Section {
        case howToRedeem, outlets, termsAndConditions

        var title: String {
            switch self {
            case .howToRedeem:
                return NSLocalizedString("How To Redeem", comment: "")
            case .outlets:
                return NSLocalizedString("Participating Outlets", comment: "")
            case .termsAndConditions:
                return NSLocalizedString("Terms & Conditions", comment: "")
            }
        }

        var icon: UIImage {
            switch self {
            case .howToRedeem:
                return #imageLiteral(resourceName: "ic_gift.png")
            case .outlets:
                return #imageLiteral(resourceName: "ic_participating_outlets.png")
            case .termsAndConditions:
                return #imageLiteral(resourceName: "ic_terms_conditions.png")
            }
        }
    }

    var sections: [Reward.Section] {
        var sections: [Reward.Section] = []
        if self.howToRedeem?.isEmpty == false {
            sections.append(.howToRedeem)
        }

        if self.outlets?.isEmpty == false {
            sections.append(.outlets)
        }

        if self.termsAndConditions?.isEmpty == false {
            sections.append(.termsAndConditions)
        }
        return sections
    }
}

extension Reward.Status {
    var buttonTitle: String {
        switch self {
        case .available:
            return NSLocalizedString("GRAB THIS REWARD", comment: "")
        case .grabbed:
            return NSLocalizedString("REDEEM", comment: "")
        case .fullyGrabbed:
            return NSLocalizedString("FULLY GRABBED", comment: "")
        case .redeemed:
            return NSLocalizedString("REDEEMED", comment: "")
        case .expired:
            return NSLocalizedString("EXPIRED", comment: "")
        case .notAvailable:
            return NSLocalizedString("NOT AVAILABLE", comment: "")
        }
    }

    var footerInfo: String? {
        switch self {
        case .grabbed:
            return NSLocalizedString("Do not click! This button is only for merchant use.", comment: "")
        case .fullyGrabbed:
            return NSLocalizedString("Best of luck in the next cycle. Rewards are up for grabs on the 15th of every month.", comment: "")
        default:
            return nil
        }
    }

    var footerInfoColor: UIColor {
        switch self {
        case .grabbed:
            return .primary
        default:
            return .darkGrey
        }
    }
}

extension String {
    var isValidURL: Bool {
        return self.hasPrefix("https://") || self.hasPrefix("http://") 
    }


//    var isValidURL: Bool {
//        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
//
//
//        if let urlEncoded = self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
//            let match = detector.firstMatch(in: urlEncoded, options: [], range: NSRange(location: 0, length: urlEncoded.count)) {
//            // it is a link, if the match covers the whole string
//            return match.range.length == urlEncoded.count
//        } else {
//            return false
//        }
//    }
}


