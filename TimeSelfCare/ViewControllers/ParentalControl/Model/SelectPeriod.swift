//
//  SelectPeriod.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 23/02/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import Foundation
import HwMobileSDK

public class SelectPeriod {
    public var index: Int?
    public var startTime: String?
    public var endTime: String?
    public var dayOfWeeks: [kHwDayOfWeek]?
    public var repeatMode: HwRepeatMode?
    
    public required init?(with data: NSMutableDictionary) {
        self.index = data["index"] as? Int
        self.dayOfWeeks = data["dayOfWeeks"] as? [kHwDayOfWeek]
        self.startTime = data["startTime"] as? String
        self.endTime = data["endTime"] as? String
        self.repeatMode = data["repeatMode"] as? HwRepeatMode
    }
}
