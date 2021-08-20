//
//  DiagnosisViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 04/11/2019.
//  Copyright © 2019 Apptivity Lab. All rights reserved.
//

import UIKit
import MBProgressHUD
import Lottie
import SwiftyJSON

class DiagnosisViewController: TimeBaseViewController {

//    @IBOutlet private weak var iconImageView: UIImageView!
//    @IBOutlet private weak var messageLabel: UILabel!
//    @IBOutlet private weak var backButton: UIButton!
//    @IBOutlet private weak var raiseTicket: UIButton!
//    @IBOutlet private weak var runSpeedTest: UIButton!
//    @IBOutlet private weak var updateFirmware: UIButton!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var animationView: AnimationView!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var signalView: UIView!
    @IBOutlet private weak var signalLabel: UILabel!
    @IBOutlet private weak var signalImageView: UIImageView!
    @IBOutlet private weak var problemView: UIView!
    @IBOutlet private weak var problemLabel: UILabel!
    @IBOutlet weak var noWifiView: UIView!
    @IBOutlet private weak var suggestionLabel: UILabel!
    @IBOutlet private weak var actionButton: UIButton!
    @IBOutlet private weak var runSpeedTestView: UIView!
    
    public var diagnostics: Diagnostics?
    var finalScore = 0.0
    let pingTarget = 4
    var action = ""
//    var pinger = try? SwiftyPing(host: "start.highfive.com", configuration: PingConfiguration(interval: 0.5, with: 5), queue: DispatchQueue.global())
    var pinger = try? SwiftyPing(host: "1.1.1.1", configuration: PingConfiguration(interval: 0.5, with: 5), queue: DispatchQueue.global())

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back_arrow"), style: .plain, target: self, action: #selector(self.dismissVC(_:)))
        self.title = NSLocalizedString("DIAGNOSTICS", comment: "")

        runDiagnostics()
        
