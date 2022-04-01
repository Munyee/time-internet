//
//  AddBlacklistViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 26/04/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import UIKit
import HwMobileSDK
import FirebaseCrashlytics

protocol AddBlacklistViewControllerDelegate {
    func selected(devices: [HwLanDevice])
}

class AddBlacklistViewController: UIViewController {

    @IBOutlet private weak var confirmView: UIControl!
    @IBOutlet private weak var tableView: UITableView!
    
    var arrDevices: [HwLanDevice] = []
    var arrDeviceTypes: [HwDeviceTypeInfo] = []
    var selectedDevices: [HwLanDevice] = []
    var exDevices: [HwLanDevice] = []

    var delegate: AddBlacklistViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("BLACKLIST", comment: "")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_close_magenta"), style: .done, target: self, action: #selector(self.dismissVC(_:)))
        
        queryDevices()
        checkConfirmButton()
        exDevices = selectedDevices
    }

    func queryDevices() {
        
        let hud = LoadingView().addLoading(toView: self.view)
        hud.showLoading()
        
        HuaweiHelper.shared.queryLanDeviceListEx { devices in
            hud.hideLoading()
            self.arrDevices = devices.filter { !$0.isAp }
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
        } error: { exception in
            DispatchQueue.main.async {
                hud.hideLoading()
                self.showAlertMessage(message: HuaweiHelper.shared.mapErrorMsg(exception?.errorCode ?? ""))
            }
        }
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
        let hud = LoadingView().addLoading(toView: self.view)
        hud.showLoading()
        
        exDevices = self.exDevices.filter { !selectedDevices.contains($0) }
        
        var keysAndValues = [:] as [String : Any]
        
        for (index, device) in selectedDevices.map { item -> String in
            item.mac
        }.enumerated() {
            
            keysAndValues["selected device-\(index)"] = device
        }
        
        for (index, device) in exDevices.map { item -> String in
            item.mac
        }.enumerated() {
            
            keysAndValues["remove device-\(index)"] = device
        }
        
        Crashlytics.crashlytics().setCustomKeysAndValues(keysAndValues)

        HuaweiHelper.shared.setLanDeviceToBlackList(list: selectedDevices, isAdd: true, completion: { _ in
            if self.exDevices.isEmpty {
                hud.hideLoading()
                self.tableView.delegate = nil
                self.dismissVC()
                self.delegate?.selected(devices: self.selectedDevices)
            } else {
                HuaweiHelper.shared.setLanDeviceToBlackList(list: self.exDevices, isAdd: false, completion: { _ in
                    self.tableView.delegate = nil
                    self.dismissVC()
                    self.delegate?.selected(devices: self.selectedDevices)
                    hud.hideLoading()
                }, error: { _ in
                    hud.hideLoading()
                })
            }
        }, error: { _ in
            hud.hideLoading()
        })
        
    }
}

extension AddBlacklistViewController: UITableViewDelegate, UITableViewDataSource {
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

