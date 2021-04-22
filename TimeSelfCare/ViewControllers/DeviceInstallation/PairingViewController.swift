//
//  PairingViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 08/04/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import UIKit
import Pulsator
import HwMobileSDK

class PairingViewController: UIViewController {
    
    @IBOutlet private weak var pulseView: UIView!
    @IBOutlet private weak var timerView: UIView!
    @IBOutlet private weak var timerLabel: UILabel!
    @IBOutlet private weak var progressWitdh: NSLayoutConstraint!
    @IBOutlet private weak var startImgView: UIImageView!
    @IBOutlet private weak var connectedImgView: UIImageView!
    @IBOutlet private weak var onlineImgView: UIImageView!
    
    var apMac: String?
    
    var okcTimer: Timer?
    var okcWhiteTimer: Timer?
    var okcQueryLanDevice: Timer?

    var apType: String?
    var apList: [HwOKCWhiteInfo?] = []

    var status: String? = ""
    let pulsator = Pulsator()

    var timer: Timer?
    var totalTime = 240
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("DEVICE INSTALLATION", comment: "")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back_arrow"), style: .done, target: self, action: #selector(self.stopInstallation))
        self.pulseView.layer.insertSublayer(pulsator, below: timerView.layer)
        pulsator.position = CGPoint(x: self.pulseView.bounds.width / 2, y: self.pulseView.bounds.height / 2)
        pulsator.radius = 100
        pulsator.animationDuration = 1
        pulsator.backgroundColor = UIColor.primary.cgColor
        UserDefaults.standard.set(0, forKey: "NO_DEVICE_FOUND")
        getOKCList()
//        getOKCWhiteList()
        okcTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(getOKCList), userInfo: nil, repeats: true)
        
        HuaweiHelper.shared.registerMessageHandle(completion: { message in
            if let message = message.msgContentDic.value(forKey: "msgEvent") as? String {
                self.status = message
            }
        }, error: { _ in
            print("----Error----")
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pulsator.start()
        totalTime = 240
        self.timerLabel.text = timeFormatted(totalTime)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.startImgView.image = #imageLiteral(resourceName: "icon_pending")
        self.connectedImgView.image = #imageLiteral(resourceName: "icon_pending")
        self.onlineImgView.image = #imageLiteral(resourceName: "icon_pending")
        self.progressWitdh.constant = 0
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        DeviceInstallationHelper.shared.getOKCWhiteList(completion: { arrList in
            let arrApMac = arrList.map { (item) -> String in
                return item.macAddr
            }
            
            if let controller = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 3] {
                DeviceInstallationHelper.shared.deleteOKCWhiteList(list: arrApMac, completion: { _ in
                    self.navigationController?.popToViewController(controller, animated: true)
                }, error: { _ in })
            }
            
            
        }, error: { _ in })
        
        pulsator.stop()
        self.timer?.invalidate()
        self.okcTimer?.invalidate()
        self.okcWhiteTimer?.invalidate()
        self.okcQueryLanDevice?.invalidate()
    }
    
    @objc
    func stopInstallation() {
        self.showAlertMessage(title: "Stop installation", message: "The installation is in progress. Are you sure you want to quit?", actions: [
            UIAlertAction(title: NSLocalizedString("YES", comment: ""), style: .destructive) { _ in
                self.popBack()
            },
            UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { _ in
            }
        ])
    }
    
    @objc
    func hangInstallation() {
        self.showAlertMessage(title: "Installation stalled", message: "An error has occurred. Would you like to restart the installation?", actions: [
            UIAlertAction(title: NSLocalizedString("YES", comment: ""), style: .destructive) { _ in
                if let controller = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 4] {
                    self.navigationController?.popToViewController(controller, animated: true)
                }
            },
            UIAlertAction(title: NSLocalizedString("NO", comment: ""), style: .cancel) { _ in
                self.popBack()
            }
        ])
    }
    
    @objc
    func popBack() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc
    func updateTimer() {
        if totalTime > 0 {
            totalTime -= 1
            timerLabel.text = timeFormatted(totalTime)
        } else {
            if let timer = self.timer {
                timer.invalidate()
                self.timer = nil
            }
                        
            switch status {
            case "WLAN_OKC_FOUND", "WLAN_OKC_SUCCESS", "EXTERNAP_ONLINE":
                self.hangInstallation()
                break
            default:
                if let vc = UIStoryboard(name: TimeSelfCareStoryboard.deviceinstallation.filename, bundle: nil).instantiateViewController(withIdentifier: "NoDeviceFoundViewController") as? NoDeviceFoundViewController {
                    vc.delegate = self
                    self.presentNavigation(vc, animated: true)
                }
            }
        }
        
        switch status {
        case "WLAN_OKC_FOUND":
            self.start()
            self.okcTimer?.invalidate()
            self.getOKCWhiteList()
        case "WLAN_OKC_SUCCESS", "EXTERNAP_ONLINE":
            self.checkOKCWhiteList()
        default:
            break
        }
    }
    
    @objc
    func getOKCList() {
        DeviceInstallationHelper.shared.getLanDeviceOKCList(completion: { arrList in
            print("-----OKC List Data-----")
            self.apList = arrList.filter({ (item) -> Bool in
                return item.type == self.apType
            })
            
            let foundAp = arrList.contains { (item) -> Bool in
                return item.type == self.apType
            }
            
            if foundAp {
                self.start()
                self.okcTimer?.invalidate()
                self.getOKCWhiteList()
            }
        }, error: { _ in
        })
    }
    
    @objc
    func getOKCWhiteList() {
        DeviceInstallationHelper.shared.getOKCWhiteList(completion: { arrList in
            print("-----OKC White List Data-----")
            print(arrList)
            
            let apList = arrList.filter { (item) -> Bool in
                return item.status != "starting"
            }
            
            let arrApMac = apList.map { (item) -> String in
                return item.macAddr
            }
            
            self.deleteWhiteList(arrAp: arrApMac)
            
            if arrList.isEmpty {
                if let ap = self.apList.first as? HwOKCWhiteInfo {
                    self.addWhiteList(apInfo: ap)
                    self.checkOKCWhiteList()
                    self.okcWhiteTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.checkOKCWhiteList), userInfo: nil, repeats: true)
                }
            }
        }, error: { _ in
            print("error")
        })
    }
    
    @objc
    func checkOKCWhiteList() {
        DeviceInstallationHelper.shared.getOKCWhiteList(completion: { arrList in
            print("-----OKC White List Data-----")
            
            if !arrList.isEmpty {
                if let ap = arrList.first {
                    if ap.status == "success" {
                        self.connected()
                        self.okcWhiteTimer?.invalidate()
                        self.deleteWhiteList(arrAp: [ap.macAddr])
                        self.queryLanDevices()
                        self.okcQueryLanDevice = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.queryLanDevices), userInfo: nil, repeats: true)
                    }
                }
            }
        }, error: { _ in
            print("error")
        })
    }
    
    @objc
    func queryLanDevices() {
        HuaweiHelper.shared.queryLanDeviceListEx { devices in
            print("-----AP List Data-----")
            let arrAp = devices.filter { dev -> Bool in
                return dev.isAp
            }
            
            if arrAp.contains(where: { dev -> Bool in
                return dev.lanMac == self.apMac && dev.onLine
            }) {
                self.alreadyOnline()
            }
        }
    }
    
    func addWhiteList(apInfo: HwOKCWhiteInfo) {
        apMac = apInfo.macAddr
        DeviceInstallationHelper.shared.addOKCWhiteList(list: [apInfo], completion: { _ in
        }, error: { _ in })
    }
    
    func deleteWhiteList(arrAp: [String]) {
        DeviceInstallationHelper.shared.deleteOKCWhiteList(list: arrAp, completion: { _ in
        }, error: { _ in })
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func start() {
        UIView.transition(with: self.startImgView, duration: 1.0, options: .transitionCrossDissolve, animations: {
            self.startImgView.image = #imageLiteral(resourceName: "icon_done")
        }, completion: nil)
    }
    
    func connected() {
        DeviceInstallationHelper.shared.getOKCWhiteList(completion: { arrList in
            let arrApMac = arrList.map { (item) -> String in
                return item.macAddr
            }
            
            if let controller = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 3] {
                DeviceInstallationHelper.shared.deleteOKCWhiteList(list: arrApMac, completion: { _ in
                    self.navigationController?.popToViewController(controller, animated: true)
                }, error: { _ in })
            }
            
            
        }, error: { _ in })
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 1.0, animations: {
            self.progressWitdh.constant = (self.view.frame.size.width - 120) / 2
            self.view.layoutIfNeeded()
        }, completion: { _ in
            UIView.transition(with: self.connectedImgView, duration: 1.0, options: .transitionCrossDissolve, animations: {
                self.connectedImgView.image = #imageLiteral(resourceName: "icon_done")
            }, completion: nil)
        })
    }
    
    func alreadyOnline() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 1.0, animations: {
            self.progressWitdh.constant = (self.view.frame.size.width - 120)
            self.view.layoutIfNeeded()
        }, completion: { _ in
            UIView.transition(with: self.onlineImgView, duration: 1.0, options: .transitionCrossDissolve, animations: {
                self.onlineImgView.image = #imageLiteral(resourceName: "icon_done")
            }, completion: { _ in
                if let vc = UIStoryboard(name: TimeSelfCareStoryboard.deviceinstallation.filename, bundle: nil).instantiateViewController(withIdentifier: "PairingDoneViewController") as? PairingSuccessViewController {
                    vc.apType = self.apType
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            })
        })
    }
    
    @IBAction func actStopInstallation(_ sender: Any) {
        self.stopInstallation()
    }
}

extension PairingViewController: NoDeviceFoundViewControllerDelegate {
    func backToHome() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
