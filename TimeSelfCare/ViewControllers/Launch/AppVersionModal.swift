//
//  AppVersionModal.swift
//  TimeSelfCare
//
//  Created by Raviteja Gadige on 10/04/2020.
//  Copyright © 2020 Apptivity Lab. All rights reserved.
//

import UIKit

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
        let dict    = dictionary.object(forKey: "version") as? NSDictionary
        latest      = "\(dict?["latest"] ?? "")"
        major       = "\(dict?["major"] ?? "")"
        major_title = "\(dict?["major_title"] ?? "")"
        major_text  = "\(dict?["major_text"] ?? "")"
        minor       = "\(dict?["minor"] ?? "")"
        minor_title = "\(dict?["minor_title"] ?? "")"
        minor_text  = "\(dict?["minor_text"] ?? "")"
        url         = "\(dict?["url"] ?? "")"
    }

    deinit {
        print("App Version Modal deinit")
    }
}
