//
//  ShareViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 17/06/2020.
//  Copyright © 2020 Apptivity Lab. All rights reserved.
//

import UIKit

class ShareViewController: UIViewController {

    weak var data: HUAE?
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var desc: UILabel!
    @IBOutlet private weak var subject: UILabel!
    @IBOutlet private weak var text: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var shareButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    func initView() {
        titleLabel.text = data?.title ?? ""
        desc.text = data?.description ?? ""
        subject.text = data?.subject ?? ""
        text.text = data?.text ?? ""
        
        if data?.title != nil {
            imageView.isHidden = false
            shareButton.isHidden = false
        } else {
            imageView.isHidden = true
            shareButton.isHidden = true
        }
    }

    func share() {
        let items = ["Sign up for the TIME Fibre Home Broadband 500Mbps plan and pay just RM99 for the first 3 months! Get started now at huae.time.com.my/?2735036"]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }

    @IBAction func actShare(_ sender: Any) {
        share()
    }
}
