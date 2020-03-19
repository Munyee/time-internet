//
//  Setting.swift
//  ApptivityFramework
//
//  Created by AppLab on 07/08/2017.
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import UIKit

public class Setting {

    public let name: String
    public let value: String

    init(name: String, value: String) {
        self.name = name
        self.value = value
    }

    init?(with json: [String : Any]) {
        guard let name: String = json["name"] as? String,
            let value: String = json["value"] as? String else {
                return nil
        }

        self.name = name
        self.value = value
    }
}
