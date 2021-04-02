//
//  PCDeviceTableViewCell.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 22/02/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import UIKit

class PCDeviceTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var mac: UILabel!
    @IBOutlet weak var radioImg: UIImageView!
    @IBOutlet weak var deviceImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setChosen(chosen: Bool) {
        if chosen {
            radioImg.image = UIImage(#imageLiteral(resourceName: "ic_tick"))
        } else {
            radioImg.image = UIImage(#imageLiteral(resourceName: "ic_unselect_radio"))
        }
    }
    
    func setDeviceImg(device: String, isOnline: Bool) {
        if isOnline {
            deviceImg.tintColor = .primary
        } else {
            deviceImg.tintColor = UIColor(hex: "8B8B8B")
        }
        switch device {
        case "PC":
            deviceImg.image = UIImage(#imageLiteral(resourceName: "ic_device_pc"))
        case "SmartPhone":
            deviceImg.image = UIImage(#imageLiteral(resourceName: "ic_device_smartphone"))
        case "PAD":
            deviceImg.image = UIImage(#imageLiteral(resourceName: "ic_device_pad"))
        case "STB":
            deviceImg.image = UIImage(#imageLiteral(resourceName: "ic_device_stb"))
        case "OTTTvBox":
            deviceImg.image = UIImage(#imageLiteral(resourceName: "ic_device_otttv"))
        case "SmartTV":
            deviceImg.image = UIImage(#imageLiteral(resourceName: "ic_device_smarttv"))
        case "Router":
            deviceImg.image = UIImage(#imageLiteral(resourceName: "ic_device_router"))
        case "SmartSpeaker":
            deviceImg.image = UIImage(#imageLiteral(resourceName: "ic_device_speaker"))
        case "Camera":
            deviceImg.image = UIImage(#imageLiteral(resourceName: "ic_device_camera"))
        case "Watch":
            deviceImg.image = UIImage(#imageLiteral(resourceName: "ic_device_watch"))
        case "Games":
            deviceImg.image = UIImage(#imageLiteral(resourceName: "ic_device_games"))
        case "Other":
            deviceImg.image = UIImage(#imageLiteral(resourceName: "ic_device_other"))
        default:
            deviceImg.image = UIImage(#imageLiteral(resourceName: "ic_device_other"))
        }
    }

}
