//
//  AppVersionModal.swift
//  TimeSelfCare
//
//  Created by Raviteja Gadige on 10/04/2020.
//  Copyright © 2020 Apptivity Lab. All rights reserved.
//

import UIKit
import SwiftyJSON

class AppVersionModal: NSObject {
    var latest      = ""
    var major       = ""
    var major_title = ""
    var major_text  = ""
    var minor       = ""
    var minor_title = ""
    var minor_text  = ""
    var url         = ""

    override init() {
        super.init()
    }

    init(dictionary: NSDictionary) {
        let dict = dictionary.object(forKey: "version") as? NSDictionary
        let json = JSON(dict)
        latest = json["latest"].stringValue
        major = json["major"].stringValue
        major_title = json["major_title"].stringValue
        major_text = json["major_text"].stringValue
        minor = json["minor"].stringValue
        minor_title = json["minor_title"].stringValue
        minor_text = json["minor_text"].stringValue
        url = json["url"].stringValue
    }

    deinit {
        print("App Version Modal deinit")
    }
}

class MaintenanceMode: NSObject {
    var is_maintenance = false
    var maintenance_title = ""
    var maintenance_text = ""
    
    override init() {
        super.init()
    }
    
    init (json: JSON) {
        is_maintenance = json["is_maintenance"].boolValue
        maintenance_title = json["maintenance_title"].stringValue
        maintenance_text = json["maintenance_text"].stringValue
    }
    
    deinit {
        print("MaintenanceMode Modal deinit")
    }
}
