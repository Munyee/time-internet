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
    @IBOutlet private weak var voucherCodeLabel: UILabel!
    @IBOutlet private weak var voucherCodeImageView: UIImageView!

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
        self.voucherCodeLabel.text = reward.code?.first { $0.isValidURL == false }
        self.voucherCodeLabel.font = self.voucherCodeLabel.font.bold()
        if let voucherImagePath = reward.code?.first(where: { $0.isValidURL }) {
            self.voucherCodeImageView.sd_setImage(with: URL(string: voucherImagePath), completed: nil)
            self.voucherCodeImageView.isHidden = false
        } else {
            self.voucherCodeImageView.isHidden = true
        }
    }

    @IBAction func redeem(_ sender: Any) {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = NSLocalizedString("Redeeming...", comment: "")
        RewardDataController.shared.redeemReward(reward,
                                                 account: AccountController.shared.selectedAccount) { error in
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
