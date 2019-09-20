//
//  Sequence+Apptivity.swift
//  ApptivityFramework
//
//  Created by Loka on 03/11/2017.
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import Foundation

public extension Sequence {
    // Generic group method. Work with class, struct and tuple.
    func group<GroupKey: Hashable>(by key: (Iterator.Element) -> GroupKey) -> [GroupKey: [Iterator.Element]] {
        var groups: [GroupKey: [Iterator.Element]] = [:]
        self.forEach { element in
            let key = key(element)
            if case nil = groups[key]?.append(element) {
                groups[key] = [element]
            }
        }
        return groups
    }
}
