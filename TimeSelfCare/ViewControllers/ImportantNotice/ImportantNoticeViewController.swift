//
//  ImportantNoticeViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 17/02/2022.
//  Copyright © 2022 Apptivity Lab. All rights reserved.
//

import UIKit

class ImportantNoticeViewController: PopUpViewController {

    var desc = ""

    @IBOutlet weak var descLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descLabel.attributedText = desc.htmlAttributdString()
    }
    
    @IBAction func actDismiss(_ sender: Any) {
        self.hideAnimate {}
    }

}
