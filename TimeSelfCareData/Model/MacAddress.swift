//
//  MacAddress.swift
//  TimeSelfCareData
//
//  Created by Chan Mun Yee on 15/03/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import Foundation

public class MacAddress: JsonRecord {
    public let status: String?
    public var mac_address: String?

    public init() {
        self.status = String()
        self.mac_address = String()
    }

    public required init?(with json: [String : Any]) {
        self.status = json["status"] as? String
        self.mac_address = json["mac_address"] as? String
    }
}
