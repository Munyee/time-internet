//
//  BlacklistViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 19/04/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import UIKit
import HwMobileSDK
import MBProgressHUD

class BlacklistViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addView: UIControl!

    var arrDevices: [HwLanDevice] = []
    var arrDeviceTypes: [HwDeviceTypeInfo] = []
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("BLACKLIST", comment: "")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back_arrow"), style: .done, target: self, action: #selector(self.popBack))
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.queryBlackList), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc
    func popBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        queryBlackList()
    }
    
    @objc
    func queryBlackList() {
        HuaweiHelper.shared.getLanDeviceBlackList(completion: { devices in
            
            self.arrDevices = devices.filter { !$0.isAp }
            self.arrDevices = self.arrDevices.sorted { $0.onLine && !$1.onLine }
            
            let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            spacer.width = 10
            self.navigationItem.rightBarButtonItems = nil

            if self.arrDevices.isEmpty {
                self.addView.isHidden = false
            } else {
                self.addView.isHidden = true
                self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: #imageLiteral(resourceName: "ic_add"), style: .done, target: self, action: #selector(self.goToBlacklist)), spacer]
            }
            
            self.tableView.reloadData()
            
            let arrMac = self.arrDevices.map { $0.mac }
            if let macList = arrMac as? [String] {
                HuaweiHelper.shared.queryLanDeviceManufacturingInfoList(macList: macList) { deviceTypeInfo in
                    self.arrDeviceTypes = deviceTypeInfo
                    self.tableView.reloadData()
                }
            } else {
                self.tableView.reloadData()
            }
            
            self.refreshControl.endRefreshing()
        }, error: { _ in
            
        })
    }
    
    @IBAction func actAddBlacklist(_ sender: Any) {
        goToBlacklist()
    }
    
    @objc
    func goToBlacklist() {
        if let devicesVC = UIStoryboard(name: TimeSelfCareStoryboard.blacklist.filename, bundle: nil).instantiateViewController(withIdentifier: "AddBlacklistViewController") as? AddBlacklistViewController {
            devicesVC.delegate = self
            devicesVC.selectedDevices = self.arrDevices
            self.presentNavigation(devicesVC, animated: true)
        }
    }
}

extension BlacklistViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.arrDevices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "deviceCell", for: indexPath) as? PCDeviceTableViewCell
        let device = arrDevices[indexPath.row]
        let deviceType = arrDeviceTypes.first { $0.mac == device.mac }
        cell?.name.text = device.name != "" ? device.name : device.mac
        cell?.mac.text = device.mac
        cell?.setDeviceImg(device: deviceType?.deviceType ?? "", isOnline: device.onLine)
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let device = arrDevices[indexPath.row]
            self.showAlertMessage(
                title: NSLocalizedString("Remove device", comment: ""),
                message: NSLocalizedString("Are you sure you want to remove this device from the blacklist?", comment: ""),
                actions: [
                    UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .destructive) { _ in
                        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                        hud.label.text = NSLocalizedString("Loading...", comment: "")
                        
                        HuaweiHelper.shared.deleteLanDeviceFromBlackList(lanDevice: device, completion: { _ in
                            self.queryBlackList()
                            hud.hide(animated: true)
                        }, error: { _ in
                            hud.hide(animated: true)
                        })
                    },
                    UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .cancel, handler: nil)])
        }
    }
}

extension BlacklistViewController: AddBlacklistViewControllerDelegate {
    func selected(devices: [HwLanDevice]) {
         
    }
}
