//
//  WifiSettingsViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 10/03/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import UIKit
import HwMobileSDK
import MBProgressHUD

class WifiSettingsViewController: UIViewController {
    
    @IBOutlet private weak var liveChatView: ExpandableLiveChatView!
    @IBOutlet private weak var liveChatConstraint: NSLayoutConstraint!
    
    // View
    @IBOutlet private weak var singleBandView: UIView!
    @IBOutlet private weak var schedulingView: UIView!
    @IBOutlet private weak var stackView: UIStackView!
    
    // Toggle
    @IBOutlet private weak var switchDualBand: UISwitch!
    @IBOutlet private weak var switch2p4g: UISwitch!
    @IBOutlet private weak var switch5g: UISwitch!
    @IBOutlet private weak var switchHideWifi: UISwitch!
    @IBOutlet private weak var switchScheduling: UISwitch!
    
    // Label
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var closeLabel: UILabel!
    
    var wifiInfos: [HwWifiInfo?] = []
    var timer: HwWifiTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.liveChatView.isHidden = false
        self.title = NSLocalizedString("WIFI SETTINGS", comment: "")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back_arrow"), style: .done, target: self, action: #selector(self.popBack))
    }
    
    @objc
    func popBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.liveChatView.isHidden = false
        queryAllWifi()
        queryWifiTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.liveChatView.isHidden = true
    }
    
    @IBAction func actChangeWifiName(_ sender: Any) {
        if let changeWifiNameVC = UIStoryboard(name: TimeSelfCareStoryboard.wificonfiguration.filename, bundle: nil).instantiateViewController(withIdentifier: "ChangeWifiNameViewController") as? ChangeWifiNameViewController {
            changeWifiNameVC.wifiInfos = self.wifiInfos
            changeWifiNameVC.isDualband = self.switchDualBand.isOn
            self.navigationController?.pushViewController(changeWifiNameVC, animated: true)
        }
    }
    
    @IBAction func actToggleDualBand(_ sender: UISwitch) {
        if sender.isOn {
            self.singleBandView.isHidden = true
            toggleDualBand()
        } else {
            self.showAlertMessage(title: "Are you sure?", message: "We recommend using dual-band WiFi for the best connectivity experience.", actions: [
                UIAlertAction(title: NSLocalizedString("Turn Off", comment: ""), style: .destructive) { _ in
                    self.toggleDualBand()
                    self.singleBandView.isHidden = false
                },
                UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { _ in
                    sender.isOn = true
                    self.singleBandView.isHidden = true
                }
            ])
        }
        
    }
    
    @IBAction func actWifiHetwork(_ sender: Any) {
        toggleHideWifiNetwork()
    }
    
    @IBAction func actToggle2p4g(_ sender: Any) {
        if !switch5g.isOn {
            self.showAlertMessage(title: "Are you sure?", message: "Turning both WiFi bands off will disable your network.", actions: [
                UIAlertAction(title: NSLocalizedString("Turn Off", comment: ""), style: .destructive) { _ in
                    self.toggleWifiEnabled(band: "2.4G", switchWifi: self.switch2p4g)
                },
                UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { _ in
                    self.switch2p4g.isOn = true
                }
            ])
        } else {
            toggleWifiEnabled(band: "2.4G", switchWifi: switch2p4g)
        }
    }
    
    @IBAction func actToggle5g(_ sender: Any) {
        if !switch2p4g.isOn {
            self.showAlertMessage(title: "Are you sure?", message: "Turning both WiFi bands off will disable your network.", actions: [
                UIAlertAction(title: NSLocalizedString("Turn Off", comment: ""), style: .destructive) { _ in
                    self.toggleWifiEnabled(band: "5G", switchWifi: self.switch5g)
                },
                UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { _ in
                    self.switch5g.isOn = true
                }
            ])
        } else {
            toggleWifiEnabled(band: "5G", switchWifi: switch5g)
        }
    }
    
    @IBAction func actWifiScheduling(_ sender: UISwitch) {
        toggleWifiSchedule()
    }
    
    @IBAction func actStartAt(_ sender: Any) {
        if var vc = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = vc.presentedViewController {
                vc = presentedViewController
            }
            
            if let scheduleVC = UIStoryboard(name: TimeSelfCareStoryboard.wificonfiguration.filename, bundle: nil).instantiateViewController(withIdentifier: "ScheduleViewController") as? ScheduleViewController {
                vc.addChild(scheduleVC)
                scheduleVC.delegate = self
                scheduleVC.type = .startAt
                let arrTime = startLabel.text?.components(separatedBy: ":") ?? ["00", "00"]
                scheduleVC.hours = Int(arrTime[0]) ?? 0
                scheduleVC.mins = Int(arrTime[1]) ?? 0
                scheduleVC.view.frame = vc.view.frame
                vc.view.addSubview(scheduleVC.view)
                scheduleVC.didMove(toParent: vc)
            }
        }
    }
    
    @IBAction func actCloseAt(_ sender: Any) {
        if var vc = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = vc.presentedViewController {
                vc = presentedViewController
            }
            
            if let scheduleVC = UIStoryboard(name: TimeSelfCareStoryboard.wificonfiguration.filename, bundle: nil).instantiateViewController(withIdentifier: "ScheduleViewController") as? ScheduleViewController {
                vc.addChild(scheduleVC)
                scheduleVC.delegate = self
                scheduleVC.type = .closeAt
                let arrTime = closeLabel.text?.components(separatedBy: ":") ?? ["00", "00"]
                scheduleVC.hours = Int(arrTime[0]) ?? 0
                scheduleVC.mins = Int(arrTime[1]) ?? 0
                scheduleVC.view.frame = vc.view.frame
                vc.view.addSubview(scheduleVC.view)
                scheduleVC.didMove(toParent: vc)
            }
        }
    }
    
    func queryAllWifi() {
        wifiInfos = []
        stackView.isHidden = true
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = NSLocalizedString("Loading...", comment: "")
        HuaweiHelper.shared.getGuestWifiInfo(completion: { guestWifi in
            HuaweiHelper.shared.getWifiInfoAll(completion: { wifiInfoAll in
                hud.hide(animated: true)
                self.stackView.isHidden = false
                self.switchDualBand.isOn = wifiInfoAll.dualbandCombine
                self.singleBandView.isHidden = wifiInfoAll.dualbandCombine
                
                let arrData = wifiInfoAll.infoList.filter { wifiInfo -> Bool in
                    return wifiInfo.ssidIndex != guestWifi.ssidIndex && wifiInfo.ssidIndex != guestWifi.ssidIndex5G
                }
                
                let group = DispatchGroup()
                hud.show(animated: true)
                for infoItem in arrData {
                    group.enter()
                    HuaweiHelper.shared.getWifiInfo(ssidIndex: infoItem.ssidIndex, completion: { info in
                        self.wifiInfos.append(info)
                        group.leave()
                    }, error: { _ -> Void in
                        hud.hide(animated: true)
                    })
                }
                
                group.notify(queue: .main) {
                    hud.hide(animated: true)
                    self.switchHideWifi.isOn = !self.wifiInfos.contains(where: { wifiInfo -> Bool in
                        return wifiInfo?.isSsidAdvertisementEnabled == true
                    })
                    
                    self.switch2p4g.isOn = self.wifiInfos.filter { $0?.radioType == "2.4G"}.contains(where: { wifiInfo -> Bool in
                        return wifiInfo?.enable == true
                    })
                    
                    self.switch5g.isOn = self.wifiInfos.filter { $0?.radioType == "5G"}.contains(where: { wifiInfo -> Bool in
                        return wifiInfo?.enable == true
                    })
                }
            }, error: { _ -> Void in
                hud.hide(animated: true)
            })
        }, error: { _ in
            hud.hide(animated: true)
        })
    }
    
    func queryWifiTimer() {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = NSLocalizedString("Loading...", comment: "")
        HuaweiHelper.shared.getWifiTimer(completion: { timer in
            DispatchQueue.main.async {
                hud.hide(animated: true)
                self.timer = timer
                self.switchScheduling.isOn = timer.enabled
                self.schedulingView.isHidden = !timer.enabled
                let closeD = self.getUTCDate(stringDate: timer.endTime)
                let startD = self.getUTCDate(stringDate: timer.startTime)
                let utcCloseDate = self.getTime(date: closeD)
                let utcStartDate = self.getTime(date: startD)
                self.startLabel.text = utcStartDate
                self.closeLabel.text = utcCloseDate
            }
            
        }, error: { _ -> Void in
            DispatchQueue.main.async {
                hud.hide(animated: true)
            }
        })
    }
    
    func toggleDualBand() {
        if let dataInfos = wifiInfos as? [HwWifiInfo] {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.label.text = NSLocalizedString("Loading...", comment: "")
            
            for wifiInfo in dataInfos {
                if switchDualBand.isOn {
                    wifiInfo.enable = true
                }
                if wifiInfo.radioType == "5G" {
                    wifiInfo.dualbandCombine = switchDualBand.isOn ? kHwSetDualbandCombineOn : kHwSetDualbandCombineOff
                }
            }
            HuaweiHelper.shared.setWifiInfoList(wifiInfos: dataInfos, completion: { info in
                DispatchQueue.main.async {
                    hud.hide(animated: true)
                    self.wifiInfos = dataInfos
                }
            }, error: { _ in
                DispatchQueue.main.async {
                    hud.hide(animated: true)
                }
            })
        }
    }
    
    func toggleWifiEnabled(band: String, switchWifi: UISwitch) {
        if let dataInfos = wifiInfos.filter({ $0?.radioType == band }) as? [HwWifiInfo] {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.label.text = NSLocalizedString("Loading...", comment: "")
            
            let sortedArr = dataInfos.sorted(by: { (wifiInfoA, wifiInfoB) -> Bool in
                return "\(wifiInfoA.ssidIndex)".compare("\(wifiInfoB.ssidIndex)", options: .numeric) == .orderedAscending
            })
            
            if (switchWifi.isOn) {
                sortedArr.first(where: {$0.radioType == "2.4G"})?.enable = true
                sortedArr.first(where: {$0.radioType == "5G"})?.enable = true
            } else {
                for wifiInfo in dataInfos {
                    wifiInfo.enable = false
                }
            }
            
            
            HuaweiHelper.shared.setWifiInfoList(wifiInfos: dataInfos, completion: { _ in
                DispatchQueue.main.async {
                    hud.hide(animated: true)
                }
            }, error: { _ in
                DispatchQueue.main.async {
                    hud.hide(animated: true)
                }
            })
        }
    }
    
    func toggleHideWifiNetwork() {
        if let dataInfos = wifiInfos as? [HwWifiInfo] {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.label.text = NSLocalizedString("Loading...", comment: "")
            
            for wifiInfo in dataInfos {
                wifiInfo.isSsidAdvertisementEnabled = !switchHideWifi.isOn
            }
            HuaweiHelper.shared.setWifiInfoList(wifiInfos: dataInfos, completion: { _ in
                DispatchQueue.main.async {
                    hud.hide(animated: true)
                    self.wifiInfos = dataInfos
                }
            }, error: { _ in
                DispatchQueue.main.async {
                    hud.hide(animated: true)
                }
            })
        }
    }
    
    func toggleWifiSchedule() {
        if let newTimer = timer {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.label.text = NSLocalizedString("Loading...", comment: "")
            newTimer.enabled = switchScheduling.isOn

            HuaweiHelper.shared.setWifiTimer(timer: newTimer, completion: { _ in
                self.timer = newTimer
                self.schedulingView.isHidden = !self.switchScheduling.isOn
                hud.hide(animated: true)
            }, error: { _ in
                DispatchQueue.main.async {
                    hud.hide(animated: true)
                }
            })
        }
    }
    
    func updateWifiInfo(info: HwSetWifiInfoListResult) {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = NSLocalizedString("Loading...", comment: "")
        let group = DispatchGroup()
        for successItem in info.successList {
            group.enter()
            if let item = successItem as? HwSetWifiInfoSuccessInfo {
                if let index = Int32(item.ssidIndex) {
                    HuaweiHelper.shared.getWifiInfo(ssidIndex: index, completion: { info in
                        if self.wifiInfos.contains(where: { $0?.ssidIndex == info.ssidIndex }) {
                            if let index = self.wifiInfos.firstIndex(where: { $0?.ssidIndex == info.ssidIndex }) {
                                self.wifiInfos[index] = info
                            }
                        }
                        group.leave()
                    }, error: { _ in
                        hud.hide(animated: true)
                    })
                }
            }
        }
        
        group.notify(queue: .main) {
            hud.hide(animated: true)
        }
    }
    
    func getTime(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    func getGMTTime(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone(abbreviation: "GMT")
        return formatter.string(from: date)
    }
    
    func getUTCDate(stringDate: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        if let date = dateFormatter.date(from: stringDate) {
            return date
        } else {
            return dateFormatter.date(from: "00:00")!
        }
    }
    
    func getDate(stringDate: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        if let date = dateFormatter.date(from: stringDate) {
            return date
        } else {
            return dateFormatter.date(from: "00:00")!
        }
    }
}

