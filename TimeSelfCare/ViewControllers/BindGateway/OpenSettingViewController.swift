//
//  OpenSettingViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 01/03/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import UIKit

class OpenSettingViewController: TimeBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_close_magenta"), style: .done, target: self, action: #selector(self.dismissVC(_:)))
    }
    
    @IBAction func actOpenSetting(_ sender: Any) {
        if let url = URL(string:UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
    
}