        animationView.isHidden = true
    }

    func triggerActionButton(action: String) {
        switch action {
        case "speed_test":
            if HuaweiHelper.shared.getRSSISignal() > 0 {
                actionButton.setTitle("RUN DIAGNOSTICS AGAIN", for: .normal)
                startPing()
            } else {
                actionButton.setTitle("TRY AGAIN", for: .normal)
                noWifiView.isHidden = false
            }
            self.runSpeedTestView.isHidden = false
        case "raise_ticket":
            actionButton.setTitle("RAISE TICKET", for: .normal)
        case "upgrade_firmware":
            actionButton.setTitle("UPDATE FIRMWARE", for: .normal)
        default:
            break
        }
    }
    
    func startPing() {
        if HuaweiHelper.shared.getRSSISignal() > 0 {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.label.text = NSLocalizedString("Pinging...", comment: "")
            pinger?.targetCount = pingTarget
            self.finalScore = 0
            pinger?.observer = { response in
                let duration = response.duration * 1_000
                let linkrate = ceil(self.calculateLinkRate(Units(kBytes: Int64(LinkRate.getRouterLinkSpeed() / 1_024)).getRateInMbps()))
                let rssi = ceil(self.calculateRSSIScore(HuaweiHelper.shared.getRSSISignal()))
                let latency = ceil(self.calculateLatecyScore(duration))
                let score = ceil((linkrate * 30 / 100)) + ceil(rssi * 30 / 100) + ceil(latency * 40 / 100)
                guard let currentCount = self.pinger?.currentCount else {
                    return
                }
                let pingCount = currentCount + 1
                self.finalScore = (self.finalScore + score)
                
                if pingCount == self.pingTarget {
                    hud.hide(animated: true)
                    let score = self.finalScore / Double(self.pingTarget)
                    if self.action == "speed_test" {
                        self.signalView.isHidden = false
                        if score >= 80 {
                            self.signalLabel.text = "GOOD"
                            self.signalLabel.textColor = UIColor(hex: "#EC008C")
                            self.signalImageView.image = #imageLiteral(resourceName: "ic_signal_good")
                            self.problemView.isHidden = true
                        } else if score >= 60 && score < 80 {
                            self.signalLabel.text = "FAIR"
                            self.signalLabel.textColor = UIColor(hex: "#3BBFBB")
                            self.signalImageView.image = #imageLiteral(resourceName: "ic_signal_fair")
                            self.problemView.isHidden = false
                            self.problemLabel.text = "You may be experiencing high latency, which can translate to slower video streaming, lag in games and delays in your overall Internet experience."
                            self.setupSuggestLabel()
                        } else if score < 60 {
                            self.signalLabel.text = "WEAK"
                            self.signalLabel.textColor = UIColor(hex: "#D9541E")
                            self.signalImageView.image = #imageLiteral(resourceName: "ic_signal_weak")
                            self.problemView.isHidden = false
                            self.problemLabel.text = "The connection is weak here which may cause your device to frequently disconnect from the WiFi."
                            self.setupSuggestLabel()
                        }
                    }
                }
            }
            try? pinger?.startPinging()
        } else {
            noWifiView.isHidden = false
            signalView.isHidden = true
            problemView.isHidden = true
        }
    }
    
    func setupSuggestLabel() {
        let suggestion = NSLocalizedString("Place your router in a central location free from clutter. Try using your device closer to the router or enhance WiFi coverage with our OmniMesh devices. Visit our shop.", comment: "")
        let attributedString = NSMutableAttributedString(string: suggestion)
        let attributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.primary,
            NSAttributedString.Key.font: UIFont(name: "DIN-Light", size: 14) ?? UIFont.preferredFont(forTextStyle: .body)
        ]
        attributedString.addAttributes(attributes, range: (suggestion as NSString).range(of: NSLocalizedString("Visit our shop.", comment: "")))
        suggestionLabel.attributedText = attributedString
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTappedAttributedLabel(gesture:)))
        suggestionLabel.isUserInteractionEnabled = true
        suggestionLabel.addGestureRecognizer(tapGesture)
        
    }
    
    @objc
    func didTappedAttributedLabel(gesture: UITapGestureRecognizer) {
        let shopVC: ShopViewController = UIStoryboard(name: TimeSelfCareStoryboard.shop.filename, bundle: nil).instantiateViewController()
        self.presentNavigation(shopVC, animated: true)
    }
    
    func runDiagnostics() {
        stackView.isHidden = true
        runSpeedTestView.isHidden = true
        signalView.isHidden = true
        problemView.isHidden = true
        noWifiView.isHidden = true
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = NSLocalizedString("Performing Diagnostics...", comment: "")
        guard
            let account = AccountController.shared.selectedAccount,
            let service: Service = ServiceDataController.shared.getServices(account: account).first(where: { $0.category == .broadband || $0.category == .broadbandAstro })
            else {
                return
        }

        AccountDataController.shared.runDiagnostic(account: account, service: service) { data, error in
            hud.hide(animated: true)
            guard error == nil else {
                self.showAlertMessage(message: error?.localizedDescription ?? "Something Went Wrong", actions: [
                    UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .destructive) { _ in
                        self.dismissVC()
                    }
                ])
                return
            }
            if let result = data {
                self.diagnostics = Diagnostics(with: result)
                self.updateUI(diagnostics: self.diagnostics)
            }
        }
    }

    func raiseTicket() {
        TicketDataController.shared.loadTickets(account: AccountController.shared.selectedAccount) { (_ , error: Error?) in
            let ticket = Ticket(id: "")
            ticket.categoryOptions = TicketDataController.shared.categoryOptions
            ticket.displayCategory = TicketDataController.shared.categoryOptions[self.diagnostics?.category ?? "con"]
            ticket.subject = self.diagnostics?.subject
            ticket.description = self.diagnostics?.message
            ticket.accountNo = AccountController.shared.selectedAccount?.accountNo

            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.label.text = NSLocalizedString("Creating ticket...", comment: "")

            TicketDataController.shared.createTicket(ticket, account: AccountController.shared.selectedAccount, attachments: []) { _, error in
                hud.hide(animated: true)
                if let error = error {
                    self.showAlertMessage(with: error)
                    return
                }

                let confirmationVC: ConfirmationViewController = UIStoryboard(name: TimeSelfCareStoryboard.common.filename, bundle: nil).instantiateViewController()
                confirmationVC.mode = .ticketSubmitted
                confirmationVC.actionBlock = {
                    self.dismissVC()
                }
                confirmationVC.modalPresentationStyle = .fullScreen
                self.present(confirmationVC, animated: true, completion: nil)
            }
        }
    }
    
    func actUpdateFirmware() {
        let alert = UIAlertController(title: "Bear With Us!", message: "You'll be logged out shortly for the firmware update. The update will take approximately 1 hour. You may check your firmware update status again once it's done.", preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(title: "OK", style: .default, handler: { action in
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                hud.label.text = NSLocalizedString("Loading...", comment: "")
                
                guard
                    let account = AccountController.shared.selectedAccount,
                    let service: Service = ServiceDataController.shared.getServices(account: account).first(where: { $0.category == .broadband || $0.category == .broadbandAstro })
                else {
                    return
                }
                
                AccountDataController.shared.upgradeFirmware(account: account, service: service) { data, error in
                    hud.hide(animated: true)
                    guard error == nil else {
                        return
                    }
                    
                    if let result = data {
                        self.diagnostics = Diagnostics(with: result)
                        self.updateUI(diagnostics: self.diagnostics)
                    }
                }
            })
        )
        self.present(alert, animated: true, completion: ({
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
        }))
    }
    
    func goToShop() {
        let shopVC: ShopViewController = UIStoryboard(name: TimeSelfCareStoryboard.shop.filename, bundle: nil).instantiateViewController()
        self.presentNavigation(shopVC, animated: true)
    }

    @IBAction func actRunSpeedTest(_ sender: Any) {
        let timeWebView = TIMEWebViewController()
        let urlString = "https://testyourspeed.time.com.my/index2.php"
        let url = URL(string: urlString)
        timeWebView.url = url
        timeWebView.title = NSLocalizedString("Speed Test", comment: "")
        self.navigationController?.pushViewController(timeWebView, animated: true)
    }
    
    @IBAction func actMainButtonPressed(_ sender: Any) {
        switch action {
        case "speed_test":
            if HuaweiHelper.shared.getRSSISignal() > 0 {
                self.runDiagnostics()
            } else {
                startPing()
            }
        case "raise_ticket":
            self.raiseTicket()
        case "upgrade_firmware":
            self.actUpdateFirmware()
        default:
            self.runDiagnostics()
        }
    }
    
    @objc
    func alertControllerBackgroundTapped() {
        self.dismiss(animated: true, completion: nil)
    }

    func updateUI(diagnostics: Diagnostics?) {
        stackView.isHidden = false
        if let htmlData = self.diagnostics?.message?.data(using: String.Encoding.unicode) {
            do {

                let attributedText = try NSMutableAttributedString(
                    data: htmlData,
                    options: [.documentType: NSAttributedString.DocumentType.html,
                              .characterEncoding: String.Encoding.utf8.rawValue
                    ],
                    documentAttributes: nil)

                let titleParagraphStyle = NSMutableParagraphStyle()
                titleParagraphStyle.alignment = .center
                let attributes: [NSAttributedString.Key : Any] = [
                    NSAttributedString.Key.font: UIFont(name: "DINCondensed-Bold", size: 22) ?? UIFont.preferredFont(forTextStyle: .body),
                    NSAttributedString.Key.paragraphStyle: titleParagraphStyle
                ]
                attributedText.addAttributes(attributes, range:  NSRange(location: 0, length: attributedText.mutableString.length))

                self.messageLabel.attributedText = attributedText
                if self.diagnostics?.icon?.contains(".json") {
                    self.iconImageView.isHidden = true
                    self.animationView.isHidden = false
                    if let url = URL(string: "https://assets5.lottiefiles.com/packages/lf20_tufwyy1s.json") {
                        Animation.loadedFrom(url: url, closure: { animation in
                            self.animationView.animation = animation
                            self.animationView.loopMode = .playOnce
                            self.animationView.play()
                        }, animationCache: LRUAnimationCache.sharedCache)
                    }
                } else {
                    self.animationView.isHidden = true
                    self.iconImageView.isHidden = false
                    self.iconImageView.download(from: self.diagnostics?.icon ?? "")
                }
                self.triggerActionButton(action: self.diagnostics?.action ?? "")
                self.action = self.diagnostics?.action ?? ""
            } catch let e as NSError {
                print(e)
            }
        }
    }
    
    func calculateLatecyScore(_ latency: Double) -> Double {
        if latency < 20 {
            let deductScore = latency * 1
            return (100.0 - deductScore)
        } else if latency >= 20 && latency < 100 {
            let deductScore = (latency - 20) * 0.25
            return (80.0 - deductScore)
        } else if latency >= 100 && latency < 300 {
            let deductScore = (latency - 100) * 0.15
            return (60.0 - deductScore)
        }
        
        return 0.0
    }
    
    func calculateLinkRate(_ linkrate: Double) -> Double {
        if linkrate > 300 {
            return 100
        } else if linkrate >= 150 && linkrate <= 300 {
            let deductScore = (300 - linkrate) / 15
            return (100 - deductScore)
        } else {
            return 0
        }
    }
    
    func calculateRSSIScore(_ rssi: Int) -> Double {
        if rssi == 3 {
            return 95
        } else if rssi == 2 {
            return 75
        } else if rssi == 1 {
            return 30
        } else {
            return 0
        }
    }
}
