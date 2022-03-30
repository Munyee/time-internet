//
//  PerformanceViewController.swift
//  TimeSelfCare
//
//  Created by Loka on 17/05/2018.
//  Copyright © 2018 Apptivity Lab. All rights reserved.
//

import UIKit
import Lottie
import HwMobileSDK
import SwiftyJSON

public extension NSNotification.Name {
    static let ConnectionStatusDidUpdate: NSNotification.Name = NSNotification.Name(rawValue: "ConnectionStatusDidUpdate")
}

let kIsConnected: String = "IsConnected"

class PerformanceViewController: BaseViewController {
    
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var animationView: AnimationView!
    @IBOutlet private weak var runDiagnosticsButton: UIButton!
    @IBOutlet private weak var speedTestView: UIView!
    @IBOutlet private weak var nceView: UIView!
    @IBOutlet private weak var nonNceView: UIView!
    @IBOutlet private weak var numberOfDevice: UILabel!
    @IBOutlet private weak var downSpeed: UILabel!
    @IBOutlet private weak var downByte: UILabel!
    @IBOutlet private weak var upSpeed: UILabel!
    @IBOutlet private weak var upByte: UILabel!
    @IBOutlet private weak var connectionStackView: UIStackView!
    @IBOutlet private weak var nceFeatureView: UIStackView!
    @IBOutlet private weak var nceFeatureSmallView: UIView!
    
    var gateway: HwUserBindedGateway?
    
