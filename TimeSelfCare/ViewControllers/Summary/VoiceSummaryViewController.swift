//
//  VoiceSummaryViewController.swift
//  TimeSelfCare
//
//  Created by Loka on 21/11/2017.
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import UIKit

class VoiceSummaryViewController: BaseViewController {
    private var voiceServices: [Service] = [] {
        didSet {
            for i in 0..<self.voiceServices.count {
                isSectionCollapsed[i] = true
            }
        }
    }

    private var showFreeMinutes: Bool {
        return AccountController.shared.selectedAccount?.hasFreeMinutes ?? false
    }

    private var isSectionCollapsed: [Int: Bool] = [:]
    private let headerViewIdentifier: String = "VoicePlanHeaderView"

    @IBOutlet private weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("Voice", comment: "")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back_arrow"), style: .done, target: self, action: #selector(self.dismissVC(_:)))

        self.tableView.register(VoicePlanHeaderView.self, forHeaderFooterViewReuseIdentifier: headerViewIdentifier)

        self.tableView.sectionHeaderHeight = UITableView.automaticDimension
        self.tableView.estimatedSectionHeaderHeight = 100

        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refresh()
    }

    func refresh(sender: Any? = nil) {
        self.updateUI()
    }

    override func updateUI() {

        if let voiceService: Service = AccountController.shared.selectedAccount?.freeMinutesService {
            self.tableView?.tableHeaderView = viewForTableViewHeader(with: voiceService)
        } else {
            self.tableView?.tableHeaderView = nil
        }

        self.tableView?.reloadData()
    }

    override func updateDataSet(items: [Service]?) {
        self.voiceServices = ServiceDataController.shared.getServices(account: AccountController.shared.selectedAccount).filter { $0.category == .voice }
        self.updateUI()
    }

    private func viewForTableViewHeader(with service: Service) -> UIView {
        let containerPadding: CGFloat = 10
        let ringViewHeight: CGFloat = 95
        let containerViewRect = CGRect(origin: CGPoint.zero, size: CGSize(width: self.tableView.bounds.width, height: ringViewHeight + containerPadding * 2))
        let containerView = UIView(frame: containerViewRect)

        let ringView = RingView()
        if let balanceMinutesStr = service.freeMinutesBalance,
            let balanceMinutes = Double(balanceMinutesStr),
            let totalMinutesStr = service.freeMinutesTotal,
            let totalMinutes = Double(totalMinutesStr) {
            ringView.percentageFilled = CGFloat(balanceMinutes / totalMinutes)
        }

        ringView.backgroundColor = .white
        containerView.addSubview(ringView)
        ringView.translatesAutoresizingMaskIntoConstraints = false

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        let totalMinutesLeftLabel = UILabel()
        totalMinutesLeftLabel.text = service.freeMinutesBalance ?? "-"
        totalMinutesLeftLabel.textColor = .primary
        totalMinutesLeftLabel.font = UIFont.preferredFont(forTextStyle: .title1)

        let minutesLeftLabel = UILabel()
        minutesLeftLabel.text = NSLocalizedString("mins left", comment: "")
        minutesLeftLabel.font = UIFont.preferredFont(forTextStyle: .caption1)

        stackView.addArrangedSubview(totalMinutesLeftLabel)
        stackView.addArrangedSubview(minutesLeftLabel)
        ringView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            ringView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            ringView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            ringView.widthAnchor.constraint(equalToConstant: ringViewHeight),
            ringView.heightAnchor.constraint(equalToConstant: ringViewHeight),
            stackView.centerXAnchor.constraint(equalTo: ringView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: ringView.centerYAnchor)
        ])

        return containerView
    }
}

extension VoiceSummaryViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.voiceServices.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (!(isSectionCollapsed[section] ?? true) || self.voiceServices.count == 1) && self.voiceServices[section].isThf ?? false ? 1 : 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let service = self.voiceServices[section]
        let isCollapsable = self.voiceServices.count > 1 && (service.isThf ?? false)
        let headerView = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: headerViewIdentifier) as? VoicePlanHeaderView
        headerView?.configure(with: service, isCollapsed: self.isSectionCollapsed[section] ?? true, isCollapsable: isCollapsable)
        headerView?.delegate = self
        return headerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "VoicePlanCell") as? VoicePlanCell {
            cell.selectionStyle = .none
            cell.delegate = self
            cell.configure(with: self.voiceServices[indexPath.section])
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension VoiceSummaryViewController: VoicePlanHeaderViewDelegate {
    func voicePlanHeaderView(_ voicePlanHeaderView: VoicePlanHeaderView, didSelect serviceId: String) {
        if let index = self.voiceServices.index(where: { $0.serviceId == serviceId }) {
            // close other expanded section
            if let expandedIndex = self.isSectionCollapsed.keys.first(where: { !(self.isSectionCollapsed[$0] ?? true) && $0 != index }) {
                self.isSectionCollapsed[expandedIndex] = true
                (self.tableView.headerView(forSection: expandedIndex) as? VoicePlanHeaderView)?.startAnimation()
                self.tableView.beginUpdates()
                self.tableView.deleteRows(at: [IndexPath(row: 0, section: expandedIndex)], with: .automatic)
                self.tableView.endUpdates()
            }

            self.isSectionCollapsed[index] = !(self.isSectionCollapsed[index] ?? false)
            self.tableView.beginUpdates()
            if self.isSectionCollapsed[index] ?? true {
                self.tableView.deleteRows(at: [IndexPath(row: 0, section: index)], with: .automatic)
            } else {
                self.tableView.insertRows(at: [IndexPath(row: 0, section: index)], with: .automatic)
            }

            self.tableView.endUpdates()
        }
    }
}

extension VoiceSummaryViewController: VoicePlanCellDelegate {
    func voicePlanCell(_ voicePlanCell: VoicePlanCell, regenerateQRCode service: Service) {
        guard
            let account = AccountController.shared.selectedAccount
            else {
                return
        }
        let hud = LoadingView().addLoading(toView: self.view)
        hud.showLoading()
        APIClient.shared.generateTHRCode(AccountController.shared.profile.username, account: account, service: service) { ( _, error: Error?) in
            hud.hideLoading()
            if let error = error {
                self.showAlertMessage(with: error)
                return
            }
            voicePlanCell.configure(with: service)
        }
    }
}
