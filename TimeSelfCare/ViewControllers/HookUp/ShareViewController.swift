//
//  ShareViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 17/06/2020.
//  Copyright © 2020 Apptivity Lab. All rights reserved.
//

import UIKit

class ShareViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func share() {
        let items = ["Sign up for the TIME Fibre Home Broadband 500Mbps plan and pay just RM99 for the first 3 months! Get started now at huae.time.com.my/?2735036"]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }

    @IBAction func actShare(_ sender: Any) {
        share()
    }
}