    let kIsSetupNCE = "is_setup_nce"
    
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.connectionStackView.isHidden = false
        self.nceFeatureSmallView.isHidden = true
        self.nceFeatureView.isHidden = true
        speedTestView.isHidden = true
        nceView.isHidden = true
        nonNceView.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.checkConnectionStatus()
        self.getNCE()
        timer?.invalidate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    func didTappedAttributedLabel(gesture: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: TimeSelfCareStoryboard.diagnostics.filename, bundle: nil)
        let diagnosticsVC: DiagnosisViewController = storyboard.instantiateViewController()
        self.presentNavigation(diagnosticsVC, animated: true)
    }
    
    @IBAction private func checkConnectionStatus() {
        animationView.animation = Animation.named("Loading")
        animationView.loopMode = .playOnce
        animationView.play()
        guard
            let account = AccountController.shared.selectedAccount,
            let service: Service = ServiceDataController.shared.getServices(account: account).first(where: { $0.category == .broadband || $0.category == .broadbandAstro })
            else {
                return
        }
        
        self.statusLabel.text = NSLocalizedString("Checking connectivity status...", comment: "")
        AccountDataController.shared.loadConnectionStatus(account: account, service: service) { _, error in
            let isConnected: Bool = error == nil
            self.animationView.animation = Animation.named(isConnected ? "GoodConnection" : "BadConnection")
            self.animationView.loopMode = .playOnce
            self.animationView.play()
            
            if isConnected {
                self.statusLabel.attributedText = self.attributedText(withString: "Your internet connection is good.", boldString: "good", color: UIColor.green, font: self.statusLabel.font)
            } else {
                self.statusLabel.attributedText = self.attributedText(withString: "Your internet connection is down.\n Connection issue detected", boldString: "down", color: UIColor.red, font: self.statusLabel.font)
            }
            
            self.runDiagnosticsButton.isEnabled = true
            self.runDiagnosticsButton.backgroundColor = self.runDiagnosticsButton.isEnabled ? .primary : .grey2
            NotificationCenter.default.post(name: NSNotification.Name.ConnectionStatusDidUpdate, object: nil, userInfo: [kIsConnected: isConnected])
        }
    }
    
    func getNCE() {
        guard
            let account = AccountController.shared.selectedAccount,
            let service: Service = ServiceDataController.shared.getServices(account: account).first(where: { $0.category == .broadband || $0.category == .broadbandAstro })
            else {
                return
        }
        
        var isCustSegments = account.custSegment == .residential
        #if DEBUG
            isCustSegments = account.custSegment == .residential || account.custSegment == .business
        #endif

        if isCustSegments {
            AccountDataController.shared.isUsingHuaweiDevice(account: account, service: service) { data, error in
                guard error == nil else {
                    print(error.debugDescription)
                    return
                }
                
                if let result = data {
                    let huaweiDevice = IsHuaweiDevice(with: result)
                    if huaweiDevice?.status == "yes" {
                        self.queryBindGateway()
                    } else {
                        self.nonNceView.isHidden = false
                    }
                }
            }
        }
    }
    
    @IBAction func runDiagnosticsCheck(_ sender: Any) {
        let storyboard = UIStoryboard(name: TimeSelfCareStoryboard.diagnostics.filename, bundle: nil)
        let diagnosticsVC: DiagnosisViewController = storyboard.instantiateViewController()
        self.presentNavigation(diagnosticsVC, animated: true)
    }
    
    func attributedText(withString string: String, boldString: String, color: UIColor, font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string, attributes: [NSAttributedString.Key.font: font])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: font.pointSize)]
        let range = (string as NSString).range(of: boldString)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        attributedString.addAttributes(boldFontAttribute, range: range)
        return attributedString
    }
    
    @IBAction func changeSsid(_ sender: Any?) {
        
        if let ssidEnabled = SsidDataController.shared.getSsids(account: AccountController.shared.selectedAccount).first?.isEnabled, ssidEnabled {
            let storyboard = UIStoryboard(name: TimeSelfCareStoryboard.performance.filename, bundle: nil)
            let changeSsidVC: ChangeSSIDViewController = storyboard.instantiateViewController()
            self.presentNavigation(changeSsidVC, animated: true)
        } else {
            if var vc = UIApplication.shared.keyWindow?.rootViewController {
                while let presentedViewController = vc.presentedViewController {
                    vc = presentedViewController
                }
                if let alertView = UIStoryboard(name: TimeSelfCareStoryboard.pppoe.filename, bundle: nil).instantiateViewController(withIdentifier: "PppoeAlertViewController") as? PppoeAlertViewController {
                    alertView.pppoeType = .error
                    vc.addChild(alertView)
                    alertView.view.frame = vc.view.frame
                    vc.view.addSubview(alertView.view)
                    alertView.didMove(toParent: vc)
                }
            }
        }
    }
    
    @IBAction func actpppoe(_ sender: Any) {
        let account = AccountController.shared.selectedAccount! // swiftlint:disable:this force_unwrapping
        
        guard
            let service: Service = ServiceDataController.shared.getServices(account: account).first(where: { $0.category == .broadband || $0.category == .broadbandAstro })
            else {
                return
        }
        
        let hud = LoadingView().addLoading(toView: self.view)
        hud.showLoading()
        AccountDataController.shared.getPPPOEInfo(account: account, service: service) { data, error in
            hud.hideLoading()
            guard error == nil else {
                if let nsError = error as NSError?, let responseCode = nsError.userInfo["reponseCode"] as? Int {
                    var pppoeType: PppoeAlertType = .error
                    switch responseCode {
                    case 3, 4:
                        pppoeType = .livechat
                    default:
                        pppoeType = .error
                    }
                    
                    if var vc = UIApplication.shared.keyWindow?.rootViewController {
                        while let presentedViewController = vc.presentedViewController {
                            vc = presentedViewController
                        }
                        if let alertView = UIStoryboard(name: TimeSelfCareStoryboard.pppoe.filename, bundle: nil).instantiateViewController(withIdentifier: "PppoeAlertViewController") as? PppoeAlertViewController {
                            alertView.pppoeType = pppoeType
                            vc.addChild(alertView)
                            alertView.view.frame = vc.view.frame
                            vc.view.addSubview(alertView.view)
                            alertView.didMove(toParent: vc)
                        }
                    }
                }
                return
            }
            
            if let result = data {
                let jsonData = JSON(result["message"])
                
                let storyboard = UIStoryboard(name: TimeSelfCareStoryboard.pppoe.filename, bundle: nil)
                let pppoe: PppoeViewController = storyboard.instantiateViewController()
                pppoe.username = jsonData["username"].stringValue
                pppoe.password = jsonData["password"].stringValue
                self.presentNavigation(pppoe, animated: true)
            }
        }
    }
    
    @IBAction func actParentalControl(_ sender: Any) {
        let hud = LoadingView().addLoading(toView: self.view)
        hud.showLoading()
        HuaweiHelper.shared.queryGateway(completion: { _ in
            hud.hideLoading()
            if let templateVC = UIStoryboard(name: TimeSelfCareStoryboard.parentalcontrol.filename, bundle: nil).instantiateViewController(withIdentifier: "PCTemplateListViewController") as? PCTemplateListViewController {
                self.presentNavigation(templateVC, animated: true)
            }
        }, error: { _ in
            hud.hideLoading()
            self.showNotAvailable()
        })
    }
    
    @IBAction func actDeviceInstallation(_ sender: Any) {
        let hud = LoadingView().addLoading(toView: self.view)
        hud.showLoading()
        HuaweiHelper.shared.queryGateway(completion: { _ in
            hud.hideLoading()
            if let templateVC = UIStoryboard(name: TimeSelfCareStoryboard.deviceinstallation.filename, bundle: nil).instantiateViewController(withIdentifier: "DeviceInstallationListViewController") as? DeviceInstallationListViewController {
                self.presentNavigation(templateVC, animated: true)
            }
        }, error: { _ in
            hud.hideLoading()
            self.showNotAvailable()
        })
    }
    
    @IBAction func actWifiConfiguration(_ sender: Any) {
//        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//        hud.label.text = NSLocalizedString("Loading...", comment: "")
//        HuaweiHelper.shared.queryGateway(completion: { _ in
//            hud.hide(animated: true)
//            if let wifiConfVC = UIStoryboard(name: TimeSelfCareStoryboard.wificonfiguration.filename, bundle: nil).instantiateViewController(withIdentifier: "WifiConfigurationViewController") as? WifiConfigurationViewController {
//                wifiConfVC.gateway = self.gateway
//                self.presentNavigation(wifiConfVC, animated: true)
//            }
//        }, error: { _ in
//            hud.hide(animated: true)
//            self.showNotAvailable()
//        })
        if let wifiConfVC = UIStoryboard(name: TimeSelfCareStoryboard.wificonfiguration.filename, bundle: nil).instantiateViewController(withIdentifier: "WifiConfigurationViewController") as? WifiConfigurationViewController {
            wifiConfVC.gateway = self.gateway
            self.presentNavigation(wifiConfVC, animated: true)
        }
    }
    
    @IBAction func bindGateway(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: kIsSetupNCE)
        if let bindVC = UIStoryboard(name: TimeSelfCareStoryboard.bindgateway.filename, bundle: nil).instantiateViewController(withIdentifier: "GetConnectViewController") as? GetConnectViewController {
            bindVC.delegate = self
            self.presentNavigation(bindVC, animated: true)
        }
    }
    
    @IBAction func actUseCurrentVersion(_ sender: Any) {
        connectionStackView.isHidden = false
        nceFeatureView.isHidden = true
        nceFeatureSmallView.isHidden = false
        UserDefaults.standard.set(true, forKey: kIsSetupNCE)
    }
    
    func showNotAvailable() {
        if let templateVC = UIStoryboard(name: TimeSelfCareStoryboard.performance.filename, bundle: nil).instantiateViewController(withIdentifier: "NotAvailableViewController") as? NotAvailableViewController {
            self.presentNavigation(templateVC, animated: true)
        }
    }
    
    func queryBindGateway() {
        let showAddnce = !UserDefaults.standard.bool(forKey: self.kIsSetupNCE)
        
        HuaweiHelper.shared.queryUserBindGateway { gateways in
            self.gateway = gateways.first(where: { !$0.deviceId.isEmpty })

            if self.gateway != nil {
                AccountController.shared.gatewayDevId = gateways.first(where: { !$0.deviceId.isEmpty })?.deviceId
                
                self.connectionStackView.isHidden = false
                self.nceFeatureView.isHidden = true
                self.nceView.isHidden = false
                self.nonNceView.isHidden = true
                self.speedTestView.isHidden = false
                self.nceFeatureSmallView.isHidden = true
                HuaweiHelper.shared.queryGateway(completion: { gateway in
                    HuaweiHelper.shared.queryLanDeviceListEx { devices in
                        let arrDev = devices.filter { dev -> Bool in
                            return !dev.isAp && dev.onLine
                        }
                        self.numberOfDevice.text = "\(arrDev.count)"
                    } error: { exception in
                        DispatchQueue.main.async {
                            self.showAlertMessage(message: HuaweiHelper.shared.mapErrorMsg(exception?.errorCode ?? ""))
                        }
                    }
                    //            self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                    //                HuaweiHelper.shared.getGatewaySpeed { gatewaySpeed in
                    //                    let (downSpeed, downByte) = Units(kBytes: Int64(gatewaySpeed.downSpeed)).getReadable
                    //                    let (upSpeed, upByte) = Units(kBytes: Int64(gatewaySpeed.upSpeed)).getReadableUnit()
                    //                    self.downSpeed.text = "\(downSpeed)"
                    //                    self.downByte.text = "\(downByte)"
                    //                    self.upSpeed.text = "\(upSpeed)"
                    //                    self.upByte.text = "\(upByte)"
                    //                }
                    //            }
                }, error: { exception in
//                    DispatchQueue.main.async {
//                        self.showAlertMessage(message: HuaweiHelper.shared.mapErrorMsg(exception?.errorCode ?? "") ?? "")
//                    }
                })
            } else {
                if AccountController.shared.noOfGateway! > 0 {
                    self.connectionStackView.isHidden = false
                    self.nceFeatureView.isHidden = true
                    self.nceView.isHidden = false
                    self.nonNceView.isHidden = true
                    self.speedTestView.isHidden = false
                    self.nceFeatureSmallView.isHidden = true
                } else {
                    AccountController.shared.gatewayDevId = ""
                    if showAddnce {
                        self.speedTestView.isHidden = true
                        self.nceFeatureView.isHidden = false
                        self.connectionStackView.isHidden = true
                        self.nceFeatureSmallView.isHidden = true
                        self.nceView.isHidden = true
                        self.nonNceView.isHidden = true
                    } else {
                        self.speedTestView.isHidden = true
                        self.nceFeatureView.isHidden = true
                        self.connectionStackView.isHidden = false
                        self.nceFeatureSmallView.isHidden = false
                        self.nceView.isHidden = true
                        self.nonNceView.isHidden = true
                    }
                }
            }
        }
    }
}

extension PerformanceViewController: GetConnectViewControllerDelegate {
    func bindSuccessful() {
        queryBindGateway()
    }
}
