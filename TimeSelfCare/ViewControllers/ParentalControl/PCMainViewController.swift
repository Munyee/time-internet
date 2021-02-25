//
//  PCMainViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 18/02/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import UIKit

class PCMainViewController: TimeBaseViewController {

    @IBOutlet weak var liveChatView: ExpandableLiveChatView!
    @IBOutlet weak var liveChatConstraint: NSLayoutConstraint!
    var hasData: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("PARENTAL CONTROLS", comment: "")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back_arrow"), style: .done, target: self, action: #selector(self.back))
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if liveChatView.isExpand {
            liveChatConstraint.constant = 0
        } else {
            liveChatConstraint.constant = -125
        }
    }
    
    @IBAction func actSetup(_ sender: Any) {
        if let profileVC = UIStoryboard(name: TimeSelfCareStoryboard.parentalcontrol.filename, bundle: nil).instantiateViewController(withIdentifier: "PCProfileViewController") as? PCProfileViewController {
            profileVC.isEdit = true
            self.navigationController?.pushViewController(profileVC, animated: true)
        }
    }
    
    @objc
    func back() {
        if hasData {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismissVC()
        }
    }
}
