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
    @IBOutlet weak var noApFound: UIControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAPList()

        self.title = NSLocalizedString("DEVICE INSTALLATION", comment: "")

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
            self.tableView.reloadData()
            
            if !self.apDevices.isEmpty {
                self.noApFound.isHidden = true
                self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back_arrow"), style: .done, target: self, action: #selector(self.dismissVC(_:)))
                let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
                spacer.width = 10
                self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: #imageLiteral(resourceName: "ic_add"), style: .done, target: self, action: #selector(self.goToAddDevice)), spacer]
            } else {
                self.noApFound.isHidden = false
                self.navigationItem.rightBarButtonItems = []
            }
//            for apDevice in self.apDevices {
//                print(apDevice.mac)
//                HuaweiHelper.shared.removeOfflineDevList(lanMac: apDevice.mac, completion: { _ in
//                    print("Device reset")
//                }, error: { exception in
//                    print(exception?.errorCode ?? "")
//                    print(exception?.errorMessage ?? "")
//                })
//            }
        }
    }

    @IBAction func goToAddDeviceList(_ sender: Any) {
        goToAddDevice()
    }
    
    @objc
    func goToAddDevice() {
        HuaweiHelper.shared.getWifiInfoAll(completion: { wifiInfoAll in
            if wifiInfoAll.hardwareSwitch2p4G == "true" || wifiInfoAll.hardwareSwitch5G == "true" {
                if let vc = UIStoryboard(name: TimeSelfCareStoryboard.deviceinstallation.filename, bundle: nil).instantiateViewController(withIdentifier: "AddDeviceListViewController") as? AddDeviceListViewController {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                if let vc = UIStoryboard(name: TimeSelfCareStoryboard.deviceinstallation.filename, bundle: nil).instantiateViewController(withIdentifier: "WifiDisableViewController") as? WifiDisableViewController {
                    vc.delegate = self
                    self.presentNavigation(vc, animated: true)
                }
            }
        }, error: { _ in })
    }
}

extension DeviceInstallationListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.apDevices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "apDeviceCell", for: indexPath) as? ApDeviceTableViewCell
        let ap = self.apDevices[indexPath.row]
        cell?.apImage.image = UIImage(named: ap.name)
        cell?.apName.text = ap.name
        cell?.lanMac.text = "MAC:\(ap.lanMac ?? "-")"
        cell?.dateAndTime.text = ap.onLine ? Date(timeIntervalSinceNow: TimeInterval(ap.onlineTime)).string(usingFormat: "dd/MM/YYYY HH:mm") : ""
        return cell ?? UITableViewCell()
    }
}

extension DeviceInstallationListViewController: WifiDisableViewControllerDelegate {
    func wifiEnabled() {
        if let vc = UIStoryboard(name: TimeSelfCareStoryboard.deviceinstallation.filename, bundle: nil).instantiateViewController(withIdentifier: "AddDeviceListViewController") as? AddDeviceListViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
