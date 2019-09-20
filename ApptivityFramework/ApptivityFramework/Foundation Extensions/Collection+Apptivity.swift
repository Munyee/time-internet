//
//  Collection+Apptivity.swift
//  ApptivityFramework
//
//  Created by Jon Cheng on 07/08/2018.
//  Copyright © 2018 Apptivity Lab. All rights reserved.
//

import Foundation

public extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
