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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back_arrow"), style: .plain, target: self, action: #selector(self.dismissVC(_:)))
        self.title = NSLocalizedString("Diagnostics", comment: "")
        Keyboard.addKeyboardChangeObserver(self)

        iconImageView.image = UIImage()
        messageLabel.text = ""
        raiseTicket.alpha = 0
        backButton.alpha = 0

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
                let diagnostics = Diagnostics(with: result)

                if let htmlData = diagnostics?.message?.data(using: String.Encoding.unicode) {
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
                        self.iconImageView.download(from: diagnostics?.icon ?? "")
                        self.backButton.alpha = 1
                    } catch let e as NSError {
                        print(e)
                    }
                }
            }
        }
    }

    @IBAction func raiseTicket(_ sender: UIButton) {
        print(AccountController.shared.selectedAccount?.accountNo)
    }

    @IBAction func backToHomepage(_ sender: UIButton) {
        self.dismissVC()
    }
//    @objc
//    private func createTicket() {
//        let ticket = Ticket(id: "")
//        ticket.categoryOptions = TicketDataController.shared.categoryOptions
//        for i in 0..<componentViews.count {
//            guard let component = TicketFormComponent(rawValue: i) else {
//                continue
//            }
//
//            switch component {
//            case .category:
//                ticket.displayCategory = componentViews[i].text
//            case .title:
//                ticket.subject = componentViews[i].text
//            case .message:
//                ticket.description = componentViews[i].text
//            }
//        }
//        ticket.accountNo = AccountController.shared.selectedAccount?.accountNo
//
//        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//        hud.label.text = NSLocalizedString("Creating ticket...", comment: "")
//        let images: [UIImage] = self.selectedImageInfo.compactMap {
//            guard var image = $0[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage else {
//                return nil
//            }
//
//            let ratio = max(
//                max(image.size.width, image.size.height) / 1_920,
//                min(image.size.width, image.size.height) / 1_080
//            )
//            if ratio > 1 {
//                image = image.scaledTo(scale: 1 / ratio)
//            }
//            return image
//        }
//
//        TicketDataController.shared.createTicket(ticket, account: AccountController.shared.selectedAccount, attachments: images) { (error: Error?) in
//            hud.hide(animated: true)
//            if let error = error {
//                self.showAlertMessage(with: error)
//                return
//            }
//
//            let confirmationVC: ConfirmationViewController = UIStoryboard(name: TimeSelfCareStoryboard.common.filename, bundle: nil).instantiateViewController()
//            confirmationVC.mode = .ticketSubmitted
//            confirmationVC.actionBlock = {
//                self.dismissVC()
//            }
//            self.present(confirmationVC, animated: true, completion: nil)
//        }
//    }

}

extension DiagnosisViewController: KeyboardChangeObserver {
    func keyboardChanging(endHeight: CGFloat, duration: TimeInterval) {
        self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: endHeight, right: 0)
    }
}
