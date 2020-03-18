//
//  MockData.swift
//  ApptivityFramework
//
//  Created by Jason Low on 24/05/2017.
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import Foundation

public class MockData {
    enum MockDataError: Error {
        case fileNotFound
    }

    public static func load(for modelClass: AnyClass, with resource: String, completion: (([[String: Any]], _ error: Error?) -> Void)?) {
        DispatchQueue.main.async {
            guard let jsonURL: URL = Bundle(for: modelClass).url(forResource: resource, withExtension: "json") else {
                do {
                    throw MockDataError.fileNotFound
                } catch {
                    completion?([], error)
                }
                return
            }

            var dataJsons: [[String : Any]] = []
            var responseError: Error?

            do {
                let testDataContent: Data = try Data(contentsOf: jsonURL)
                if let jsonDict: NSDictionary = try JSONSerialization.jsonObject(with: testDataContent, options: .mutableContainers) as? NSDictionary {
                    if let testData: NSArray = jsonDict["resource"] as? NSArray {
                        for data in testData {
                            if let jsonData = data as? [String: Any] {
                                dataJsons.append(jsonData)
                            }
                        }
                    } else if let json: [String: Any] = jsonDict as? [String : Any] {
                        dataJsons.append(json)
                    }
                }
            } catch {
                debugPrint(error)
                responseError = error
            }
            
            completion?(dataJsons, responseError)
        }
    }
}
