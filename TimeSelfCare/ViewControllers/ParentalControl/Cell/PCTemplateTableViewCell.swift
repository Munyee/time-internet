//
//  PCTemplateTableViewCell.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 22/02/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import UIKit
import HwMobileSDK

protocol PCTemplateTableViewCellDelegate {
    func templateUpdated()
}

class PCTemplateTableViewCell: UITableViewCell {
    
    var delegate: PCTemplateTableViewCellDelegate?
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var numDevice: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var templateSwitch: UISwitch!
    
    var ctrlTemplate: HwAttachParentControlTemplate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func actToggle(_ sender: Any) {
        let template = ctrlTemplate ?? HwAttachParentControlTemplate()
        template.enable = templateSwitch.isOn
        template.urlFilterEnable = templateSwitch.isOn
        
        HuaweiHelper.shared.setAttachParentControlTemplate(ctrlTemplate: template, completion: { _ in
             self.delegate?.templateUpdated()
        }) { _ in
        }
    }
    
}
