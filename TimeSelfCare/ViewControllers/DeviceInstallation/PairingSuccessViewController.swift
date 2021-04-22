//
//  PairingSuccessViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 14/04/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import UIKit

class PairingSuccessViewController: UIViewController {

    @IBOutlet private weak var apImage: UIImageView!
    var apType: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("DEVICE INSTALLATION", comment: "")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back_arrow"), style: .done, target: self, action: #selector(self.popBack))
        if let ap = apType {
            apImage.image = UIImage(named: "success_pairing_\(ap.lowercased())")
        }
    }
    
    @objc
    func popBack() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func actDone(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }

}
