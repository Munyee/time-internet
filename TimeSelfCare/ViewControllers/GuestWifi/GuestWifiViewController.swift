//
//  GuestWifiViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 07/05/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import UIKit
import HwMobileSDK

class GuestWifiViewController: UIViewController {

    @IBOutlet private weak var timerView: UIView!
    @IBOutlet private weak var timerLabel: UILabel!
    @IBOutlet private weak var infinityView: UIImageView!
    @IBOutlet private weak var noUsernameView: UIView!
    @IBOutlet private weak var usernameView: UIView!
    @IBOutlet private weak var username: UILabel!
    @IBOutlet private weak var password: UILabel!
    @IBOutlet private weak var buttonLabel: UILabel!
    @IBOutlet private weak var connectedDevicesLabel: UILabel!
    @IBOutlet private weak var connectedDeviceStackView: UIStackView!
    
    var guestInfo: HwGuestWifiInfo!
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid

    var remainingTime: Int32 = 0
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.usernameView.isHidden = true
        self.title = NSLocalizedString("GUEST WIFI", comment: "")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back_arrow"), style: .done, target: self, action: #selector(self.popBack))
        self.infinityView.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(reinstateBackgroundTask), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        timer?.invalidate()
        self.queryGuestWifi()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    func popBack() {
        if let viewControllers = self.navigationController?.viewControllers {
            if viewControllers.contains(where: {
                $0 is WifiConfigurationViewController
            }) {
                self.navigationController?.popViewController(animated: true)
            } else {
                self.dismissVC()
            }
        } else {
            self.dismissVC()
        }
    }
    
