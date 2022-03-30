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

        self.title = NSLocalizedString("DEVICE INSTALLATION", comment: "")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back_arrow"), style: .done, target: self, action: #selector(self.dismissVC(_:)))
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.getAPList), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchAPList()
    }
    
    @objc
    func getAPList() {
        fetchAPList()
    }
    
    func fetchAPList() {
        HuaweiHelper.shared.queryLanDeviceListEx { devices in
            self.refreshControl.endRefreshing()
            self.apDevices = devices.filter { $0.isAp }.sorted(by: { (devA, devB) -> Bool in
                return devA.onLine && !devB.onLine
            })
            self.tableView.reloadData()
            
            if !self.apDevices.isEmpty {
                self.noApFound.isHidden = true
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
//                    print(exception?.description ?? "")
//                })
//            }
        } error: { exception in
            DispatchQueue.main.async {
                self.showAlertMessage(message: HuaweiHelper.shared.mapErrorMsg(exception?.errorCode ?? ""))
            }
        }
    }

    @IBAction func goToAddDeviceList(_ sender: Any) {
        goToAddDevice()
    }
    
    @objc
    func goToAddDevice() {
        let hud = LoadingView().addLoading(toView: self.view)
        hud.showLoading()
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
//        HuaweiHelper.shared.getGuestWifiInfo(completion: { guestWifi in
//            HuaweiHelper.shared.getWifiInfoAll(completion: { wifiInfoAll in
//                hud.hide(animated: true)
//                self.stackView.isHidden = false
//                self.switchDualBand.isOn = wifiInfoAll.dualbandCombine
//                self.singleBandView.isHidden = wifiInfoAll.dualbandCombine
//
//                let arrData = wifiInfoAll.infoList.filter { wifiInfo -> Bool in
//                    return wifiInfo.ssidIndex != guestWifi.ssidIndex && wifiInfo.ssidIndex != guestWifi.ssidIndex5G
//                }
//
//                let group = DispatchGroup()
//                hud.show(animated: true)
//                for infoItem in arrData {
//                    group.enter()
//                    HuaweiHelper.shared.getWifiInfo(ssidIndex: infoItem.ssidIndex, completion: { info in
//                        self.wifiInfos.append(info)
//                        group.leave()
//                    }, error: { _ -> Void in
//                        hud.hide(animated: true)
//                    })
//                }
//
//                group.notify(queue: .main) {
//                    hud.hide(animated: true)
//                    self.switchHideWifi.isOn = !self.wifiInfos.contains(where: { wifiInfo -> Bool in
//                        return wifiInfo?.isSsidAdvertisementEnabled == true
//                    })
//
//                    self.switch2p4g.isOn = self.wifiInfos.filter { $0?.radioType == "2.4G"}.contains(where: { wifiInfo -> Bool in
//                        return wifiInfo?.enable == true
//                    })
//
//                    self.switch5g.isOn = self.wifiInfos.filter { $0?.radioType == "5G"}.contains(where: { wifiInfo -> Bool in
//                        return wifiInfo?.enable == true
//                    })
//                }
//            }, error: { _ -> Void in
//                hud.hide(animated: true)
//            })
//        }, error: { _ in
//            hud.hide(animated: true)
//        })
        HuaweiHelper.shared.getGuestWifiInfo(completion: { guestWifi in
            HuaweiHelper.shared.getWifiInfoAll(completion: { wifiInfoAll in
                hud.hideLoading()
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                let arrData = wifiInfoAll.infoList.filter { wifiInfo -> Bool in
                    wifiInfo.ssidIndex != guestWifi.ssidIndex && wifiInfo.ssidIndex != guestWifi.ssidIndex5G
                }
                
                let wifi2p4gOn = arrData.filter { $0.radioType == "2.4G"}.contains(where: { wifiInfo -> Bool in
                    wifiInfo.enable == true
                })
                
                let wifi5gOn = arrData.filter { $0.radioType == "5G"}.contains(where: { wifiInfo -> Bool in
                    wifiInfo.enable == true
                })
                
                if (wifiInfoAll.hardwareSwitch2p4G == "true" || wifiInfoAll.hardwareSwitch5G == "true") && (wifi2p4gOn || wifi5gOn) {
                    if let vc = UIStoryboard(name: TimeSelfCareStoryboard.deviceinstallation.filename, bundle: nil).instantiateViewController(withIdentifier: "AddDeviceListViewController") as? AddDeviceListViewController {
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                } else {
                    if let vc = UIStoryboard(name: TimeSelfCareStoryboard.deviceinstallation.filename, bundle: nil).instantiateViewController(withIdentifier: "WifiDisableViewController") as? WifiDisableViewController {
                        vc.delegate = self
                        vc.wifiInfos = arrData
                        self.presentNavigation(vc, animated: true)
                    }
                }
            }, error: { _ in
                hud.hideLoading()
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            })
        }, error: { _ in
            hud.hideLoading()
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        })
    }
}

extension DeviceInstallationListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.apDevices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "apDeviceCell", for: indexPath) as? ApDeviceTableViewCell
        let ap = self.apDevices[indexPath.row]
        cell?.apImage.image = UIImage(named: ap.name.lowercased())
        cell?.apName.text = ap.name
        cell?.lanMac.text = "MAC:\(ap.lanMac ?? "-")"
//        cell?.dateAndTime.text = ap.onLine ? Date(timeIntervalSince1970: TimeInterval(ap.lastOnlineTime)).string(usingFormat: "dd/MM/YYYY HH:mm") : "\(Date(timeIntervalSince1970: TimeInterval(ap.lastOfflineTime)).string(usingFormat: "dd/MM/YYYY HH:mm")) Offline"
        cell?.dateAndTime.text = ap.onLine ? "Online" : "Offline"
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
