//
//  NoticePopUpViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 21/02/2022.
//  Copyright © 2022 Apptivity Lab. All rights reserved.
//

import UIKit

class NoticePopUpViewController: PopUpViewController {

    var noticePopUp: NoticePopUp = NoticePopUp()

    @IBOutlet weak var descLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descLabel.attributedText = noticePopUp.desc.htmlAttributdString()
        descLabel.textAlignment = .center
    }
    
    @IBAction func actDismiss(_ sender: Any) {
        self.hideAnimate {
            UserDefaults.standard.set(self.noticePopUp.ver, forKey: MaintenanceMode.NOTICE_POPUP_VERSION)
        }
    }
}
