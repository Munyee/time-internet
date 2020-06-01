//
//  DiagnosisViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 04/11/2019.
//  Copyright © 2019 Apptivity Lab. All rights reserved.
//

import UIKit
import MBProgressHUD

class DiagnosisViewController: TimeBaseViewController {

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var raiseTicket: UIButton!
    @IBOutlet private weak var runSpeedTest: UIButton!
    @IBOutlet private weak var updateFirmware: UIButton!
    public var diagnostics: Diagnostics?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back_arrow"), style: .plain, target: self, action: #selector(self.dismissVC(_:)))
        self.title = NSLocalizedString("Diagnostics", comment: "")
        Keyboard.addKeyboardChangeObserver(self)

        iconImageView.image = UIImage()
        messageLabel.text = ""
        raiseTicket.alpha = 0
        backButton.alpha = 0
        runSpeedTest.alpha = 0
        updateFirmware.alpha = 0

        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = NSLocalizedString("Loading...", comment: "")

        guard
            let account = AccountController.shared.selectedAccount,
            let service: Service = ServiceDataController.shared.getServices(account: account).first(where: { $0.category == .broadband || $0.category == .broadbandAstro })
            else {
                return
        }

        AccountDataController.shared.runDiagnostic(account: account, service: service) { data, error in
            hud.hide(animated: true)
            guard error == nil else {
                return
            }
            if let result = data {
                self.diagnostics = Diagnostics(with: result)
                self.updateUI(diagnostics: self.diagnostics)
            }
        }
    }

    func triggerActionButton(action: String) {
        switch action {
        case "speed_test":
            self.backButton.alpha = 1
            self.runSpeedTest.alpha = 1
        case "raise_ticket":
            self.backButton.alpha = 1
            self.raiseTicket.alpha = 1
        case "upgrade_firmware":
            self.backButton.alpha = 1
            self.updateFirmware.alpha = 1
        default:
            self.backButton.alpha = 1
        }
    }

    @IBAction func raiseTicket(_ sender: UIButton) {
        let ticket = Ticket(id: "")
        ticket.categoryOptions = TicketDataController.shared.categoryOptions
        ticket.displayCategory = TicketDataController.shared.categoryOptions["conn"]
        ticket.subject = self.diagnostics?.subject
        ticket.description = ""
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

    @IBAction func actRunSpeedTest(_ sender: Any) {
        let timeWebView = TIMEWebViewController()
        let urlString = "https://testyourspeed.time.com.my/index2.php"
        let url = URL(string: urlString)
        timeWebView.url = url
        timeWebView.title = NSLocalizedString("Speed Test", comment: "")
        self.navigationController?.pushViewController(timeWebView, animated: true)
    }

    @IBAction func actUpdateFirmware(_ sender: Any) {
        let alert = UIAlertController(title: "Bear With Us!", message: "You'll be logged out shortly for the firmware update. The update will take approximately 1 hour. You may check your firmware update status again once it's done.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.label.text = NSLocalizedString("Loading...", comment: "")

            guard
                let account = AccountController.shared.selectedAccount,
                let service: Service = ServiceDataController.shared.getServices(account: account).first(where: { $0.category == .broadband || $0.category == .broadbandAstro })
                else {
                    return
            }

            AccountDataController.shared.upgradeFirmware(account: account, service: service) { data, error in
                self.updateFirmware.alpha = 0
                hud.hide(animated: true)
                guard error == nil else {
                    return
                }

                if let result = data {
                    self.diagnostics = Diagnostics(with: result)
                    self.updateUI(diagnostics: self.diagnostics)
                }
            }
        }))
        self.present(alert, animated: true, completion: ({
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
        }))
    }

    @objc
    func alertControllerBackgroundTapped() {
        self.dismiss(animated: true, completion: nil)
    }

    func updateUI(diagnostics: Diagnostics?) {
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
                    NSAttributedString.Key.font: UIFont.getCustomFont(family: "DIN", style: .body) ?? UIFont.preferredFont(forTextStyle: .body),
                    NSAttributedString.Key.paragraphStyle: titleParagraphStyle
                ]
                attributedText.addAttributes(attributes, range:  NSRange(location: 0, length: attributedText.mutableString.length))

                self.messageLabel.attributedText = attributedText
                self.iconImageView.download(from: self.diagnostics?.icon ?? "")
                self.triggerActionButton(action: self.diagnostics?.action ?? "")
            } catch let e as NSError {
                print(e)
            }
        }
    }

    @IBAction func backToHomepage(_ sender: UIButton) {
        self.dismissVC()
    }
}

extension DiagnosisViewController: KeyboardChangeObserver {
    func keyboardChanging(endHeight: CGFloat, duration: TimeInterval) {
        self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: endHeight, right: 0)
    }
}
