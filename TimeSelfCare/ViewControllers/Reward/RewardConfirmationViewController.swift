//
//  RewardConfirmationViewController.swift
//  TimeSelfCare
//
//  Created by Loka on 05/07/2019.
//  Copyright © 2019 Apptivity Lab. All rights reserved.
//

import UIKit
import SDWebImage
import MBProgressHUD

class RewardConfirmationViewController: TimeBaseViewController {
    @IBOutlet private weak var rewardImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var voucherStackView: UIStackView!

    var reward: Reward! // swiftlint:disable:this implicitly_unwrapped_optional

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("TIME Reward", comment: "")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back_arrow"), style: .done, target: self, action: #selector(self.dismissVC(_:)))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        
        if let imagePath = reward.image {
            self.rewardImageView?.sd_setImage(with: URL(string: imagePath), completed: nil)
        }
        self.nameLabel.text = reward.name

        if let voucherCodes = reward.code {
            for (index, voucherCode) in voucherCodes.enumerated() {
                if let voucherView = UINib(nibName: "EVoucherView", bundle:nil).instantiate(withOwner: nil, options: nil)[0] as? EVoucherView {
                    voucherView.voucherLabel.text = "E-Voucher Code \(index + 1)"
                    if (voucherCode.isValidURL) {
                        voucherView.voucherImg.sd_setImage(with: URL(string: voucherCode), completed: nil)
                        voucherView.voucherCode.isHidden = true
                        voucherView.voucherImg.isHidden = false
                    } else {
                        voucherView.voucherCode.text = voucherCode
                        voucherView.voucherCode.isHidden = false
                        voucherView.voucherImg.isHidden = true
                    }

                    voucherStackView.addArrangedSubview(voucherView)
                }
            }
        }

    }

    @IBAction func redeem(_ sender: Any) {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = NSLocalizedString("Redeeming...", comment: "")
        RewardDataController.shared.redeemReward(
            self.reward,
            account: AccountController.shared.selectedAccount
        ) { _, error in
            hud.hide(animated: true)
            if let error = error {
                self.showAlertMessage(with: error)
                return
            }

            let confirmationVC: ConfirmationViewController = UIStoryboard(name: TimeSelfCareStoryboard.common.filename, bundle: nil).instantiateViewController()
            confirmationVC.mode = .rewardRedeemed
            confirmationVC.actionBlock = {
                self.dismissVC()
            }
            self.present(confirmationVC, animated: true, completion: nil)
        }
    }
}
