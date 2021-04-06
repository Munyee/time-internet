//
//  DeviceInstallationListViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 05/04/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import UIKit
import HwMobileSDK

class DeviceInstallationListViewController: UIViewController {

    var refreshControl = UIRefreshControl()
    var apDevices: [HwLanDevice] = []

    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAPList()

        self.title = NSLocalizedString("DEVICE INSTALLATION", comment: "")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back_arrow"), style: .done, target: self, action: #selector(self.dismissVC(_:)))
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer.width = 10
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.getAPList), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc
    func getAPList() {
        fetchAPList()
    }
    
    func fetchAPList() {
        HuaweiHelper.shared.queryLanDeviceListEx { devices in
            self.refreshControl.endRefreshing()
            self.apDevices = devices.filter { $0.isAp }
            for apDevice in self.apDevices {
                print(apDevice.mac)
                HuaweiHelper.shared.removeOfflineDevList(lanMac: apDevice.mac, completion: { _ in
                    print("Device reset")
                }, error: { exception in
                    print(exception?.errorCode ?? "")
                    print(exception?.errorMessage ?? "")
                })
            }
        }
    }

    @IBAction func goToAddDeviceList(_ sender: Any) {
        if let vc = UIStoryboard(name: TimeSelfCareStoryboard.deviceinstallation.filename, bundle: nil).instantiateViewController(withIdentifier: "AddDeviceListViewController") as? AddDeviceListViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
