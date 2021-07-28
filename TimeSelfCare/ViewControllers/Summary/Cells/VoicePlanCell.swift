//
//  VoicePlanCell.swift
//  TimeSelfCare
//
//  Created by Loka on 21/11/2017.
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol VoicePlanCellDelegate: class {
    func voicePlanCell(_ voicePlanCell: VoicePlanCell, regenerateQRCode service: Service)
}

internal class VoicePlanCell: UITableViewCell {
    private let THF_MAX_GENCOUNT: Int = 6
    private var service: Service?
    weak var delegate: VoicePlanCellDelegate?

    @IBOutlet private weak var qrImageView: UIImageView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var regenerateButton: UIButton!

    func configure(with service: Service) {
        self.service = service

        if let urlString = service.thfQrcodeUrl {
            qrImageView.sd_setImage(with:  URL(string: urlString), placeholderImage: nil) { _, error, _, _ in
                if let error = error {
                    debugPrint(error.localizedDescription)
                }
            }
        }

        if service.thfQrcodeGenCount != nil && service.thfQrcodeGenCount! <= THF_MAX_GENCOUNT {     // swiftlint:disable:this force_unwrapping
            self.descriptionLabel.text = NSLocalizedString("Launch the TIME HOME Forward app and scan the code above to activate your service. To add more devices, click on REGENERATE QR CODE. Connect up to 6 devices.", comment: "")
            self.regenerateButton.isEnabled = true
        } else {
            self.descriptionLabel.text = NSLocalizedString("You may generate QR codes for up to 6 devices.", comment: "")
            self.regenerateButton.isEnabled = false
        }
    }

    @IBAction func regenerateQRCode(_ sender: Any) {
        if let service = self.service {
            delegate?.voicePlanCell(self, regenerateQRCode: service)
        }
    }

    @IBAction func downloadApp(_ sender: Any) {
        guard let url: URL = URL(string: "https://apps.apple.com/my/app/time-voice-app/id1041966811") else {
            return
        }
        UIApplication.shared.open(url)
    }
}
