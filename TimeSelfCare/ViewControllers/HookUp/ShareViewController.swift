//
//  ShareViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 17/06/2020.
//  Copyright © 2020 Apptivity Lab. All rights reserved.
//

import UIKit

class ShareViewController: UIViewController {

    weak var data: HUAE?
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var desc: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var shareButton: UIButton!
    @IBOutlet private weak var consentView: UIView!
    @IBOutlet private weak var tncView: UIView!
    @IBOutlet private weak var joinMeView: UIView!
    @IBOutlet private weak var huaeLinkView: UIView!
    @IBOutlet private weak var huaeLinkLabel: UILabel!
    
    let images = [#imageLiteral(resourceName: "spread_the_word"), #imageLiteral(resourceName: "track_progress"), #imageLiteral(resourceName: "enjoy_off")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    func initView() {
       // titleLabel.text = data?.title ?? ""
        desc.text = data?.description?.htmlAttributdString()?.string ?? ""
        updateShareButton(show: false)
        huaeLinkLabel.text = data?.link
        huaeLinkView.isHidden = true
        if data?.title != nil {
            collectionView.isHidden = false
            shareButton.isHidden = false
            tncView.isHidden = false
            consentView.isHidden = false
            joinMeView.isHidden = false
        } else {
            collectionView.isHidden = true
            shareButton.isHidden = true
            tncView.isHidden = true
            consentView.isHidden = true
            joinMeView.isHidden = true
        }
    }

    func showTnc() {
        let timeWebView = TIMEWebViewController()
        let urlString = "https://www.time.com.my/terms-and-conditions?link=personal&title=HookUpAndEarn"
        let url = URL(string: urlString)
        timeWebView.url = url
        timeWebView.title = NSLocalizedString("TERMS & CONDITIONS", comment: "")
        self.navigationController?.pushViewController(timeWebView, animated: true)
    }
    
    func showFAQ() {
        let timeWebView = TIMEWebViewController()
        let urlString = "https://www.time.com.my/support/faq?section=self-care&question=who-is-eligible-for-this-programme"
        let url = URL(string: urlString)
        timeWebView.url = url
        timeWebView.title = NSLocalizedString("FAQ", comment: "")
        self.navigationController?.pushViewController(timeWebView, animated: true)
    }
    @IBAction func actTnC(_ sender: Any) {
        showTnc()
    }
    
    @IBAction func actFAQ(_ sender: Any) {
        showFAQ()
    }
    
    @IBAction func actRefer(_ sender: Any) {
//        if let referVC = UIStoryboard(name: "ReferView", bundle: nil).instantiateInitialViewController() as? ReferViewController {
//            referVC.data = data
//            self.navigationController?.pushViewController(referVC, animated: true)
//        }
        huaeLinkView.isHidden = false
        consentView.isHidden = true
        shareButton.isHidden = true
    }
    
    @IBAction func respondToAgreement(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        updateShareButton(show: sender.isSelected)
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
    
    @IBAction func copyLink(_ sender: Any) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = data?.link
        self.view.showToast(message: "Link Copied", font: .systemFont(ofSize: 12.0))
    }
    
    func updateShareButton(show: Bool) {
        shareButton.isUserInteractionEnabled = show
        shareButton.backgroundColor = show ? UIColor.primary : UIColor.lightGray
    }
}

extension ShareViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: self.view.bounds.width - 40, height: 220)
    }
}

extension ShareViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bannerCell", for: indexPath) as? BannerCollectionViewCell
        cell?.bannerImage.image = images[indexPath.row]
        return cell ?? UICollectionViewCell()
    }
}
