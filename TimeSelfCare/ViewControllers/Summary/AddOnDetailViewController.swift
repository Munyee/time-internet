//
//  AddOnDetailViewController.swift
//  TimeSelfCare
//
//  Created by Loka on 28/11/2017.
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import UIKit
import SDWebImage

internal class AddOnDetailViewController: TimeBaseViewController {
    var addOn: AddOn! // swiftlint:disable:this implicitly_unwrapped_optional

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var modelLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var featureLabel: UILabel!
    @IBOutlet private weak var orderLabel: UILabel!
    @IBOutlet private weak var amountLabel: UILabel!
    @IBOutlet private weak var transactionDateLabel: UILabel!
    @IBOutlet private weak var warrantyPeriodLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = addOn.item
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back_arrow"), style: .plain, target: self, action: #selector(self.backToPreviousVC))
        self.modelLabel.text = addOn.model
        if let imageURLString = addOn.image {
            self.imageView.sd_setImage(with: URL(string: imageURLString))
        }
        if let isUnderWarraty = addOn.isUnderWarranty {
            self.statusLabel.isHidden = false
            self.statusLabel.backgroundColor = isUnderWarraty ? .positive  : .grey2
            self.statusLabel.text = isUnderWarraty ? NSLocalizedString("UNDER WARRANTY", comment: "") : NSLocalizedString("OUT OF WARRANTY", comment: "")
        } else {
            self.statusLabel.isHidden = true
        }
        self.featureLabel.text = addOn.features
        self.orderLabel.text = addOn.orderId

        self.transactionDateLabel.text = addOn.datetime?.string(usingFormat: "d MMM yyyy") ?? "-"
        if let startDAte = addOn.warrantyStartDate?.string(usingFormat: "d MMM yyyy"),
            let endDate = addOn.warrantyEndDate?.string(usingFormat: "d MMM yyyy") {
            self.warrantyPeriodLabel.text = "\(startDAte) - \(endDate)"
        } else {
            self.warrantyPeriodLabel.text = "-"
        }
    }

    @IBAction func viewFAQ(_ sender: Any) {
        openURL(withURLString: "http://www.time.com.my/support/faq?section=hardware&question=do-i-have-to-install-it-myself")
    }

    @objc
    private func backToPreviousVC() {
        self.dismissVC()
    }
}
