//
//  PppoeAlertViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 03/08/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

enum PppoeAlertType {
    case error
    case livechat
}

import UIKit
import MBProgressHUD

class PppoeAlertViewController: PopUpViewController {

    @IBOutlet weak var alertDescLabel: UILabel!
    var pppoeType: PppoeAlertType = .error

    override func viewDidLoad() {
        super.viewDidLoad()

        if pppoeType == .livechat {
            let pppoeNotAvailable = NSLocalizedString("Your PPPoE info is not available. Reach out to us via Live Chat for more information.", comment: "")
            let attributedString = NSMutableAttributedString(string: pppoeNotAvailable)
            let attributes: [NSAttributedString.Key : Any] = [
                NSAttributedString.Key.foregroundColor: UIColor.primary,
                NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 14) ?? UIFont.preferredFont(forTextStyle: .body)
            ]
            attributedString.addAttributes(attributes, range: (pppoeNotAvailable as NSString).range(of: NSLocalizedString("Live Chat", comment: "")))
            alertDescLabel.attributedText = attributedString
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTappedAttributedLabel(gesture:)))
            alertDescLabel.isUserInteractionEnabled = true
            alertDescLabel.addGestureRecognizer(tapGesture)
        } else {
            let pppoeNotAvailable = NSLocalizedString("But we’re working on it so please try again later.", comment: "")
            alertDescLabel.text = pppoeNotAvailable
        }
    }

    @objc
    func didTappedAttributedLabel(gesture: UITapGestureRecognizer) {
        let fullText = alertDescLabel.text ?? String()
        let termsText = "Live Chat"
        let termsRange = (fullText as NSString).range(of: termsText)
        if gesture.didTapAttributedTextInLabel(label: alertDescLabel, inRange: termsRange) {
            self.openLiveChat()
        }
    }

    func openLiveChat() {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = NSLocalizedString("Loading...", comment: "")

        LiveChatDataController.shared.loadStatus { statusResult in
            hud.hide(animated: true)
            if let status = statusResult {
                if status == "online" {
                    if let selectedAccount = AccountController.shared.selectedAccount {
                        let user = FreshchatUser.sharedInstance()
                        let profile = selectedAccount.profile
                        user.firstName = profile?.fullname
                        user.email = profile?.email
                        user.phoneNumber = profile?.mobileNo
                        Freshchat.sharedInstance().setUser(user)
                        Freshchat.sharedInstance().setUserPropertyforKey("AccountNo", withValue: selectedAccount.accountNo)
                    }

                    let alert = UIAlertController(title: "Choose Option", message: nil, preferredStyle: .actionSheet)

                    alert.addAction(UIAlertAction(title: "Conversations", style: .default , handler:{ (UIAlertAction) in
                        Freshchat.sharedInstance().showConversations(self)
                    }))

                    alert.addAction(UIAlertAction(title: "FAQ", style: .default , handler:{ (UIAlertAction) in
                        Freshchat.sharedInstance().showFAQs(self)
                    }))

                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))

                    self.present(alert, animated: true, completion: nil)
                } else {
                    self.openURL(withURLString: "http://m.me/TIMEinternet")
                }
            }
        }
    }

    @IBAction func actDismiss(_ sender: Any) {
        self.hideAnimate {}
    }
    
    func viewController(forView: UIView) -> UIViewController? {
        var nr = forView.next
        while nr != nil && !(nr! is UIViewController) {
            nr = nr!.next
        }
        return nr as? UIViewController
    }

}
