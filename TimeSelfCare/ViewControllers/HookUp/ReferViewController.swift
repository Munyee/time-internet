//
//  ReferViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 29/09/2020.
//  Copyright © 2020 Apptivity Lab. All rights reserved.
//

import UIKit

class ReferViewController: TimeBaseViewController {

    @IBOutlet weak var singUpLabel: UILabel!
    weak var data: HUAE?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("HOOK UP & EARN", comment: "")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back_arrow"), style: .done, target: self, action: #selector(self.popBack))

        initView()
    }
    
    @objc
    func popBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func initView() {
        let message = data?.text?.htmlAttributedString?.string ?? ""
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.getCustomFont(family: "DIN", style: .subheadline) ?? UIFont.preferredFont(forTextStyle: .subheadline),
                                                         NSAttributedString.Key.foregroundColor: UIColor.black]
        let attributedString = NSMutableAttributedString(string: message, attributes: attributes)

        let underlineWord: String = data?.link ?? ""
        let separator: Character = " "
    
        if message.contains(underlineWord) {
            //            var locationCounts = 0
            let underlineAttribute: [NSAttributedString.Key: Any] = [.underlineColor: UIColor.primary,
                                                                     .underlineStyle: NSUnderlineStyle.single.rawValue,
                                                                     .foregroundColor: UIColor.primary]

            var count = 0
            let ranges: [NSRange] = message.split(separator: separator).compactMap { subString -> NSRange? in
                var subrange = (subString as NSString).localizedStandardRange(of: underlineWord)
                guard subrange.location != NSNotFound else {
                    count += (subString.count + 1)
                    return nil
                }
                subrange.location += count
                count += (subString.count + 1)
                return subrange
            }

            ranges.forEach {
                attributedString.addAttributes(underlineAttribute, range: $0)
            }
        }
        self.singUpLabel.attributedText
            = attributedString
    }
    
    @IBAction func openFacebook(_ sender: Any) {
        let url = String(format: "https://www.facebook.com/share.php?u=%@&quote=%@", data?.link ?? "", data?.fb_text ?? "")
        if let link = URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") {
          UIApplication.shared.open(link)
        }
    }
    
    @IBAction func openTwitter(_ sender: Any) {
        let url = String(format: "https://www.twitter.com/share?url=%@&text=%@", data?.link ?? "", data?.fb_text ?? "")
        if let link = URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") {
          UIApplication.shared.open(link)
        }
    }
    
    @IBAction func openWhatsapp(_ sender: Any) {
        let url = String(format: "https://api.whatsapp.com/send?text=%@", data?.whatsapp_text ?? "")
        if let link = URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") {
            if UIApplication.shared.canOpenURL(link) {
              UIApplication.shared.open(link)
            } else {
              print("Unable to open whatsapp")
            }
        }
    }
    
    @IBAction func openEmail(_ sender: Any) {
        let subject = data?.email_subject ?? ""
        let body = data?.email_text ?? ""
        let coded = "mailto:?subject=\(subject)&body=\(body)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        if let link = URL(string: coded ?? "") {
            if UIApplication.shared.canOpenURL(link) {
                UIApplication.shared.open(link)
            } else {
                print("Unable to open email")
            }
        }
    }
}
