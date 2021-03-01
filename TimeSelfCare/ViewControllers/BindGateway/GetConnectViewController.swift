//
//  GetConnectViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 26/02/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import CoreLocation
import UIKit
import HwMobileSDK
import SystemConfiguration.CaptiveNetwork
import MBProgressHUD

class GetConnectViewController: UIViewController {
    
    var locationManager: CLLocationManager?
    var gateway: HwSearchedUserGateway?
    var ssidName: String = ""
    
    @IBOutlet weak var tryAgainButton: UIButton!
    @IBOutlet var ssidText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("GET CONNECT", comment: "")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_close_magenta"), style: .done, target: self, action: #selector(self.dismissVC(_:)))
        searchGateway()
    }
    
    @IBAction func actCancel(_ sender: Any) {
        self.dismissVC()
    }
    
    @IBAction func actRetry(_ sender: Any) {
        if ssidName != "" && gateway != nil {
            if let deviceMac = self.gateway?.deviceMac {
                
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                hud.label.text = NSLocalizedString("Loading...", comment: "")
                HuaweiHelper.shared.bindGateway(deviceMac: deviceMac, gatewayNickname: ssidName, completion: { _ in
                    self.dismissVC()
                    hud.hide(animated: true)
                }) { _ in
                    self.gateway = nil
                    self.notConnected()
                    hud.hide(animated: true)
                }
                
            } else {
                self.gateway = nil
                self.notConnected()
            }
        } else {
            searchGateway()
        }
    }
    
    func checkingSSID() {
        ssidText.text = "Checking"
        ssidText.textColor = UIColor.black
    }
    
    func notConnected() {
        ssidText.text = "Not Connected"
        ssidText.textColor = UIColor(hex: "E50707")
        self.tryAgainButton.setTitle("TRY AGAIN", for: .normal)
    }
    
    func connectedTo(wifiName: String) {
        ssidText.text = wifiName
        ssidText.textColor = UIColor.black
    }
    
    func getWiFiName() -> String? {
        var ssid: String?
        
        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
            for interface in interfaces {
                // swiftlint:disable force_cast
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                    ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                    break
                }
            }
        }
        
        return ssid
    }
    
    func searchGateway() {
        checkingSSID()
        HuaweiHelper.shared.searchGateway(completion: { gateways in
            self.gateway = gateways.first
            if let deviceMac = self.gateway?.deviceMac {
                HuaweiHelper.shared.getONTRegisterStatus(devId: deviceMac, completion: { _ in
                    HuaweiHelper.shared.getFamilyRegisterInfoOnCloud(devId: deviceMac, completion: { familyRegInfo in
                        if !familyRegInfo.isJoinFamily {
                            self.locationManager = CLLocationManager()
                            self.locationManager?.delegate = self
                            self.locationManager?.requestWhenInUseAuthorization()
                        } else {
                            self.gateway = nil
                            self.notConnected()
                        }
                    }) { _ in
                        self.gateway = nil
                        self.notConnected()
                    }
                }) { _ in
                    self.gateway = nil
                    self.notConnected()
                }
            }
        }) { _ in
            DispatchQueue.main.async {
                self.gateway = nil
                self.notConnected()
            }
        }
    }
}

extension GetConnectViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if status != .denied && status != .notDetermined {
        if let ssid = self.getWiFiName() {
            ssidName = ssid
            connectedTo(wifiName: ssid)
            self.tryAgainButton.setTitle("CONFIRM", for: .normal)
        } else {
            notConnected()
            self.tryAgainButton.setTitle("TRY AGAIN", for: .normal)
        }
    } else if status == .denied {
        let alertActions: [UIAlertAction] = [
            UIAlertAction(title: NSLocalizedString("Open Settings", comment: ""), style: .default, handler: { _ in
                if let url = URL(string:UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }),
            UIAlertAction(title: NSLocalizedString("Later", comment: ""), style: .cancel, handler: { _ in
                self.dismissVC()
            })
        ]
        
        self.showAlertMessage(title: "Error", message: "Please go to Settings and turn on location permission", actions: alertActions)
    }
  }
}
