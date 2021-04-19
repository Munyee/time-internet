//
//  BlacklistViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 19/04/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import UIKit

class BlacklistViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("BLACKLIST", comment: "")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back_arrow"), style: .done, target: self, action: #selector(self.popBack))
    }
    
    @objc
    func popBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actAddBlacklist(_ sender: Any) {
    }

}