    func queryGuestWifi() {
        let hud = LoadingView().addLoading(toView: self.view)
        hud.showLoading()
        HuaweiHelper.shared.getGuestWifiInfo { info in
            hud.hideLoading()
            
            self.guestInfo = info
            if info.ssid.isEmpty {
                self.noUsernameView.isHidden = false
                self.usernameView.isHidden = true
                self.buttonLabel.text = "SET UP NOW"
            } else {
                self.noUsernameView.isHidden = true
                self.usernameView.isHidden = false
                self.username.text = info.ssid
                self.password.text = info.encrypt == HwGuestWifiInfoEncryptMode.OPEN ? "Password not required" : "Password required"
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(self.edit))
                self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "DINAlternate-Bold", size: 18)], for: .normal)
                self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "DINAlternate-Bold", size: 18)], for: .highlighted)
                self.timerView.borderWidth = 2
                
                self.updateGuestWifi(info: info)
            }
            self.queryLanDevices()
        } error: { _ in
            hud.hideLoading()
        }
    }
    
    func queryLanDevices() {
        
        self.connectedDevicesLabel.text = "Connected devices (0)"
        
        for view in self.connectedDeviceStackView.subviews {
            self.connectedDeviceStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        let hud = LoadingView().addLoading(toView: self.view)
        hud.showLoading()

        var arrDevice: [HwLanDevice] = []
        HuaweiHelper.shared.queryLanDeviceListEx { devices in
            arrDevice = devices.filter { ($0.connectInterface == "SSID\(self.guestInfo.ssidIndex)" || $0.connectInterface == "SSID\(self.guestInfo.ssidIndex5G)") && $0.onLine }

            let arrMac = arrDevice.map { $0.mac }
            var arrDeviceType: [HwDeviceTypeInfo] = []
            if let macList = arrMac as? [String] {
                
                let group = DispatchGroup()
                
                group.enter()
                HuaweiHelper.shared.queryLanDeviceManufacturingInfoList(macList: macList) { deviceTypeInfo in
                    arrDeviceType = deviceTypeInfo
                    group.leave()
                } error: { _ in
                    group.leave()
                }
                
                group.notify(queue: .main) {
                    hud.hideLoading()
                    
                    self.connectedDevicesLabel.text = "Connected devices (\(arrDevice.count))"
                    
                    for device in arrDevice {
                        let deviceType = arrDeviceType.first(where: { $0.mac == device.mac })
                        if let connectedDevice = ConnectedDevice(device: device, deviceTypeInfo: deviceType ?? HwDeviceTypeInfo()) {
                            self.connectedDeviceStackView.addArrangedSubview(connectedDevice)
                        }
                    }
                }
            } else {
                hud.hideLoading()
            }
        } error: { _ in
            hud.hideLoading()
        }
    }
    
    func timerCount() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if self.remainingTime > 0 {
                self.remainingTime -= 1
            } else {
                self.timer?.invalidate()
                self.buttonLabel.text = "TURN ON"
                self.timerView.borderColor = #colorLiteral(red: 0.3999636769, green: 0.400023967, blue: 0.3999447227, alpha: 1)
                self.infinityView.tintColor = #colorLiteral(red: 0.3999636769, green: 0.400023967, blue: 0.3999447227, alpha: 1)
                self.timerLabel.text = "\(self.secondsToHoursMinutesSeconds(seconds: Int32((AccountController.shared.guestWifiDuration ?? 0) * 60)))"
                self.timerLabel.textColor = #colorLiteral(red: 0.3999636769, green: 0.400023967, blue: 0.3999447227, alpha: 1)
            }
            
            self.timerLabel.text = "\(self.secondsToHoursMinutesSeconds(seconds: self.remainingTime))"
        }
    }
    
    @objc
    func edit() {
        if let vc = UIStoryboard(name: TimeSelfCareStoryboard.guestwifi.filename, bundle: nil).instantiateViewController(withIdentifier: "EditGuestWifiViewController") as? EditGuestWifiViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int32) -> (String) {
        "\(String(format: "%02d", Int(seconds / 3_600 / 24))):\(String(format: "%02d", (seconds / 3_600) % 24)):\(String(format: "%02d", (seconds % 3_600) / 60)):\(String(format: "%02d", seconds % 60))"
    }
    
    @IBAction func actTurnOnOff(_ sender: Any) {
        if guestInfo != nil && guestInfo.ssid.isEmpty {
            self.edit()
        } else {
            self.toggleGuestWifi(enable: !(guestInfo.enabled))
        }
    }
    
    func toggleGuestWifi(enable: Bool) {
        var guestWifi = HwGuestWifiInfo()
        guestWifi = self.guestInfo
        guestWifi.isRaidoTypeEnable = true
        guestWifi.radioType = HwRadioType(rawValue: 3)
        guestWifi.duration = Int32(AccountController.shared.guestWifiDuration ?? 0)
        guestWifi.enabled = enable
        guestWifi.remainSec = enable ? Int32((AccountController.shared.guestWifiDuration ?? 0) * 60) : Int32(0)
        guestWifi.remaining = enable ? Int32(AccountController.shared.guestWifiDuration ?? 0) : Int32(0)

        let hud = LoadingView().addLoading(toView: self.view)
        hud.showLoading()
        HuaweiHelper.shared.setGuestWifiInfo(guestWifiInfo: guestWifi) { _ in
            hud.hideLoading()
            self.timer?.invalidate()
            self.timerView.borderColor = #colorLiteral(red: 0.3999636769, green: 0.400023967, blue: 0.3999447227, alpha: 1)
            self.infinityView.tintColor = #colorLiteral(red: 0.3999636769, green: 0.400023967, blue: 0.3999447227, alpha: 1)
            self.timerLabel.text = "\(self.secondsToHoursMinutesSeconds(seconds: Int32((AccountController.shared.guestWifiDuration ?? 0) * 60)))"
            self.timerLabel.textColor = #colorLiteral(red: 0.3999636769, green: 0.400023967, blue: 0.3999447227, alpha: 1)
            self.updateGuestWifi(info: guestWifi)
        } error: { exception in
            DispatchQueue.main.async {
                hud.hideLoading()
                self.showAlertMessage(message: HuaweiHelper.shared.mapErrorMsg(exception?.errorCode ?? ""))
            }
        }
    }
    
    func updateGuestWifi(info: HwGuestWifiInfo) {
        if info.enabled {
            self.remainingTime = info.remainSec
            self.timerView.borderColor = #colorLiteral(red: 0.9254901961, green: 0, blue: 0.5490196078, alpha: 1)
            self.timerLabel.textColor = #colorLiteral(red: 0.9254901961, green: 0, blue: 0.5490196078, alpha: 1)
            self.buttonLabel.text = "TURN OFF"
            if AccountController.shared.guestWifiDuration == 0 {
                self.timerLabel.isHidden = true
                self.infinityView.isHidden = false
                self.infinityView.tintColor = #colorLiteral(red: 0.9254901961, green: 0, blue: 0.5490196078, alpha: 1)
            } else {
                self.timerLabel.isHidden = false
                self.infinityView.isHidden = true
                self.timerLabel.text = "\(self.secondsToHoursMinutesSeconds(seconds: info.remainSec))"
                self.timerCount()
                
                let center = UNUserNotificationCenter.current()
                let content = UNMutableNotificationContent()
                content.title = "Your Guest WiFi has expired"
                content.body = "Would you like to turn it on again?"
                content.sound = UNNotificationSound.default
                content.userInfo = ["activity": ["id": "999", "activity": "Guest Wifi", "click": "Guest Wifi"]]

                if self.remainingTime > 0 {
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval:Double(info.remainSec), repeats: false)
                    let request = UNNotificationRequest(identifier: "ContentIdentifier", content: content, trigger: trigger)
                    center.add(request) { error in
                        if error != nil {
                            print("error \(String(describing: error))")
                        }
                    }
                }
            }
        } else {
            self.timerView.borderColor = #colorLiteral(red: 0.3999636769, green: 0.400023967, blue: 0.3999447227, alpha: 1)
            self.timerLabel.text = "\(self.secondsToHoursMinutesSeconds(seconds: Int32((AccountController.shared.guestWifiDuration ?? 0) * 60)))"
            self.timerLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.buttonLabel.text = "TURN ON"
            if AccountController.shared.guestWifiDuration == 0 {
                self.timerLabel.isHidden = true
                self.infinityView.isHidden = false
                self.infinityView.tintColor = #colorLiteral(red: 0.3999636769, green: 0.400023967, blue: 0.3999447227, alpha: 1)
            } else {
                self.timerLabel.isHidden = false
                self.infinityView.isHidden = true
            }
            
            let center = UNUserNotificationCenter.current()
            center.removeAllPendingNotificationRequests()
        }
    }
    
    @objc
    func reinstateBackgroundTask() {
        timer?.invalidate()
        self.queryGuestWifi()
    }
}
