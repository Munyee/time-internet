//
//  ResetDeviceViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 09/04/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import UIKit

class ResetDeviceViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("DEVICE INSTALLATION", comment: "")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back_arrow"), style: .done, target: self, action: #selector(self.popBack))
    }
    
    @objc
    func popBack() {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func actNext(_ sender: Any) {
        if let vc = UIStoryboard(name: TimeSelfCareStoryboard.deviceinstallation.filename, bundle: nil).instantiateViewController(withIdentifier: "TurnOnDeviceViewController") as? TurnOnDeviceViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}
