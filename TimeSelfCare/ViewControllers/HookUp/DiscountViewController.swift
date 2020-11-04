//
//  DiscountViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 18/06/2020.
//  Copyright © 2020 Apptivity Lab. All rights reserved.
//

import UIKit

class DiscountViewController: UIViewController {

    weak var data: HUAE?
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var discountBalanceLabel: UILabel!
    @IBOutlet private weak var billDateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("DISCOUNT STATUS", comment: "")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back_arrow"), style: .done, target: self, action: #selector(self.popBack))
    }
    
    @objc
    func popBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func initView() {
        discountBalanceLabel.text = data?.discount_balance
        billDateLabel.text = data?.discount_bill_date
        tableView.reloadData()
    }
}

extension DiscountViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.discount_status_list?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "discountCell", for: indexPath) as? DiscountTableViewCell
        guard let result: [String : Any] = data?.discount_status_list?.first(where: { $0.key == String(indexPath.row) })?.value as? [String : Any] else {
            return UITableViewCell()
        }
        guard let item: DiscountStatus = DiscountStatus(with: result) else {
            return UITableViewCell()
        }
        cell?.billDateLabel.text = item.bill_date
        cell?.billNoLabel.text = item.bill_no
        cell?.amountLabel.text = item.amount
        return cell ?? UITableViewCell()
    }
}
