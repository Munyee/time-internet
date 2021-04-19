//
//  WifiDisableViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 09/04/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol WifiDisableViewControllerDelegate {
    func wifiEnabled()
}

class WifiDisableViewController: UIViewController {

    var delegate: WifiDisableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("DEVICE INSTALLATION", comment: "")
    }

    @IBAction func actBacktoHome(_ sender: Any) {
        self.dismissVC()
    }
    
    @IBAction func actEnableWifi(_ sender: Any) {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = NSLocalizedString("Loading...", comment: "")

        hud.show(animated: true)
        HuaweiHelper.shared.enableWifiHardwareSwitch(radioType: "2.4G", completion: { _ in
            HuaweiHelper.shared.enableWifiHardwareSwitch(radioType: "5G", completion: { _ in
                hud.hide(animated: true)
                self.dismiss(animated: true) {
                    self.delegate?.wifiEnabled()
                }
            }, error: { _ in hud.hide(animated: true) })
        }, error: { _ in hud.hide(animated: true) })
    }
}
