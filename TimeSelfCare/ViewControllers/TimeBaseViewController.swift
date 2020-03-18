//
//  BaseViewController.swift
//  TimeSelfCare
//
//  Created by AppLab on 20/12/2017.
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import Foundation
import UserNotifications

extension UIViewController {
    func openURL(_ url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    func openURL(withURLString urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        openURL(url)
    }
}

class TimeBaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
}
