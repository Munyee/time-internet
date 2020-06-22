//
//  LiveChatPopUpViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 19/06/2020.
//  Copyright © 2020 Apptivity Lab. All rights reserved.
//

import UIKit

class LiveChatPopUpViewController: PopUpViewController {

    @IBOutlet weak var liveChatLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        let liveChatText = NSLocalizedString("Hi! Our live chat Support Ninjas are still on training wheels, so please bear with us! For now, our live chat operating hours are from 8am-10pm. In the meantime, get in touch with us on our Facebook Messenger instead!", comment: "")
        let attributedString = NSMutableAttributedString(string: liveChatText)
        let attributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.primary,
            NSAttributedString.Key.font: UIFont.getCustomFont(family: "DIN", style: .body) ?? UIFont.preferredFont(forTextStyle: .body)
        ]
        attributedString.addAttributes(attributes, range: (liveChatText as NSString).range(of: NSLocalizedString("Facebook Messenger", comment: "")))
        liveChatLabel.attributedText = attributedString
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTappedAttributedLabel(gesture:)))
        liveChatLabel.isUserInteractionEnabled = true
        liveChatLabel.addGestureRecognizer(tapGesture)
    }

    @objc
    func didTappedAttributedLabel(gesture: UITapGestureRecognizer) {
        let fullText = liveChatLabel.text ?? String()
        let termsText = "Facebook Messenger"
        let termsRange = (fullText as NSString).range(of: termsText)
//        if gesture.didTapAttributedTextInLabel(label: liveChatLabel, inRange: termsRange) {
            self.openMessenger()
//        }
    }

    func openMessenger() {
        openURL(withURLString: "http://m.me/TIMEinternet")
    }

    @IBAction func actDismiss(_ sender: Any) {
        self.hideAnimate {}
    }
}
