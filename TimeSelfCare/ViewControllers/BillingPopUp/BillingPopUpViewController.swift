//
//  BillingPopUp.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 10/03/2022.
//  Copyright © 2022 Apptivity Lab. All rights reserved.
//

import UIKit

class BillingPopUpViewController: PopUpViewController {
    
    var pdf_url: String?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func actDismiss(_ sender: Any) {
        self.hideAnimate {}
    }
    
    @IBAction func actCheckItOut(_ sender: Any) {
        self.hideAnimate {}
        guard
            let urlString = pdf_url ,
            let url = URL(string: urlString)
        else {
                return
        }

        let timeWebView = TIMEWebViewController()
        timeWebView.url = url
        timeWebView.title = NSLocalizedString("Bills", comment: "")
        self.parent?.presentNavigation(timeWebView, animated: true)
    }
}
