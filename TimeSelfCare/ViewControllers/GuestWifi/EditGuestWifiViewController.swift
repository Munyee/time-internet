//
//  EditGuestWifiViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 10/05/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import UIKit
import MBProgressHUD
import HwMobileSDK

class EditGuestWifiViewController: UIViewController {

    @IBOutlet private weak var wifiName: FloatLabeledTextView!
    @IBOutlet private weak var ssidPassword: FloatLabeledTextView!
    @IBOutlet private weak var duration: FloatLabeledTextView!
    @IBOutlet private weak var ssidSeparator: UIView!
    @IBOutlet private weak var ssidPasswordSeparator: UIView!
    @IBOutlet private weak var visiblePassword: UIButton!
    @IBOutlet private weak var createBtn: UIButton!
    @IBOutlet private weak var passwordSwitch: UISwitch!
    @IBOutlet private weak var passwordView: UIView!
    @IBOutlet private weak var stackView: UIStackView!
    
    var guestInfo: HwGuestWifiInfo!

    var wifiDuration: Int32?
    var durationType: DurationType?
    
    var originalPassword: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("GUEST WIFI", comment: "")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back_arrow"), style: .done, target: self, action: #selector(self.popBack))
        self.setupView()
        self.hideKeyboardWhenTappedAround()
        queryGuestWifi()
        self.passwordView.isHidden = !passwordSwitch.isOn
    }
    
    @objc
    func popBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupView() {
        wifiName.font = UIFont(name: "DINCondensed-Bold", size: 20)
        wifiName.floatingLabelFont = UIFont(name: "DIN-Light", size: 14)
        wifiName.floatingLabel.text = "Profile name"
        
        ssidPassword.font = UIFont(name: "DINCondensed-Bold", size: 20)
        ssidPassword.floatingLabelFont = UIFont(name: "DIN-Light", size: 14)
        ssidPassword.floatingLabel.text = "Password"
        ssidPassword.keyboardType = .asciiCapable
        ssidPassword.autocapitalizationType = .none
        
        duration.font = UIFont(name: "DINCondensed-Bold", size: 20)
        duration.floatingLabelFont = UIFont(name: "DIN-Light", size: 14)
        duration.floatingLabel.text = "WiFi duration"
    }
    
    @IBAction func toggleVisibility(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            ssidPassword.text = originalPassword
        } else {
            var pass = ""
            for _ in originalPassword ?? "" {
                pass+="*"
            }
            ssidPassword.text = pass
        }
    }
    
    func queryGuestWifi() {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = NSLocalizedString("Loading...", comment: "")
        HuaweiHelper.shared.getGuestWifiInfo { info in
            hud.hide(animated: true)
            self.guestInfo = info
            
            if info.encrypt == HwGuestWifiInfoEncryptMode.OPEN {
                self.passwordSwitch.isOn = false
                self.passwordView.isHidden = true
            } else {
                self.passwordSwitch.isOn = true
                self.passwordView.isHidden = false
            }
            
            self.wifiDuration = info.duration
            if self.wifiDuration == 0 {
                self.duration.text = "No Limit"
                self.durationType = .noLimit
            } else {
                self.duration.text = self.secondsToHoursMinutesSeconds(seconds: self.wifiDuration ?? 0)
                self.durationType = .custom
            }
            
            if info.ssid.isEmpty {
                self.createBtn.isHidden = false
            } else {
                // Hide create button
                self.createBtn.isHidden = true
                self.wifiName.text = info.ssid
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(self.save))
                self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "DINAlternate-Bold", size: 18)!], for: .normal)
                self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "DINAlternate-Bold", size: 18)!], for: .highlighted)
                self.navigationItem.rightBarButtonItem?.isEnabled = false
            }
            
            self.checkCanNext()
            
        } error: { _ in
            hud.hide(animated: true)
        }
    }
    
    @IBAction func actPasswordToggle(_ sender: UISwitch) {
        UIView.animate(withDuration: 0.3) {
            self.passwordView.isHidden = !sender.isOn
            self.stackView.layoutIfNeeded()
        }
        
        checkCanNext()
    }
    
    @IBAction func actCreate(_ sender: Any) {
        save()
    }
    
    @objc
    func save() {
        var guestWifi = HwGuestWifiInfo()
        guestWifi = self.guestInfo
        guestWifi.enabled = true
        guestWifi.ssid = wifiName.text
        guestWifi.duration = wifiDuration ?? 0
        guestWifi.serviceEnable = true
        if passwordSwitch.isOn {
            guestWifi.encrypt = HwGuestWifiInfoEncryptMode.mixdWPA2WPAPSK
            guestWifi.password = ssidPassword.text
        } else {
            guestWifi.encrypt = HwGuestWifiInfoEncryptMode.OPEN
        }
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = NSLocalizedString("Loading...", comment: "")
        HuaweiHelper.shared.setGuestWifiInfo(guestWifiInfo: guestWifi) { _ in
            hud.hide(animated: true)
            self.popBack()
        } error: { exception in
            hud.hide(animated: true)
            self.showAlertMessage(message: exception?.errorMessage ?? "Something went wrong")
        }
    }
}

