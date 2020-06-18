//
//  DiscountViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 18/06/2020.
//  Copyright © 2020 Apptivity Lab. All rights reserved.
//

import UIKit

class DiscountViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isHidden = true
        // Do any additional setup after loading the view.
    }
}

extension DiscountViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "discountCell", for: indexPath) as? DiscountTableViewCell
        cell?.billDateLabel.text = "15 Jun 2020"
        cell?.billNoLabel.text = "TIME1506202002"
        cell?.amountLabel.text = "RM199.00"
        return cell ?? UITableViewCell()
    }
}
