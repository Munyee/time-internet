//
//  GuestWifiViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 07/05/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import UIKit
import MBProgressHUD
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
    
    var guestInfo: HwGuestWifiInfo!
    
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
        timer?.invalidate()
        self.queryGuestWifi()
    }
    
    @objc
    func popBack() {
        self.navigationController?.popViewController(animated: true)
        self.dismissVC()
    }
    
    func queryGuestWifi() {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = NSLocalizedString("Loading...", comment: "")
        HuaweiHelper.shared.getGuestWifiInfo { info in
            hud.hide(animated: true)
            
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
            }
            
            if info.enabled {
                self.remainingTime = info.remainSec
                self.timerView.borderColor = #colorLiteral(red: 0.9254901961, green: 0, blue: 0.5490196078, alpha: 1)
                self.timerLabel.textColor = #colorLiteral(red: 0.9254901961, green: 0, blue: 0.5490196078, alpha: 1)
                self.buttonLabel.text = "TURN OFF"
                if info.duration == 0 {
                    self.timerLabel.isHidden = true
                    self.infinityView.isHidden = false
                    self.infinityView.tintColor = #colorLiteral(red: 0.9254901961, green: 0, blue: 0.5490196078, alpha: 1)
                } else {
                    self.timerLabel.isHidden = false
                    self.infinityView.isHidden = true
                    self.timerLabel.text = "\(self.secondsToHoursMinutesSeconds(seconds: self.remainingTime))"
                    self.timerCount()
                    
                    let center = UNUserNotificationCenter.current()
                    let content = UNMutableNotificationContent()
                    content.title = "Your Guest WiFi has expired"
                    content.body = "Would you like to turn it on again?"
                    content.sound = UNNotificationSound.default
                    content.userInfo = ["activity": ["id": "999", "activity": "Guest Wifi", "click": "Guest Wifi"]]

                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval:Double(info.remainSec), repeats: false)
                    let request = UNNotificationRequest(identifier: "ContentIdentifier", content: content, trigger: trigger)
                    center.add(request) { error in
                        if error != nil {
                            print("error \(String(describing: error))")
                        }
                    }
                }
                
            } else {
                self.timerView.borderColor = #colorLiteral(red: 0.3999636769, green: 0.400023967, blue: 0.3999447227, alpha: 1)
                self.timerLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                self.buttonLabel.text = "TURN ON"
                if info.duration == 0 {
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
        } error: { _ in
            hud.hide(animated: true)
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
                self.timerLabel.text = "00:00:00:00"
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
        if guestInfo.ssid.isEmpty {
            self.edit()
        } else {
            self.toggleGuestWifi(enable: !guestInfo.enabled)
        }
    }
    
    func toggleGuestWifi(enable: Bool) {
        var guestWifi = HwGuestWifiInfo()
        guestWifi = self.guestInfo
        guestWifi.enabled = enable
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = NSLocalizedString("Loading...", comment: "")
        HuaweiHelper.shared.setGuestWifiInfo(guestWifiInfo: guestWifi) { _ in
            hud.hide(animated: true)
            self.timer?.invalidate()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.queryGuestWifi()
            }
            self.timerView.borderColor = #colorLiteral(red: 0.3999636769, green: 0.400023967, blue: 0.3999447227, alpha: 1)
            self.infinityView.tintColor = #colorLiteral(red: 0.3999636769, green: 0.400023967, blue: 0.3999447227, alpha: 1)
            self.timerLabel.text = "00:00:00:00"
            self.timerLabel.textColor = #colorLiteral(red: 0.3999636769, green: 0.400023967, blue: 0.3999447227, alpha: 1)
        } error: { exception in
            hud.hide(animated: true)
            self.showAlertMessage(message: exception?.errorMessage ?? "Something went wrong")
        }

    }
}
