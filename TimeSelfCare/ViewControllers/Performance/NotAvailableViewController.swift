//
//  NotAvailableViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 03/03/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import UIKit

class NotAvailableViewController: TimeBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_close_magenta"), style: .plain, target: self, action: #selector(self.dismissVC(_:)))
        // Do any additional setup after loading the view.
    }
    
    @IBAction func actBack(_ sender: Any) {
        self.dismissVC()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
