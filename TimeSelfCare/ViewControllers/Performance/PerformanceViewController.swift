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
    @IBOutlet private weak var issueDetect: UILabel!

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

            self.statusLabel.text = isConnected ? NSLocalizedString("Your internet connection is good.", comment: "") : NSLocalizedString("Your internet connection is down.", comment: "")

            if (isConnected) {
                self.issueDetect.alpha = 0
            } else {
                self.issueDetect.alpha = 1
                let attributedString = NSMutableAttributedString(string: self.issueDetect.text ?? "")
                let attributes: [NSAttributedString.Key : Any] = [
                    NSAttributedString.Key.foregroundColor: UIColor.primary,
                    NSAttributedString.Key.font: UIFont.getCustomFont(family: "DIN", style: .body) ?? UIFont.preferredFont(forTextStyle: .body)
                ]
                attributedString.addAttributes(attributes, range: (self.issueDetect.text! as NSString).range(of: NSLocalizedString("diagnostics", comment: "")))
                self.issueDetect.attributedText = attributedString
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTappedAttributedLabel(gesture:)))
                self.issueDetect.isUserInteractionEnabled = true
                self.issueDetect.addGestureRecognizer(tapGesture)
            }

            NotificationCenter.default.post(name: NSNotification.Name.ConnectionStatusDidUpdate, object: nil, userInfo: [kIsConnected: isConnected])
        }
    }
}
