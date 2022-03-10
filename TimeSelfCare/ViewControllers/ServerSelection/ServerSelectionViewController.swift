//
//  ServerSelectionViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 03/03/2022.
//  Copyright © 2022 Apptivity Lab. All rights reserved.
//

import UIKit

protocol ServerSelectionDelegate {
    func update(server: String)
}

class ServerSelectionViewController: UIViewController {

    @IBOutlet weak var prodButton: UIButton!
    @IBOutlet weak var stagingButton: UIButton!
    @IBOutlet weak var staging2Button: UIButton!
    @IBOutlet weak var staging3Button: UIButton!
    let mode: String = UserDefaults.standard.string(forKey: Installation.kMode) ?? "Production"
    var delegate: ServerSelectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if mode == "Production" {
            select(button: prodButton)
        } else if mode == "Staging" {
            select(button: stagingButton)
        } else if mode == "BB Staging 2" {
            select(button: staging2Button)
        } else if mode == "BB Staging 3" {
            select(button: staging3Button)
        }
    }
    
    func reset() {
        prodButton.isSelected = false
        stagingButton.isSelected = false
        staging2Button.isSelected = false
        staging3Button.isSelected = false
    }
    
    func select(button: UIButton) {
        reset()
        button.isSelected = true
    }
    
    @IBAction func actSelectMode(_ sender: UIButton) {
        reset()
        sender.isSelected = true
    }
    
    @IBAction func actUpdate(_ sender: Any) {
        
        var mode = "Production"
        
        if prodButton.isSelected {
            mode = "Production"
        } else if stagingButton.isSelected {
            mode = "Staging"
        } else if staging2Button.isSelected {
            mode = "BB Staging 2"
        } else if staging3Button.isSelected {
            mode = "BB Staging 3"
        }
        
//        if mode == "Staging" {
//            appVersion = "\(appVersion) (Staging)"
//        } else if mode == "BB Staging 2" {
//             appVersion = "\(appVersion) (BB Staging 2)"
//        }  else if mode == "BB Staging 3" {
//            appVersion = "\(appVersion) (BB Staging 3)"
//        } else if mode == "Production" {
//             appVersion = "\(appVersion)"
//        }
    
        delegate?.update(server: mode)
        self.dismiss(animated: true, completion: nil)
    }
}
