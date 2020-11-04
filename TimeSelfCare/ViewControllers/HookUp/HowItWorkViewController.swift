//
//  HowItWorkViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 17/06/2020.
//  Copyright © 2020 Apptivity Lab. All rights reserved.
//

import UIKit

class HowItWorkViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func showTnc() {
        let timeWebView = TIMEWebViewController()
        let urlString = "https://www.time.com.my/terms-and-conditions?link=personal&title=HookUpAndEarn"
        let url = URL(string: urlString)
        timeWebView.url = url
        timeWebView.title = NSLocalizedString("Terms & Conditions", comment: "")
        self.navigationController?.pushViewController(timeWebView, animated: true)
    }

    func showFAQ() {
        let timeWebView = TIMEWebViewController()
        let urlString = "http://www1.time.com.my/support/faq?section=self-care&question=who-is-eligible-for-this-programme"
        let url = URL(string: urlString)
        timeWebView.url = url
        timeWebView.title = NSLocalizedString("FAQ", comment: "")
        self.navigationController?.pushViewController(timeWebView, animated: true)
    }
//
    @IBAction func actTnC(_ sender: Any) {
        showTnc()
    }

    @IBAction func actFAQ(_ sender: Any) {
        showFAQ()
    }
}
