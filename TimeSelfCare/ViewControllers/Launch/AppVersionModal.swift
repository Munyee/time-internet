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
    
    static let NOTICE_POPUP_VERSION: String = "notice_popup_version"
    
    var maintenance_password = ""
    var is_maintenance = false
    var maintenance_title = ""
    var maintenance_text = ""
    var show_notice = false
    var notice_message = ""
    var notice_message_v2 = ""
    var notice_message_href: [Href] = []
    var notice_auto_popup: NoticePopUp = NoticePopUp()

    override init() {
        super.init()
    }
    
    init (json: JSON) {
        maintenance_password = json["maintenance_password"].stringValue
        is_maintenance = json["is_maintenance"].boolValue
        maintenance_title = json["maintenance_title"].stringValue
        maintenance_text = json["maintenance_text"].stringValue
        show_notice = json["show_notice"].boolValue
        notice_message = json["notice_message"].stringValue
        notice_message_v2 = json["notice_message_v2"].stringValue
        for hrefJson in json["notice_message_href"].arrayValue {
            notice_message_href.append(Href(json: hrefJson))
        }
        notice_auto_popup = NoticePopUp(json: json["notice_auto_popup"])
    }
    
    deinit {
        print("MaintenanceMode Modal deinit")
    }
}

public class Href: NSObject {
    var href = ""
    var desc = ""

    override init() {
        super.init()
    }
    
    init (json: JSON) {
        href = json["href"].stringValue
        desc = json["desc"].stringValue
    }
}

public class NoticePopUp: NSObject {
    var ver = ""
    var desc = ""

    override init() {
        super.init()
    }
    
    init (json: JSON) {
        ver = json["ver"].stringValue
        desc = json["desc"].stringValue
    }
}
