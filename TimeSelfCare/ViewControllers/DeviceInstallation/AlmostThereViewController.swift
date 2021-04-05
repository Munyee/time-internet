//
//  AlmostThereViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 05/04/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import UIKit

class AlmostThereViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("DEVICE INSTALLATION", comment: "")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back_arrow"), style: .done, target: self, action: #selector(self.popBack))
    }
    
    @objc
    func popBack() {
        self.navigationController?.popViewController(animated: true)
    }

}
