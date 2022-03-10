//
//  BillingPopUp.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 10/03/2022.
//  Copyright © 2022 Apptivity Lab. All rights reserved.
//

import UIKit

class BillingPopUpViewController: PopUpViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func actDismiss(_ sender: Any) {
        self.hideAnimate {}
    }

}
