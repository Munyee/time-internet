//
//  HomeForwardListViewController.swift
//  TimeSelfCare
//
//  Created by Loka on 06/12/2017.
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import UIKit

internal class HomeForwardListViewController: TimeBaseViewController {
    var services: [Service] = []

    @IBOutlet private weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Home Forward", comment: "")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: ""), style: .plain, target: self, action: #selector(self.back))
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateDataSet()
    }

    func updateDataSet() {
        self.services = ServiceDataController.shared.getServices(account: AccountController.shared.selectedAccount).filter { $0.category == Service.Category.voice && ($0.isThf ?? false) }
    }

    @objc
    func back() {
        self.tableView.delegate = nil
        self.dismissVC()
    }
}

extension HomeForwardListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.services.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeForwardCell") as? HomeForwardCell else {
            return UITableViewCell()
        }
        cell.configure(with: self.services[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Summary", bundle: nil)
        if let homeForwardDetailVC = storyboard.instantiateViewController(withIdentifier: "HomeForwardDetailViewController") as? HomeForwardDetailViewController {
            homeForwardDetailVC.service = self.services[indexPath.row]
            self.show(homeForwardDetailVC, sender: nil)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
