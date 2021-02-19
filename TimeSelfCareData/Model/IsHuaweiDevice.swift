//
//  IsHuaweiDevice.swift
//  TimeSelfCareData
//
//  Created by Chan Mun Yee on 19/02/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import Foundation

public class IsHuaweiDevice: JsonRecord {
    public let status: String?
    public var message: String?

    public init() {
        self.status = String()
        self.message = String()
    }

    public required init?(with json: [String : Any]) {
//        guard
//            let data = json["data"] as? [String:Any]
//            else {
//                debugPrint("ERROR: Failed to construct IsHuaweiDevice from JSON\n\(json)")
//                return nil
//        }

        self.status = json["status"] as? String
        self.message = json["message"] as? String
    }
}