extension WifiSettingsViewController: ScheduleViewControllerDelegate {
    func updateNewTime(type: HeaderType, time: String) {
        if type == .startAt {
            if let newTimer = timer {
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                hud.label.text = NSLocalizedString("Loading...", comment: "")

                let startTime = self.getDate(stringDate: time)
                let utcStartDate = self.getGMTTime(date: startTime)
                newTimer.startTime = utcStartDate
                
                HuaweiHelper.shared.setWifiTimer(timer: newTimer, completion: { _ in
                    self.timer = newTimer
                    self.schedulingView.isHidden = !self.switchScheduling.isOn
                    self.startLabel.text = time
                    hud.hide(animated: true)
                }, error: { exception in
                    DispatchQueue.main.async {
                        self.showAlertMessage(message: exception?.errorCode ?? "")
                        hud.hide(animated: true)
                    }
                })
            }
        } else if type == .closeAt {
            if let newTimer = timer {
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                hud.label.text = NSLocalizedString("Loading...", comment: "")

                let endTimer = self.getDate(stringDate: time)
                let utcEndDate = self.getGMTTime(date: endTimer)
                newTimer.endTime = utcEndDate
                
                HuaweiHelper.shared.setWifiTimer(timer: newTimer, completion: { _ in
                    self.timer = newTimer
                    self.schedulingView.isHidden = !self.switchScheduling.isOn
                    self.closeLabel.text = time
                    hud.hide(animated: true)
                }, error: { exception in
                    DispatchQueue.main.async {
                        self.showAlertMessage(message: exception?.errorCode ?? "")
                        hud.hide(animated: true)
                    }
                })
            }
        }
    }
}
