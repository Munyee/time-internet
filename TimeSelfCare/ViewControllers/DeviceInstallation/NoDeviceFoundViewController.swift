//
//  NoDeviceFoundViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 09/04/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import UIKit

protocol NoDeviceFoundViewControllerDelegate {
    func backToHome()
}

class NoDeviceFoundViewController: UIViewController {

    var delegate: NoDeviceFoundViewControllerDelegate?
    var noDeviceCount = 0
    @IBOutlet weak var descLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("DEVICE INSTALLATION", comment: "")
        
        if let noDeviceFoundCount = UserDefaults.standard.value(forKey: "NO_DEVICE_FOUND") as? Int {
            noDeviceCount = noDeviceFoundCount
            UserDefaults.standard.set(noDeviceFoundCount + 1, forKey: "NO_DEVICE_FOUND")
        }
        
        if noDeviceCount >= 2 {
            self.descLabel.text = "Please reset your device and try again."
        } else if noDeviceCount == 1 {
            self.descLabel.text = "Please ensure your device is turned on."
        } else {
            self.descLabel.text = "Please restart your router and device."
        }

        // Do any additional setup after loading the view.
    }
    
    @IBAction func actRetry(_ sender: Any) {
        if noDeviceCount >= 2 {
            if let vc = UIStoryboard(name: TimeSelfCareStoryboard.deviceinstallation.filename, bundle: nil).instantiateViewController(withIdentifier: "ResetDeviceViewController") as? ResetDeviceViewController {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            self.dismissVC()
        }
    }
    
    @IBAction func backToHome(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.backToHome()
        }
    }
}
