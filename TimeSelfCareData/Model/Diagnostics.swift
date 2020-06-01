//
//  Diagnostics.swift
//  TimeSelfCareData
//
//  Created by Chan Mun Yee on 19/05/2020.
//  Copyright © 2020 Apptivity Lab. All rights reserved.
//

import Foundation

public class Diagnostics: JsonRecord {
    public let message: String?
    public var icon: String?
    public var action: String?
    public var category: String?
    public var subject: String?

    public init() {
        self.message = String()
        self.icon = String()
        self.action = String()
        self.category = String()
        self.subject = String()
    }

    public required init?(with json: [String : Any]) {
        guard
            let data = json["data"] as? [String:Any]
            else {
                debugPrint("ERROR: Failed to construct Diagnostics from JSON\n\(json)")
                return nil
        }

        self.message = data["msg"] as? String
        self.icon = data["icon"] as? String
        self.action = data["action"] as? String
        self.category = data["category"] as? String
        self.subject = data["subject"] as? String
    }
}
