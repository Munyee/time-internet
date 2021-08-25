//
//  ConnectedDevice.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 18/05/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import UIKit
import HwMobileSDK

class ConnectedDevice: UIView {
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var deviceName: UILabel!
    @IBOutlet private weak var deviceMac: UILabel!
    @IBOutlet private weak var deviceImg: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required init?(device: HwLanDevice, deviceTypeInfo: HwDeviceTypeInfo) {
        super.init(frame: .zero)
        commonInit()
        deviceName.text = device.name ?? "-"
        deviceName.text = device.mac ?? "-"
        
        switch deviceTypeInfo.deviceType {
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

    private func commonInit() {
        Bundle.main.loadNibNamed("ConnectedDevice", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}
