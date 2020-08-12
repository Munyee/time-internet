//
//  ReferralViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 18/06/2020.
//  Copyright © 2020 Apptivity Lab. All rights reserved.
//

import UIKit

class ReferralViewController: UIViewController {

    weak var data: HUAE?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isHidden = true
        
        initView()
        // Do any additional setup after loading the view.
    }
    
     func initView() {
        if data?.referral_status_list?.isEmpty == false {
            tableView.isHidden = false
        }
        tableView.reloadData()
    }
}

extension ReferralViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.referral_status_list?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "referralCell", for: indexPath) as? ReferralTableViewCell
        guard let result: [String : Any] = data?.referral_status_list?.first(where: { $0.key == String(indexPath.row) })?.value as? [String : Any] else {
            return UITableViewCell()
        }
        guard let item: ReferralStatus = ReferralStatus(with: result) else {
            return UITableViewCell()
        }
        cell?.nameLabel.text = item.name
        cell?.statusLabel.text = item.status
        cell?.signUpDateLabel.text = item.signup_date
        cell?.activationDateLabel.text = item.activation_date
        return cell ?? UITableViewCell()
    }
}

extension ReferralViewController: UITableViewDelegate {

}
