//
//  WifiConfigurationViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 02/03/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import UIKit
import HwMobileSDK

class WifiConfigurationViewController: UIViewController {
    
    @IBOutlet weak var liveChatView: ExpandableLiveChatView!
    @IBOutlet weak var liveChatConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var familyName: UILabel!
    var gateway: HwUserBindedGateway?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.liveChatView.isHidden = false
        
        self.title = NSLocalizedString("PARENTAL CONTROLS", comment: "")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back_arrow"), style: .done, target: self, action: #selector(self.dismissVC(_:)))
        
        familyName.text = gateway?.gatewayNickname
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.liveChatView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.liveChatView.isHidden = false
        HuaweiHelper.shared.queryUserBindGateway { gateways in
            if !gateways.isEmpty {
                self.gateway = gateways.first
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if liveChatView.isExpand {
            liveChatConstraint.constant = 0
        } else {
            liveChatConstraint.constant = -125
        }
    }
    
    @IBAction func actConnectedWifi(_ sender: Any) {
        if let connectedWifiVC = UIStoryboard(name: TimeSelfCareStoryboard.wificonfiguration.filename, bundle: nil).instantiateViewController(withIdentifier: "ConnectedWifiViewController") as? ConnectedWifiViewController {
            connectedWifiVC.gateway = self.gateway
            self.navigationController?.pushViewController(connectedWifiVC, animated: true)
        }
    }
    
    @IBAction func actWifiSettings(_ sender: Any) {
        if let wifiSettingsVC = UIStoryboard(name: TimeSelfCareStoryboard.wificonfiguration.filename, bundle: nil).instantiateViewController(withIdentifier: "WifiSettingsViewController") as? WifiSettingsViewController {
            self.navigationController?.pushViewController(wifiSettingsVC, animated: true)
        }
    }
}
