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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var discountBalanceLabel: UILabel!
    @IBOutlet weak var billDateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    func initView() {
        if data?.referral_status_list?.isEmpty == false {
            tableView.isHidden = false
        }
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
