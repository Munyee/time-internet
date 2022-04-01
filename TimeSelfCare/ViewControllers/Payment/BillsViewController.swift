//
//  InvoicesViewController.swift
//  TimeSelfCare
//
//  Created by Loka on 04/12/2017.
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import UIKit

internal class BillsViewController: TimeBaseViewController {
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        return refreshControl
    }()

    private var bills: [Bill] = [] {
        didSet {
            self.tableView.reloadData()
            self.emptyStateLabel.isHidden = !bills.isEmpty
        }
    }

    @IBOutlet private weak var emptyStateLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var liveChatConstraint: NSLayoutConstraint!
    @IBOutlet weak var liveChatView: ExpandableLiveChatView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("BILLS", comment: "BILLS")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back_arrow"), style: .plain, target: self, action: #selector(self.back))

        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.addSubview(self.refreshControl)
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
        self.refresh()
    }

    @objc
    func back() {
        self.tableView.delegate = nil
        self.dismissVC()
    }

    @objc
    func refresh() {
        self.refreshControl.beginRefreshing()
        BillDataController.shared.loadPastBills(account: AccountController.shared.selectedAccount) { (_: [Bill], error: Error?) in
            self.refreshControl.endRefreshing()

            if let error = error {
                self.showAlertMessage(with: error)
                return
            }
            self.updateDataSet()
        }
    }

    func updateDataSet() {
        let bills = BillDataController.shared.getBills(account: AccountController.shared.selectedAccount).sorted { previousBill, nextBill -> Bool in
            guard let previousBillDate = previousBill.invoiceDate,
                let nextBillDate = nextBill.invoiceDate else {
                    return false
            }
            return nextBillDate < previousBillDate
        }

        // Only show bills from 4 months ago.
        let calendar = Calendar(identifier: .gregorian)
        let currentDate = Date()
        let cutoffDate = calendar.date(byAdding: .month, value: -4, to: calendar.date(bySetting: .day, value: 1, of: currentDate)!)

        let filteredBills = bills.filter { bill -> Bool in
            guard let invoiceDate = bill.invoiceDate,
                let cutoffDate = cutoffDate else {
                    return false
            }
            return invoiceDate >= cutoffDate
        }

        self.bills = filteredBills
    }

    func showBill(with bill: Bill) {
        guard
            let urlString = bill.pdf ,
            let url = URL(string: urlString),
            AccountController.shared.selectedAccount?.showBill ?? false
        else {
                return
        }

        let timeWebView = TIMEWebViewController()
        timeWebView.url = url
        timeWebView.title = NSLocalizedString("Bills", comment: "")
        self.navigationController?.pushViewController(timeWebView, animated: true)
    }
}

extension BillsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bills.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceCell") as? InvoiceCell else {
            return UITableViewCell()
        }
        cell.configureCell(with: self.bills[indexPath.row])
        let shouldShowBill: Bool = AccountController.shared.selectedAccount?.showBill ?? false
       // cell.accessoryView = shouldShowBill ? UIImageView(image: #imageLiteral(resourceName: "ic_next_arrow_black")) : nil
        
        if indexPath.row == self.bills.count - 1 {
            cell.rowDividerLabel.backgroundColor = .white
        } else {
            cell.rowDividerLabel.backgroundColor = .lightGray
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.showBill(with: self.bills[indexPath.row])
    }
}
