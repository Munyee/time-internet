//
//  Array+Apptivity.swift
//  ApptivityFramework
//
//  Created by Loka on 27/03/2018.
//  Copyright © 2018 Apptivity Lab. All rights reserved.
//

import Foundation

public extension Array {

    /**
     Returns an array of unique objects by comparing certain property.

     Example:
     let persons = [{"name": "Jason", "age": 18, "name": "Jazz", "age": 18, "name": "Jason", "age": 20}]
     let uniquePerson = persons.unique { $0.name } // [{"name": "Jason", "age": 18, "name": "Jazz", "age": 18}]

     - Returns: A new array of unique objects.
     */
    func unique<T: Hashable>(map: ((Element) -> T)) -> [Element] {
        var set = Set<T>()
        return self.filter { (element: Element) in
            let isUnique = !set.contains(map(element))
            set.insert(map(element))
            return isUnique
        }
    }
}

