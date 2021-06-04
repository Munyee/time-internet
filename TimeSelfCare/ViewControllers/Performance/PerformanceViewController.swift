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
import MBProgressHUD

public extension NSNotification.Name {
    static let ConnectionStatusDidUpdate: NSNotification.Name = NSNotification.Name(rawValue: "ConnectionStatusDidUpdate")
}

let kIsConnected: String = "IsConnected"

class PerformanceViewController: BaseViewController {
    
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var animationView: LOTAnimationView!
    @IBOutlet private weak var runDiagnosticsButton: UIButton!
    @IBOutlet private weak var speedTestView: UIView!
    @IBOutlet private weak var nceView: UIView!
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.checkConnectionStatus()
        timer?.invalidate()
    }
    
    @objc
    func didTappedAttributedLabel(gesture: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: TimeSelfCareStoryboard.diagnostics.filename, bundle: nil)
        let diagnosticsVC: DiagnosisViewController = storyboard.instantiateViewController()
        self.presentNavigation(diagnosticsVC, animated: true)
    }
    
    @IBAction private func checkConnectionStatus() {
        animationView.setAnimation(named: "Loading")
        animationView.loopAnimation = true
        animationView.play()
        
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
                    }
                }
            }
        }
        
        self.statusLabel.text = NSLocalizedString("Checking connectivity status...", comment: "")
        AccountDataController.shared.loadConnectionStatus(account: account, service: service) { _, error in
            let isConnected: Bool = error == nil
            self.animationView.setAnimation(named: isConnected ? "GoodConnection" : "BadConnection")
            self.animationView.loopAnimation = false
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
    
    @IBAction func actParentalControl(_ sender: Any) {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = NSLocalizedString("Loading...", comment: "")
        HuaweiHelper.shared.queryGateway(completion: { _ in
            hud.hide(animated: true)
            if let templateVC = UIStoryboard(name: TimeSelfCareStoryboard.parentalcontrol.filename, bundle: nil).instantiateViewController(withIdentifier: "PCTemplateListViewController") as? PCTemplateListViewController {
                self.presentNavigation(templateVC, animated: true)
            }
        }, error: { _ in
            hud.hide(animated: true)
            self.showNotAvailable()
        })
    }
    
    @IBAction func actWifiConfiguration(_ sender: Any) {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = NSLocalizedString("Loading...", comment: "")
        HuaweiHelper.shared.queryGateway(completion: { _ in
            hud.hide(animated: true)
            if let wifiConfVC = UIStoryboard(name: TimeSelfCareStoryboard.wificonfiguration.filename, bundle: nil).instantiateViewController(withIdentifier: "WifiConfigurationViewController") as? WifiConfigurationViewController {
                wifiConfVC.gateway = self.gateway
                self.presentNavigation(wifiConfVC, animated: true)
            }
        }, error: { _ in
            hud.hide(animated: true)
            self.showNotAvailable()
        })
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
            print(gateways)
            if !gateways.isEmpty {
                AccountController.shared.gatewayDevId = gateways.first(where: { !$0.deviceId.isEmpty })?.deviceId
                self.gateway = gateways.first(where: { !$0.deviceId.isEmpty })
                
                self.connectionStackView.isHidden = false
                self.nceFeatureView.isHidden = true
                self.nceView.isHidden = false
                self.speedTestView.isHidden = false
                self.nceFeatureSmallView.isHidden = true
                HuaweiHelper.shared.queryGateway(completion: { gateway in
                    HuaweiHelper.shared.queryLanDeviceCount { result in
                        self.numberOfDevice.text = "\(result.lanDeviceCount)"
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
                }, error: { _ in
                })
            } else {
                if AccountController.shared.noOfGateway! > 0 {
                    self.connectionStackView.isHidden = false
                    self.nceFeatureView.isHidden = true
                    self.nceView.isHidden = false
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
                    } else {
                        self.speedTestView.isHidden = true
                        self.nceFeatureView.isHidden = true
                        self.connectionStackView.isHidden = false
                        self.nceFeatureSmallView.isHidden = false
                        self.nceView.isHidden = true
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
