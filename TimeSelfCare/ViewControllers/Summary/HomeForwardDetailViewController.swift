//
//  HomeForwardDetailViewController.swift
//  TimeSelfCare
//
//  Created by Loka on 06/12/2017.
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import UIKit
import SDWebImage

internal class HomeForwardDetailViewController: TimeBaseViewController {
    let THF_MAX_GENCOUNT: Int = 6

    // swiftlint:disable implicitly_unwrapped_optional
    var service: Service!

    @IBOutlet private weak var qrImageView: UIImageView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var regenerateButton: UIButton!
    // swiftlint:enable implicitly_unwrapped_optional

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = service.serviceId
        if let urlString = service?.thfQrcodeUrl {
            qrImageView.sd_setImage(with:  URL(string: urlString), placeholderImage: nil) { _, error, _, _ in
                if let error = error {
                    debugPrint(error.localizedDescription)
                }
            }
        }

        if service.thfQrcodeGenCount != nil && service.thfQrcodeGenCount! <= THF_MAX_GENCOUNT {     // swiftlint:disable:this force_unwrapping
            self.descriptionLabel.text = "Launch the TIME VOICE APP and scan the code to activate your service. To add more devices, click on the REGENERATE QR Code. Connect up to 6 devices."
            self.regenerateButton.isEnabled = true
        } else {
            self.descriptionLabel.text = "You may generate QR codes for up to 6 devices."
            self.regenerateButton.isEnabled = false
        }
    }

    @IBAction func regenerateQRCode(_ sender: Any) {
        guard let account = AccountController.shared.selectedAccount else {
            return
        }
        let hud = LoadingView().addLoading(toView: self.view)
        hud.showLoading()
        APIClient.shared.generateTHRCode(AccountController.shared.profile.username, account: account, service: service) { ( _, error: Error?) in
            hud.hideLoading()
            if let error = error {
                self.showAlertMessage(with: error)
                return
            }
            self.descriptionLabel.text = self.service.thfQrcodeCode
        }
    }

    @IBAction func downloadApp(_ sender: Any) {
        guard let url: URL = URL(string: "https://apps.apple.com/my/app/time-voice-app/id1041966811") else {
            return
        }
        UIApplication.shared.open(url)
    }
}
