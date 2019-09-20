//
//  Installation+.swift
//  TimeSelfCareData
//
//  Created by Loka on 12/02/2019.
//  Copyright © 2019 Apptivity Lab. All rights reserved.
//

import Foundation
import ApptivityFramework

public extension Installation {
    static let kIsStagingMode: String = "Staging Mode"

    static var appVersion: String {
        return "v\(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0") #\(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "")"
    }

    static var isStagingMode: Bool {
        return UserDefaults.standard.bool(forKey: kIsStagingMode)
    }
}
