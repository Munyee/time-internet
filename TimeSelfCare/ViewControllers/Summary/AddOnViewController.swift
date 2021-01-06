//
//  AddOnViewController.swift
//  TimeSelfCare
//
//  Created by Loka on 21/11/2017.
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import UIKit

class AddOnViewController: BaseViewController {
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        return refreshControl
    }()

    private var addOns: [AddOn] = []

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var placeHolderView: UIStackView!
    @IBOutlet private weak var addOnsButton: UIButton!
    @IBOutlet weak var shopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("ADD ONS", comment: "ADD ONS")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back_arrow"), style: .plain, target: self, action: #selector(self.back))

        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.addSubview(self.refreshControl)
    }

    @objc
    func back() {
        self.dismissVC()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addOnsButton.isHidden = AccountController.shared.selectedAccount?.custSegment == .business ||
            (AccountController.shared.selectedAccount?.custSegment == .astro && AccountController.shared.selectedAccount?.services.filter { $0.category == .broadbandAstro }.count ?? 0 > 0)
        self.shopButton.addTarget(self, action: #selector(self.openShop), for: .touchUpInside)
        self.view.bringSubviewToFront(self.shopButton)
        self.refresh()
    }

    @objc
    private func refresh() {
        AddOnDataController.shared.loadAddOns(profile: AccountController.shared.profile, account: AccountController.shared.selectedAccount) { addOns, error in
            self.refreshControl.endRefreshing()
            if let error = error {
                self.showAlertMessage(with: error)
                return
            }
            self.updateDataSet(items: addOns)
        }
    }

    override func updateUI() {
        self.tableView.reloadData()
        self.placeHolderView.isHidden = !self.addOns.isEmpty
        self.tableView.isHidden = !self.placeHolderView.isHidden
    }

    func updateDataSet(items: [AddOn]?) {
        self.addOns = AddOnDataController.shared.getAddOns(account: AccountController.shared.selectedAccount)
        self.updateUI()
    }

    @IBAction func viewAdditionalAddOns(_ sender: Any) {
        openURL(withURLString: "https://selfcare.time.com.my/user/service_info/")
    }
}

extension AddOnViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.addOns.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddOnCell") as? AddOnCell else {
            return UITableViewCell()
        }
        cell.configure(with: self.addOns[indexPath.row])
        cell.displayRowUnderline(with: indexPath.row, arrayList: self.addOns)
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "AddOnDetailViewController") as? AddOnDetailViewController {
            detailVC.addOn = self.addOns[indexPath.row]
            self.presentNavigation(detailVC, animated: true)
        }
    }
    
    @objc
    func openShop() {
        let shopVC: ShopViewController = UIStoryboard(name: TimeSelfCareStoryboard.shop.filename, bundle: nil).instantiateViewController()
        self.presentNavigation(shopVC, animated: true)
    }
}
