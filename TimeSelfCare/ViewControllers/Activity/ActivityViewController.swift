//
//  ActivityViewController.swift
//  TimeSelfCare
//
//  Created by Loka on 14/05/2018.
//  Copyright © 2018 Apptivity Lab. All rights reserved.
//

import UIKit
import MBProgressHUD

class ActivityViewController: TimeBaseViewController {
    var activities: [Activity] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: NSLocalizedString("Pull to refresh", comment: ""))
        refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        return refreshControl
    }()

    @IBOutlet private weak var tableView: UITableView!
    var filter: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("NOTIFICATIONS", comment: "")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back_arrow"), style: .done, target: self, action: #selector(self.dismissVC(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Settings", comment: ""), style: .plain, target: self, action: #selector(self.changeNotificationSettings(_:)))

        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
        self.tableView.tableFooterView = UIView()

        self.tableView.refreshControl = self.refreshControl
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refresh()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.applicationIconBadgeNumber = 0
        APNSController.shared.markAllRead()
    }

    @objc
    func refresh() {
        self.activities = ActivityDataController.shared.getActivities(account: AccountController.shared.selectedAccount, filter: filter)

        ActivityDataController.shared.loadActivities(account: AccountController.shared.selectedAccount, filter: filter) { (activities: [Activity], error: Error?) in
            self.refreshControl.endRefreshing()
            if let error = error {
                self.showAlertMessage(with: error)
                return
            }

            self.activities = ActivityDataController.shared.getActivities(account: AccountController.shared.selectedAccount, filter: self.filter)
        }

    }

    @IBAction func changeNotificationSettings(_ sender: Any) {
        let notificationSettingsVC: NotificationSettingsViewController = UIStoryboard(name: TimeSelfCareStoryboard.profile.filename, bundle: nil).instantiateViewController()
        self.presentNavigation(notificationSettingsVC, animated: true)
    }

}

extension ActivityViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.activities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityTableViewCell") as? ActivityTableViewCell else {
            return UITableViewCell()
        }
        let activity = self.activities[indexPath.row]
        cell.configure(with: activity)
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let activity = self.activities[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath) as? ActivityTableViewCell
        cell?.markAsRead()

        if activity.isNew {
            activity.isNew = false
            ActivityDataController.shared.markActivityAsRead(for: activity, account: AccountController.shared.selectedAccount)
        }

        switch activity.type {
        case .newBill, .billing:
            let invoicesVC: BillsViewController = UIStoryboard(name: TimeSelfCareStoryboard.payment.filename, bundle: nil).instantiateViewController()
            self.presentNavigation(invoicesVC, animated: true)
        case .ticket:
            let ticketListVC: TicketListViewController = UIStoryboard(name: TimeSelfCareStoryboard.support.filename, bundle: nil).instantiateViewController()
            self.presentNavigation(ticketListVC, animated: true)
        case .rewards:
            let rewardVC: RewardViewController = UIStoryboard(name: TimeSelfCareStoryboard.reward.filename, bundle: nil).instantiateViewController()
            self.presentNavigation(rewardVC, animated: true)
        case .addOns:
            let addOnsVC: AddOnViewController = UIStoryboard(name: TimeSelfCareStoryboard.summary.filename, bundle: nil).instantiateViewController()
            self.presentNavigation(addOnsVC, animated: true)
        case .voicePlan:
            let voiceVC: VoiceSummaryViewController = UIStoryboard(name: TimeSelfCareStoryboard.summary.filename, bundle: nil).instantiateViewController()
            self.presentNavigation(voiceVC, animated: true)
        case .huae:
            let referralVC = UIStoryboard(name: TimeSelfCareStoryboard.hookup.filename, bundle: nil).instantiateViewController(withIdentifier: "ReferralViewController")
            self.navigationController?.pushViewController(referralVC, animated: true)
        case .reDirectMsg:
            if activity.click == "AddOnSummaryPage" {
                let addOnVC: AddOnViewController = UIStoryboard(name: TimeSelfCareStoryboard.summary.filename, bundle: nil).instantiateViewController()
                self.presentNavigation(addOnVC, animated: true)
            }
        default:
            break
        }
    }
}

extension Activity: Equatable {
    public static func == (rhs: Activity, lhs: Activity) -> Bool {
        return rhs.id == lhs.id
    }
}
