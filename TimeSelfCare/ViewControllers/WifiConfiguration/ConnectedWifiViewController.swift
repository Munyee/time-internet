//
//  ConnectedWifiViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 02/03/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import UIKit
import HwMobileSDK

class ConnectedWifiViewController: UIViewController {

    @IBOutlet weak var familyName: UILabel!
    var gateway: HwUserBindedGateway?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("CONNECTED WIFI", comment: "")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back_arrow"), style: .done, target: self, action: #selector(self.popBack))
        familyName.text = gateway?.gatewayNickname
    }
    
    @objc
    func popBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actChangeNetwork(_ sender: Any) {
        if let changeWifiVC = UIStoryboard(name: TimeSelfCareStoryboard.wificonfiguration.filename, bundle: nil).instantiateViewController(withIdentifier: "ChangeWifiViewController") as? ChangeWifiViewController {
            changeWifiVC.oldGatewayId = gateway?.deviceId
            changeWifiVC.delegate = self
            self.presentNavigation(changeWifiVC, animated: true)
        }
    }
}

extension ConnectedWifiViewController: ChangeWifiViewControllerDelegate {
    func changeSuccess() {
        self.popBack()
    }
}
