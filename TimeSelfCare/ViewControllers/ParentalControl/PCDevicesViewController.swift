//
//  PCDevicesViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 22/02/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import UIKit
import HwMobileSDK
import MBProgressHUD

protocol PCDevicesViewControllerDelegate {
    func selected(devices: [HwLanDevice])
}

class PCDevicesViewController: UIViewController {

    var arrDevices: [HwLanDevice] = []
    var arrDeviceTypes: [HwDeviceTypeInfo] = []
    var selectedDevices: [HwLanDevice] = []
    var delegate: PCDevicesViewControllerDelegate?
    var template: HwAttachParentControlTemplate?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var confirmView: UIControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("SELECT DEVICE(S)", comment: "")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_close_magenta"), style: .done, target: self, action: #selector(self.dismissVC(_:)))
        
        queryDevices()
        checkConfirmButton()
    }
    
    func queryDevices() {
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = NSLocalizedString("Loading...", comment: "")

        HuaweiHelper.shared.getAttachParentalControlTemplateList(completion: { tplList in
            let names = tplList.map { template -> String in template.name }
            
            HuaweiHelper.shared.getParentControlTemplateDetailList(templateNames: names, completion: { arrData in
                var macList: [[String]] = []
                
                for data in arrData.filter({ $0.name != self.template?.name }) {
                    if let macs = data.macList as? [String] {
                        macList.append(macs)
                    }
                }
                
                let controlledDev = macList.flatMap { $0 }
                
                HuaweiHelper.shared.queryLanDeviceListEx { devices in
                    self.arrDevices = devices.filter { !$0.isAp }
                    self.arrDevices = self.arrDevices.filter { !controlledDev.contains($0.mac) }
                    self.arrDevices = self.arrDevices.sorted { $0.onLine && !$1.onLine }
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
                }
                
                hud.hide(animated: true)
            }, error: { exception in
                hud.hide(animated: true)
                self.showAlertMessage(message: HuaweiHelper.shared.mapErrorMsg(exception?.errorCode ?? ""), actions: [
                    UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default) { _ in
                        self.dismissVC()
                    }
                ])
            })
            
        }, error: { exception in
            hud.hide(animated: true)
            self.showAlertMessage(message: HuaweiHelper.shared.mapErrorMsg(exception?.errorCode ?? ""), actions: [
                UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default) { _ in
                    self.dismissVC()
                }
            ])
        })
        
//        HuaweiHelper.shared.getAttachParentControlList(completion: { arrAttachPC in
//            hud.hide(animated: true)
//            var attPC = arrAttachPC
//            if self.template != nil {
//                attPC = attPC.filter { $0.templateName != self.template?.name }
//            }
//            let controlledDev = attPC.map { $0.mac }
//
//            HuaweiHelper.shared.queryLanDeviceListEx { devices in
//                self.arrDevices = devices.filter { !$0.isAp }
//                self.arrDevices = self.arrDevices.filter { !controlledDev.contains($0.mac) }
//                self.arrDevices = self.arrDevices.sorted { $0.onLine && !$1.onLine }
//                self.tableView.reloadData()
//
//                let arrMac = self.arrDevices.map { $0.mac }
//                if let macList = arrMac as? [String] {
//                    HuaweiHelper.shared.queryLanDeviceManufacturingInfoList(macList: macList) { deviceTypeInfo in
//                        self.arrDeviceTypes = deviceTypeInfo
//                        self.tableView.reloadData()
//                    }
//                } else {
//                    self.tableView.reloadData()
//                }
//            }
//        }, error: { exception in
//            hud.hide(animated: true)
//            self.showAlertMessage(message: HuaweiHelper.shared.mapErrorMsg(exception?.errorCode ?? ""), actions: [
//                UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default) { _ in
//                    self.dismissVC()
//                }
//            ])
//        })
    }
    
    func checkConfirmButton() {
        if selectedDevices.isEmpty {
            confirmView.backgroundColor = UIColor(hex: "C6C6C6")
            confirmView.isUserInteractionEnabled = false
        } else {
            confirmView.backgroundColor = .primary
            confirmView.isUserInteractionEnabled = true
        }
    }
    
    @IBAction func actConfirm(_ sender: Any) {
        self.dismissVC()
        delegate?.selected(devices: selectedDevices)
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
        cell?.setDeviceImg(device: deviceType?.deviceType ?? "", isOnline: device.onLine)
        cell?.selectionStyle = .none
        
        cell?.setChosen(chosen: selectedDevices.contains { $0.mac == device.mac })

        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? PCDeviceTableViewCell
        
        let device = arrDevices[indexPath.row]
        let chosenIndex = selectedDevices.firstIndex(where: { $0.mac == device.mac }) ?? -1
        
        if chosenIndex >= 0 {
            selectedDevices.remove(at: chosenIndex)
            cell?.setChosen(chosen: false)
        } else {
            selectedDevices.append(device)
            cell?.setChosen(chosen: true)
        }
        
        checkConfirmButton()

    }
}
