//
//  PppoeViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 16/07/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import UIKit

class PppoeViewController: UIViewController {

    @IBOutlet private weak var liveChatView: ExpandableLiveChatView!
    @IBOutlet private weak var liveChatConstraint: NSLayoutConstraint!
    @IBOutlet private weak var pppoeUsername: UILabel!
    @IBOutlet private weak var pppoePassword: UILabel!
    @IBOutlet private weak var passwordButton: UIButton!
    
    var username = ""
    var password = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.liveChatView.isHidden = false
        self.title = NSLocalizedString("PPPOE CREDENTIALS", comment: "")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back_arrow"), style: .done, target: self, action: #selector(self.dismissVC(_:)))
        pppoeUsername.text = username
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.liveChatView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.liveChatView.isHidden = false
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if liveChatView.isExpand {
            liveChatConstraint.constant = 0
        } else {
            liveChatConstraint.constant = -125
        }
    }
    
    @IBAction func actPasswordButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            pppoePassword.text = password
        } else {
            pppoePassword.text = "••••••••"
        }
    }
}
