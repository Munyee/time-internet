//
//  WifiConfigurationViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 02/03/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import UIKit
import HwMobileSDK
class WifiConfigurationViewController: UIViewController {
    
    @IBOutlet weak var liveChatView: ExpandableLiveChatView!
    @IBOutlet weak var liveChatConstraint: NSLayoutConstraint!
    @IBOutlet weak var guestWifiStatus: UILabel!
    @IBOutlet weak var familyName: UILabel!
    var gateway: HwUserBindedGateway?
    var remainingTime: Int32 = 0
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.liveChatView.isHidden = false
        
        self.title = NSLocalizedString("WIFI CONFIGURATION", comment: "")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back_arrow"), style: .done, target: self, action: #selector(self.dismissVC(_:)))
        
        familyName.text = gateway?.gatewayNickname
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.liveChatView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.liveChatView.isHidden = false
        HuaweiHelper.shared.queryUserBindGateway { gateways in
            if !gateways.isEmpty {
                self.gateway = gateways.first
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        timer?.invalidate()
        queryGuestWifi()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if liveChatView.isExpand {
            liveChatConstraint.constant = 0
        } else {
            liveChatConstraint.constant = -125
        }
    }
    
    func queryGuestWifi() {
        let hud = LoadingView().addLoading(toView: self.view)
        hud.showLoading()
        HuaweiHelper.shared.getGuestWifiInfo { info in
            hud.hideLoading()
            if info.enabled {
                self.remainingTime = info.remainSec
                if info.duration == 0 {
                    self.guestWifiStatus.text = "ON (No Limit)"
                } else {
                    self.guestWifiStatus.text = "ON (\(self.secondsToHoursMinutesSeconds(seconds: self.remainingTime)))"
                    self.timerCount()
                }
                self.guestWifiStatus.textColor = #colorLiteral(red: 0.07450980392, green: 0.8470588235, blue: 0.1058823529, alpha: 1)
            } else {
                self.guestWifiStatus.text = "OFF"
                self.guestWifiStatus.textColor = #colorLiteral(red: 0.8980392157, green: 0.02745098039, blue: 0.02745098039, alpha: 1)
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
                self.guestWifiStatus.text = "OFF"
                self.guestWifiStatus.textColor = #colorLiteral(red: 0.8980392157, green: 0.02745098039, blue: 0.02745098039, alpha: 1)
            }
            self.guestWifiStatus.text = "ON (\(self.secondsToHoursMinutesSeconds(seconds: self.remainingTime)))"
        }
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int32) -> (String) {
        "\(String(format: "%02d", Int(seconds / 3_600 / 24))):\(String(format: "%02d", (seconds / 3_600) % 24)):\(String(format: "%02d", (seconds % 3_600) / 60)):\(String(format: "%02d", seconds % 60))"
    }
    
    @IBAction func actConnectedWifi(_ sender: Any) {
        if let connectedWifiVC = UIStoryboard(name: TimeSelfCareStoryboard.wificonfiguration.filename, bundle: nil).instantiateViewController(withIdentifier: "ConnectedWifiViewController") as? ConnectedWifiViewController {
            connectedWifiVC.gateway = self.gateway
            self.navigationController?.pushViewController(connectedWifiVC, animated: true)
        }
    }
    
    @IBAction func actWifiSettings(_ sender: Any) {
        if let wifiSettingsVC = UIStoryboard(name: TimeSelfCareStoryboard.wificonfiguration.filename, bundle: nil).instantiateViewController(withIdentifier: "WifiSettingsViewController") as? WifiSettingsViewController {
            self.navigationController?.pushViewController(wifiSettingsVC, animated: true)
        }
    }
    
    @IBAction func actBlacklist(_ sender: Any) {
        if let vc = UIStoryboard(name: TimeSelfCareStoryboard.blacklist.filename, bundle: nil).instantiateViewController(withIdentifier: "BlacklistViewController") as? BlacklistViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func actGuestWifi(_ sender: Any) {
        if let vc = UIStoryboard(name: TimeSelfCareStoryboard.guestwifi.filename, bundle: nil).instantiateViewController(withIdentifier: "GuestWifiViewController") as? GuestWifiViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
