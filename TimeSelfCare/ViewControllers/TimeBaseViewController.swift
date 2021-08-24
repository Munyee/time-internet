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
    
    func setupToHideKeyboardOnTapOnView() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

class TimeBaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
}
