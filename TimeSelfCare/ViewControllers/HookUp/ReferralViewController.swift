//
//  ReferralViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 18/06/2020.
//  Copyright © 2020 Apptivity Lab. All rights reserved.
//

import UIKit

class ReferralViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isHidden = true
        // Do any additional setup after loading the view.
    }
}

extension ReferralViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "referralCell", for: indexPath) as? ReferralTableViewCell
        cell?.nameLabel.text = "Test User"
        cell?.statusLabel.text = "Activated"
        cell?.signUpDateLabel.text = "20 May 2020"
        cell?.activationDateLabel.text = "01 June 2020"
        return cell ?? UITableViewCell()
    }
}

extension ReferralViewController: UITableViewDelegate {

}