extension EditGuestWifiViewController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == wifiName {
            ssidSeparator.backgroundColor = UIColor(hex: "D9D9D9")
        } else if textView == ssidPassword {
            ssidPasswordSeparator.backgroundColor = UIColor(hex: "D9D9D9")
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView == ssidPassword {
            originalPassword = ((originalPassword ?? "") as NSString).replacingCharacters(in: range, with: text)
        }
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView == ssidPassword && !visiblePassword.isSelected {
            textView.text = String(repeating: "*", count: (textView.text ?? "").count)
        }
        
        checkCanNext()
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView == duration {
            if var vc = UIApplication.shared.keyWindow?.rootViewController {
                while let presentedViewController = vc.presentedViewController {
                    vc = presentedViewController
                }
                
                if let durationVC = UIStoryboard(name: TimeSelfCareStoryboard.guestwifi.filename, bundle: nil).instantiateViewController(withIdentifier: "DurationViewController") as? DurationViewController {
                    vc.addChild(durationVC)
                    durationVC.duration = wifiDuration
                    durationVC.durationType = durationType
                    durationVC.delegate = self
                    durationVC.view.frame = vc.view.frame
                    vc.view.addSubview(durationVC.view)
                    durationVC.didMove(toParent: vc)
                }
            }
            return false
        } else {
            return true
        }
    }
    
    func checkCanNext() {
        if passwordSwitch.isOn {
            if wifiName.text != "" && ssidPassword.text != "" && durationType != nil {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                self.createBtn.isUserInteractionEnabled = true
                self.createBtn.backgroundColor = UIColor.primary
            } else {
                self.navigationItem.rightBarButtonItem?.isEnabled = false
                self.createBtn.isUserInteractionEnabled = false
                self.createBtn.backgroundColor = UIColor.lightGray
            }
        } else {
            if wifiName.text != "" && durationType != nil {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                self.createBtn.isUserInteractionEnabled = true
                self.createBtn.backgroundColor = UIColor.primary
            } else {
                self.navigationItem.rightBarButtonItem?.isEnabled = false
                self.createBtn.isUserInteractionEnabled = false
                self.createBtn.backgroundColor = UIColor.lightGray
            }
        }
    }
}

extension EditGuestWifiViewController: DurationViewControllerDelegate {
    func updateNewDuration(time: Int32, durationType: DurationType) {
        self.wifiDuration = time
        self.durationType = durationType
        if time == 0 {
            duration.text = "No Limit"
        } else {
            duration.text = secondsToHoursMinutesSeconds(seconds: time)
        }
        
        checkCanNext()
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int32) -> (String) {
        var result = ""
        let days = Int(seconds / 60 / 24)
        let hours = Int((seconds / 60) % 24)
        let mins = (seconds % 60)
        
        if days > 0 {
            result += "\(days) Days "
        }
        
        if hours > 0 {
            result += "\(hours) Hours "
        }
        
        if mins > 0 {
            result += "\(mins) Mins"
        }
        
        return result
    }
}
