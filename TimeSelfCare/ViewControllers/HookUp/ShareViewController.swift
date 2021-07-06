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
    @IBOutlet private weak var tncView: UIView!
    
    let images = [#imageLiteral(resourceName: "spread_the_word"), #imageLiteral(resourceName: "track_progress"), #imageLiteral(resourceName: "enjoy_off")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    func initView() {
       // titleLabel.text = data?.title ?? ""
        desc.text = data?.description?.htmlAttributdString()?.string ?? ""
        
        if data?.title != nil {
            collectionView.isHidden = false
            shareButton.isHidden = false
            tncView.isHidden = false
        } else {
            collectionView.isHidden = true
            shareButton.isHidden = true
            tncView.isHidden = true
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
        if let referVC = UIStoryboard(name: "ReferView", bundle: nil).instantiateInitialViewController() as? ReferViewController {
            referVC.data = data
            self.navigationController?.pushViewController(referVC, animated: true)
        }
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
