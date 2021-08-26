//
//  VIdeoCategoryViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 09/08/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol VideoCategoryViewDelegate {
    func categoryDidSelect(type: String)
}

class VideoCategoryViewController: PopUpViewController {

    @IBOutlet private weak var categoryView: UIView!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var scrollViewHeight: NSLayoutConstraint!
    
    var videos: [Video] = []
    var selectedCategory = ""
    var delegate: VideoCategoryViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        for item in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(item)
            item.removeFromSuperview()
        }
        
        let categoryView = VideoCategory(text: "All categories", hideDivider: true)
        if selectedCategory == "" || selectedCategory.contains("All") {
            categoryView.typeLabel.textColor = UIColor(hex: "#8B8B8B")
        }
        categoryView.delegate = self
        stackView.addArrangedSubview(categoryView)
        
        let categories = videos.map { $0.videoCategory }
        for item in Set(categories).sorted(by: { $0?.lowercased() ?? "" < $1?.lowercased() ?? "" }) {
            let categoryView = VideoCategory(text: item ?? "")
            if selectedCategory == item {
                categoryView.typeLabel.textColor = UIColor(hex: "#8B8B8B")
            }
            categoryView.delegate = self
            stackView.addArrangedSubview(categoryView)
        }
        
        scrollViewHeight.constant = CGFloat(20 + ((Set(categories).count + 1) * 54))

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        categoryView.roundCorners(corners: [.topLeft, .topRight], radius: 9.0)
    }

    @IBAction func actMainView(_ sender: Any) {
        self.hideAnimate {
        }
    }
}

extension VideoCategoryViewController: VideoCategoryDelegate {
    func categoryDidSelect(type: String) {
        self.hideAnimate {
            self.delegate?.categoryDidSelect(type: type)
        }
    }
}
