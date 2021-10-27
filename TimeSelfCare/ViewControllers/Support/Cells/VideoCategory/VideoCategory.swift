//
//  VideoCategory.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 09/08/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import UIKit

protocol VideoCategoryDelegate {
    func categoryDidSelect(type: String)
}

class VideoCategory: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var typeDivider: UIView!
    @IBOutlet weak var typeLabel: UILabel!
    var delegate: VideoCategoryDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    required init(text: String) {
        super.init(frame: .zero)
        commonInit()
        typeLabel.text = text
    }
    
    required init(text: String, hideDivider: Bool) {
        super.init(frame: .zero)
        commonInit()
        typeDivider.isHidden = hideDivider
        typeLabel.text = text
    }
    
    @IBAction func categorySelected(_ sender: Any) {
        delegate?.categoryDidSelect(type: typeLabel.text ?? "")
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("VideoCategory", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}
