//
//  PCDevicesViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 22/02/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import UIKit
import HwMobileSDK

class PCDevicesViewController: UIViewController {

    var arrDevices: [HwLanDevice] = []
    var arrDeviceTypes: [HwDeviceTypeInfo] = []
    var selectedDevices: [HwLanDevice] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("SELECT DEVICE(S)", comment: "")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_close_magenta"), style: .done, target: self, action: #selector(self.dismissVC(_:)))
        
        queryDevices()
    }
    
    func queryDevices() {
        HuaweiHelper.shared.queryLanDeviceListEx { devices in
            self.arrDevices = devices.filter { !$0.isAp }
            self.arrDevices = self.arrDevices.sorted { $0.onLine && !$1.onLine }
            
            
            let arrMac = self.arrDevices.map { $0.mac }
            if let macList = arrMac as? [String] {
                HuaweiHelper.shared.queryLanDeviceManufacturingInfoList(macList: macList) { deviceTypeInfo in
                    self.arrDeviceTypes = deviceTypeInfo
                }
            }
            
            self.tableView.reloadData()
        }
    }

}

extension PCDevicesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.arrDevices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "deviceCell", for: indexPath) as? PCDeviceTableViewCell
        let device = arrDevices[indexPath.row]
        let deviceType = arrDeviceTypes.first { $0.mac == device.mac }
        cell?.name.text = device.name
        cell?.mac.text = device.mac
        cell?.selectionStyle = .none
        
        cell?.setChosen(chosen: selectedDevices.contains { $0.mac == device.mac })

        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? PCDeviceTableViewCell
        
        let device = arrDevices[indexPath.row]
        let chosenIndex = selectedDevices.index(of: device) ?? -1
        
        if chosenIndex >= 0 {
            selectedDevices.remove(at: chosenIndex)
            cell?.setChosen(chosen: false)
        } else {
            selectedDevices.append(device)
            cell?.setChosen(chosen: true)
        }

    }
}
