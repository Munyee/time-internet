//
//  AppVersionModal.swift
//  TimeSelfCare
//
//  Created by Raviteja Gadige on 10/04/2020.
//  Copyright © 2020 Apptivity Lab. All rights reserved.
//

import UIKit

class AppVersionModal: NSObject {
    var latest  = ""
    var major   = ""
    var minor   = ""
    var url     = ""
    var urlApp  = ""

    override init() {
        super.init()
    }

    init(dictionary: NSDictionary) {
        let dict    = dictionary.object(forKey: "version") as? NSDictionary
        latest      = "\(dict?["latest"] ?? "")"
        major       = "\(dict?["major"] ?? "")"
        minor       = "\(dict?["minor"] ?? "")"
        url         = "\(dict?["url"] ?? "")"
        urlApp      = "\(dict?["url_app"] ?? "")"
    }

    deinit {
        print("App Version Modal deinit")
    }
}
