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

    @IBOutlet private var segmentView: UIView!
    @IBOutlet private weak var shareContainer: UIView!
    @IBOutlet private weak var referralContainer: UIView!
    @IBOutlet private weak var discountContainer: UIView!
    @IBOutlet private weak var howItWorkContainer: UIView!
    public var huae: HUAE?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Hook Up & Earn", comment: "")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back_arrow"), style: .done, target: self, action: #selector(self.dismissVC(_:)))

        let segment = SegmentControl(frame: CGRect(x: 0, y: 0, width: self.segmentView.frame.width, height: self.segmentView.frame.height), buttonTitle: ["Share", "Referral Status", "Discount Status", "How it works?"])
        hideAllContainer()
        shareContainer.isHidden = false
        segment.delegate = self
        segmentView.addSubview(segment)
        
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
    
    func updateUI(huae: HUAE?) {
        
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
}

extension HookupViewController: SegmentControlDelegate {
    func hideAllContainer() {
        shareContainer.isHidden = true
        referralContainer.isHidden = true
        discountContainer.isHidden = true
        howItWorkContainer.isHidden = true
    }

    func changeToIndex(index: Int) {
        hideAllContainer()
        switch index {
        case 0:
            shareContainer.isHidden = false
        case 1:
            referralContainer.isHidden = false
        case 2:
            discountContainer.isHidden = false
        case 3:
            howItWorkContainer.isHidden = false
        default:
            break
        }
    }
}
