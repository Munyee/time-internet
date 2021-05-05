//
//  WifiDisableViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 09/04/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import UIKit
import HwMobileSDK
import MBProgressHUD

protocol WifiDisableViewControllerDelegate {
    func wifiEnabled()
}

class WifiDisableViewController: UIViewController {

    var delegate: WifiDisableViewControllerDelegate?
    var wifiInfos: [HwWifiInfo?] = []

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
        
        let group = DispatchGroup()
        group.enter()
        HuaweiHelper.shared.enableWifiHardwareSwitch(radioType: "2.4G", completion: { _ in
            group.leave()
        }, error: { _ in hud.hide(animated: true) })
        
        group.enter()
        HuaweiHelper.shared.enableWifiHardwareSwitch(radioType: "5G", completion: { _ in
            group.leave()
        }, error: { _ in hud.hide(animated: true) })
        
        if let dataInfos = wifiInfos as? [HwWifiInfo] {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.label.text = NSLocalizedString("Loading...", comment: "")
            
            let sortedArr = dataInfos.sorted(by: { (wifiInfoA, wifiInfoB) -> Bool in
                return "\(wifiInfoA.ssidIndex)".compare("\(wifiInfoB.ssidIndex)", options: .numeric) == .orderedAscending
            })
            
            sortedArr.first(where: {$0.radioType == "2.4G"})?.enable = true
            sortedArr.first(where: {$0.radioType == "5G"})?.enable = true
            
            group.enter()
            HuaweiHelper.shared.setWifiInfoList(wifiInfos: dataInfos, completion: { _ in
                group.leave()
            }, error: { _ in
                hud.hide(animated: true)
            })
        }
        
        group.notify(queue: .main) {
            hud.hide(animated: true)
            self.dismiss(animated: true) {
                self.delegate?.wifiEnabled()
            }
            
        }
    }
}
