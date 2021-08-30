//
//  ChangeWifiViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 02/03/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import CoreLocation
import UIKit
import HwMobileSDK
import SystemConfiguration.CaptiveNetwork
import MBProgressHUD
import Alamofire

protocol ChangeWifiViewControllerDelegate {
    func changeSuccess()
}

class ChangeWifiViewController: TimeBaseViewController {
    
    var locationManager: CLLocationManager?
    var oldGatewayId: String?
    var gateway: HwSearchedUserGateway?
    var ssidName: String = ""
    
    var delegate: ChangeWifiViewControllerDelegate?
    
    @IBOutlet weak var tryAgainButton: UIButton!
    @IBOutlet var ssidText: UILabel!
    @IBOutlet weak var errorMsg: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorMsg.text = ""
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_close_magenta"), style: .done, target: self, action: #selector(self.dismissVC(_:)))
        searchGateway()
    }
    
    @IBAction func actCancel(_ sender: Any) {
        self.dismissVC()
    }
    
    @IBAction func actRetry(_ sender: Any) {
        self.errorMsg.text = ""
        if Utils.isInternetAvailable() {
            if ssidName != "" && gateway != nil {
                if let deviceMac = self.gateway?.deviceMac, let oldGateway = self.oldGatewayId {
                    
                    let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                    hud.label.text = NSLocalizedString("Loading...", comment: "")
                    
                    if gateway?.deviceMac == oldGateway {
                        HuaweiHelper.shared.setGatewayNickname(deviceId: oldGateway, gatewayName: self.ssidName, completion: { _ in
                            self.delegate?.changeSuccess()
                            self.dismissVC()
                        }, error: { _ in
                            self.delegate?.changeSuccess()
                            self.dismissVC()
                        })
                    } else {
                        HuaweiHelper.shared.replaceGateway(oldDeviceMac: oldGateway, deviceMac: deviceMac, completion: { replaceGateway in
                            AccountController.shared.gatewayDevId = replaceGateway.deviceId
                            HuaweiHelper.shared.setGatewayNickname(deviceId: replaceGateway.deviceId, gatewayName: self.ssidName, completion: { _ in
                                self.delegate?.changeSuccess()
                                self.dismissVC()
                            }, error: { _ in
                                self.delegate?.changeSuccess()
                                self.dismissVC()
                            })
                        }, error: { _ in
                            self.failed()
                            hud.hide(animated: true)
                        })
                    }
                } else {
                    self.gateway = nil
                    self.notConnected()
                }
            } else {
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
    
    func searchGateway() {
        checkingSSID()
        HuaweiHelper.shared.searchGateway(completion: { gateways in
            self.gateway = gateways.first
            if let deviceMac = self.gateway?.deviceMac, let oldGateway = self.oldGatewayId {
                HuaweiHelper.shared.getONTRegisterStatus(devId: deviceMac, completion: { _ in
                    HuaweiHelper.shared.getFamilyRegisterInfoOnCloud(devId: deviceMac, completion: { familyRegInfo in
                        self.showAlertMessage(message: familyRegInfo.familyName)
                        if !familyRegInfo.isJoinFamily || self.gateway?.deviceMac == oldGateway {
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
                self.errorMsg.text = "This network's router does not support the added features."
                self.notConnected()
            }
        })
    }
    
}

extension ChangeWifiViewController: CLLocationManagerDelegate {
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
