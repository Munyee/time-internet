//
//  Units.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 19/02/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import Foundation

public struct Units {
    
    public let kilobytes: Int64
    
    public var megabytes: Double {
        Double(kilobytes / 1_024)
    }
    
    public var gigabytes: Double {
        megabytes / 1_024
    }
    
    public init(kBytes: Int64) {
        self.kilobytes = kBytes
    }
    
    public func getReadableUnit() -> (String, String) {
        
        switch kilobytes {
        case 0..<1_024:
            return ("\(kilobytes)", "Kbit/s")
        case 1_024..<(1_024 * 1_024):
            return ("\(String(format: "%.0f", megabytes))", "Mbit/s")
        case (1_024 * 1_024 * 1_024)...Int64.max:
            return ("\(String(format: "%.0f", gigabytes))", "Gbit/s")
        default:
            return ("\(kilobytes)", "Kbit/s")
        }
    }
    
    public func getRateInMbps() -> Double {
        return megabytes
    }
}
