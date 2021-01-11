//
//  HookUpViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 16/06/2020.
//  Copyright © 2020 Apptivity Lab. All rights reserved.
//

import UIKit
import MBProgressHUD

class HookupViewController: TimeBaseViewController {

    public var huae: HUAE?
    @IBOutlet private weak var referralLabel: UILabel!
    @IBOutlet private weak var activatedLabel: UILabel!
    @IBOutlet private weak var discountLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var heightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("HOOK UP & EARN", comment: "")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back_arrow"), style: .done, target: self, action: #selector(self.dismissVC(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "hookups_notification_icon").withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(showNotifcation))
        heightConstraint.constant = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard
            let account = AccountController.shared.selectedAccount
            else {
                return
        }
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = NSLocalizedString("Loading...", comment: "")
        
        AccountDataController.shared.getHuaeInfo(account: account) { data, error in
            hud.hide(animated: true)
            guard error == nil else {
                return
            }
            if let result = data {
                self.huae = HUAE(with: result)
                self.updateUI(huae: self.huae)
            }
        }
    }
    
    @objc
    func showNotifcation() {
        let storyboard = UIStoryboard(name: "Activity", bundle: nil)
        let activityViewController: ActivityViewController = storyboard.instantiateViewController()
        activityViewController.filter = "huae"
        self.presentNavigation(activityViewController, animated: true)
    }
    
    func updateUI(huae: HUAE?) {
        if huae?.referral_status_list?.count ?? 0 > 0 {
            self.referralLabel.text = String(format: "%d", huae?.referral_status_list?.count ?? 0)
            let filteredDictionary = huae?.referral_status_list?.filter { _, value -> Bool in
                if let val = value as? NSDictionary {
                    let status = val.value(forKey: "status") as? String
                    return status == "Activated"
                }
                return false
            }
            self.activatedLabel.text = String(format: "%d", filteredDictionary?.count ?? 0)
            self.discountLabel.text = String(format: "RM%@", huae?.discount_balance ?? "0")
            self.dateLabel.text = "As of \(huae?.discount_bill_date ?? "")"
            UIView.animate(withDuration: 0.5) {
                self.heightConstraint.constant = 142
                self.view.layoutIfNeeded()
            }
        } else {
            heightConstraint.constant = 0
        }
        for child in self.children {
            if let shareVC = child as? ShareViewController {
                shareVC.data = huae
                shareVC.initView()
            } else if let referralVC = child as? ReferralViewController {
                referralVC.data = huae
                referralVC.initView()
            } else if let discountVC = child as? DiscountViewController {
                discountVC.data = huae
                discountVC.initView()
            }
        }
    }
    
    @IBAction func actReferral(_ sender: Any) {
        if let referralVC = UIStoryboard(name: TimeSelfCareStoryboard.hookup.filename, bundle: nil).instantiateViewController(withIdentifier: "ReferralViewController") as? ReferralViewController {
            self.navigationController?.pushViewController(referralVC, animated: true)
        }
    }
    
    @IBAction func actDiscount(_ sender: Any) {
        if let discountVC = UIStoryboard(name: TimeSelfCareStoryboard.hookup.filename, bundle: nil).instantiateViewController(withIdentifier: "DiscountViewController") as? DiscountViewController {
            discountVC.data = huae
            self.navigationController?.pushViewController(discountVC, animated: true)
        }
    }
}
