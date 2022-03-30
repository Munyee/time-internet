//
//  ContactUsViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 15/11/2019.
//  Copyright © 2019 Apptivity Lab. All rights reserved.
//

import UIKit
import MessageUI

class ContactUsViewController: BaseAuthViewController {

    @IBOutlet weak var liveChat: LiveChatView!
    @IBOutlet private weak var containerView: UIStackView!
    @IBOutlet private weak var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        liveChat.layer.cornerRadius = 12
    }

    @IBAction func actCall(_ sender: UIButton) {
        if let url = URL(string: "tel://\(sender.titleLabel?.text?.replacingOccurrences(of: " ", with: "") ?? "")"),
            UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            print("Error from calling")
        }
    }

    @IBAction func actSendEmail(_ sender: UIButton) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([sender.titleLabel?.text ?? ""])
//            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)
            present(mail, animated: true)
        } else {
            print("Set up email!!")
        }
    }

    @IBAction func backToHome(_ sender: Any) {
        scrollView.delegate = nil
        self.navigationController?.popViewController(animated: true)
    }

}

extension ContactUsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
