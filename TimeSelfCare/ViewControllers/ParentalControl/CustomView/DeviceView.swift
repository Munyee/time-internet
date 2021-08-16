//
//  DeviceView.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 23/02/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import UIKit
import HwMobileSDK

protocol DeviceViewDelegate {
    func removeDevice(device: HwLanDevice)
    func showDevices()
}

class DeviceView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var mac: UILabel!
    @IBOutlet weak var deviceImg: UIImageView!
    @IBOutlet weak var closeView: UIControl!
    
    var device: HwLanDevice?
    var delegate: DeviceViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required init(device: HwLanDevice, isEdit: Bool) {
        super.init(frame: .zero)
        commonInit()
        self.device = device
        name.text = device.name != "" ? device.name : device.mac
        mac.text = device.mac
        closeView.isHidden = !isEdit
        
        HuaweiHelper.shared.queryLanDeviceManufacturingInfoList(macList: [device.mac]) { deviceTypeInfo in
            if let deviceInfo = deviceTypeInfo.first(where: { $0.mac == device.mac }) {
                self.setDeviceImg(device: deviceInfo.deviceType)
            }
        }
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("DeviceView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    @IBAction func actRemoveDevice(_ sender: Any) {
        if let dev = device {
            delegate?.removeDevice(device: dev)
        }
    }
    
    @IBAction func actSelect(_ sender: Any) {
        delegate?.showDevices()
    }
    
    func setDeviceImg(device: String) {
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
