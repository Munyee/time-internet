//
//  TicketListViewController.swift
//  TimeSelfCare
//
//  Created by Loka on 18/06/2018.
//  Copyright © 2018 Apptivity Lab. All rights reserved.
//

import UIKit
import MBProgressHUD

class TicketListViewController: TimeBaseViewController {

    var pendingTicket: Ticket?

    private var tickets: [Ticket] = [] {
        didSet {
            self.emptyPlaceholderView.isHidden = !self.tickets.isEmpty
            self.tableView.isHidden = self.tickets.isEmpty
            self.tableView.reloadData()
        }
    }

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: NSLocalizedString("Pull to refresh", comment: ""))
        refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        return refreshControl
    }()

    @IBOutlet private weak var emptyPlaceholderView: UIStackView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var createTicketButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("SUPPORT", comment: "")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back_arrow"), style: .done, target: self, action: #selector(self.dismissVC(_:)))

        self.tableView.addSubview(self.refreshControl)

        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 60
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let ticket = self.pendingTicket {
            let ticketDetailVC: TicketDetailViewController = UIStoryboard(name: TimeSelfCareStoryboard.support.filename, bundle: nil).instantiateViewController()
            ticketDetailVC.ticket = ticket
            self.navigationController?.pushViewController(ticketDetailVC, animated: true)
            self.pendingTicket = nil
        } else {
            self.refresh()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let selectedIndexPath = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }

    @objc
    private func refresh() {
        self.tickets = TicketDataController.shared.getTickets(account: AccountController.shared.selectedAccount)
        let hud: MBProgressHUD? = TicketDataController.shared.categoryOptions.isEmpty ? MBProgressHUD.showAdded(to: self.view, animated: true) : nil
        hud?.label.text = NSLocalizedString("Loading...", comment: "")
        self.refreshControl.beginRefreshing()
        self.tableView.setContentOffset(CGPoint(x: 0, y: self.tableView.contentOffset.y - self.refreshControl.bounds.height), animated: true)

        TicketDataController.shared.loadTickets(account: AccountController.shared.selectedAccount) { (tickets: [Ticket], error: Error?) in
            self.refreshControl.endRefreshing()
            hud?.hide(animated: true)
            if let error = error {
                self.showAlertMessage(with: error)
                return
            }

            self.tickets = tickets.sorted { $0.timestamp ?? 0 > $1.timestamp ?? 0 }
        }
    }

    @IBAction func createTicket(_ sender: Any) {
        let ticketFormVC: TicketFormViewController = UIStoryboard(name: TimeSelfCareStoryboard.support.filename, bundle: nil).instantiateViewController()
        self.presentNavigation(ticketFormVC, animated: true)
    }
}

extension TicketListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tickets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TicketCell") as? TicketCell else {
            return UITableViewCell()
        }
        cell.configure(with: self.tickets[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ticketDetailVC: TicketDetailViewController = UIStoryboard(name: TimeSelfCareStoryboard.support.filename, bundle: nil).instantiateViewController()
        ticketDetailVC.ticket = self.tickets[indexPath.row]
        self.navigationController?.pushViewController(ticketDetailVC, animated: true)
    }
}
