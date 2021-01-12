//
//  PerformanceViewController.swift
//  TimeSelfCare
//
//  Created by Loka on 17/05/2018.
//  Copyright © 2018 Apptivity Lab. All rights reserved.
//

import UIKit
import Lottie

public extension NSNotification.Name {
    static let ConnectionStatusDidUpdate: NSNotification.Name = NSNotification.Name(rawValue: "ConnectionStatusDidUpdate")
}

let kIsConnected: String = "IsConnected"

class PerformanceViewController: BaseViewController {

    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var animationView: LOTAnimationView!
    @IBOutlet var runDiagnosticsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.checkConnectionStatus()
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

        self.statusLabel.text = NSLocalizedString("Checking connectivity status...", comment: "")
        AccountDataController.shared.loadConnectionStatus(account: account, service: service) { _, error in
            let isConnected: Bool = error == nil
            self.animationView.setAnimation(named: isConnected ? "GoodConnection" : "BadConnection")
            self.animationView.loopAnimation = false
            self.animationView.play()
                
            if (isConnected) {
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
}
