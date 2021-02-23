//
//  PeriodModel.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 23/02/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import Foundation
import HwMobileSDK

public class PeriodModel: JsonRecord {
    public var type: kHwDayOfWeek?
    public var repeatMode: HwRepeatMode?

    public init() {
    }

    public required init?(with data: [String : Any]) {
        self.type = data["type"] as? kHwDayOfWeek
        self.repeatMode = data["repeatMode"] as? HwRepeatMode
    }
}
