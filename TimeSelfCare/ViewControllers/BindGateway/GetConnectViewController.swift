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
import Alamofire

protocol GetConnectViewControllerDelegate {
    func bindSuccessful()
}

class GetConnectViewController: UIViewController {
    
    var locationManager: CLLocationManager?
    var gateway: HwSearchedUserGateway?
    var ssidName: String = ""
    
    var delegate: GetConnectViewControllerDelegate?
    
    @IBOutlet weak var tryAgainButton: UIButton!
    @IBOutlet var ssidText: UILabel!
    @IBOutlet weak var errorMsg: UILabel!
    
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
        if Utils.isInternetAvailable() {
            if ssidName != "" && gateway != nil {
                if let deviceMac = self.gateway?.deviceMac {
                    
                    let hud = LoadingView().addLoading(toView: self.view)
                    hud.showLoading()
                    HuaweiHelper.shared.bindGateway(deviceMac: deviceMac, gatewayNickname: ssidName, completion: { _ in
                        hud.hideLoading()
                        self.delegate?.bindSuccessful()
                        self.dismissVC()
                    }, error: { _ in
                        self.failed()
                        hud.hideLoading()
                    })
                    
                } else {
                    self.gateway = nil
                    self.notConnected()
                }
            } else {
                self.failed()
                searchGateway()
            }
        } else {
            self.errorMsg.text = "You are not connected to any WiFi."
            notConnected()
        }
    }
    
    func checkingSSID() {
        ssidText.text = "Checking"
        ssidText.textColor = UIColor.black
        self.errorMsg.text = ""
    }
    
    func notConnected() {
        ssidText.text = "Not Connected"
        ssidText.textColor = UIColor(hex: "E50707")
        self.tryAgainButton.setTitle("TRY AGAIN", for: .normal)
    }
    
    func failed() {
        self.gateway = nil
        self.errorMsg.text = "Your connection may have been interrupted."
        ssidText.text = "Failed"
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
    
    func getWiFiMac() -> String? {
        var bssid: String?
        
        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
            for interface in interfaces {
                // swiftlint:disable force_cast
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                    bssid = interfaceInfo[kCNNetworkInfoKeyBSSID as String] as? String
                    break
                }
            }
        }
        
        return bssid
    }
    
    func searchGateway() {
        DispatchQueue.main.async {
            self.checkingSSID()
            
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
                                self.errorMsg.text = "The added features have already been activated on another account on this WiFi network."
                            }
                        }, error: { _ in
                            self.gateway = nil
                            self.notConnected()
                            self.errorMsg.text = "This network's router does not support the added features."
                        })
                    }, error: { _ in
                        self.gateway = nil
                        self.notConnected()
                        self.errorMsg.text = "This network's router does not support the added features."
                    })
                }
            }, error: { _ in
                DispatchQueue.main.async {
                    self.gateway = nil
                    self.notConnected()
                    self.errorMsg.text = "This network's router does not support the added features."
                }
            })
        }
    }
    
    func getDevicePortMapping(devId: String) {
        HuaweiHelper.shared.getPortMappingInfoWithDeviceId(deviceId: devId, completion: { arrPort in
            if !arrPort.isEmpty {
                if let wanName = arrPort.first?.wanName {
                    self.errorMsg.text = arrPort.first?.wanName
                    
                    HuaweiHelper.shared.getPPPoEAccount(deviceId: devId, wanName: wanName, completion: { pppoeAccount in
                    }, error: { exception in
                        self.errorMsg.text = "Get PPPOE Account Failed - \(HuaweiHelper.shared.mapErrorMsg(exception?.errorCode ?? ""))"
                    })
                }
            }
        }, error: { exception in
            self.errorMsg.text = "Device Port Mapping Failed - \(HuaweiHelper.shared.mapErrorMsg(exception?.errorCode ?? ""))"
        })
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
        if let openSettingVC = UIStoryboard(name: TimeSelfCareStoryboard.bindgateway.filename, bundle: nil).instantiateViewController(withIdentifier: "OpenSettingViewController") as? OpenSettingViewController {
            self.presentNavigation(openSettingVC, animated: true)
        }
    }
  }
}
