//
//  VersionDataController.swift
//  TimeSelfCareData
//
//  Created by Loka on 30/09/2019.
//  Copyright © 2019 Apptivity Lab. All rights reserved.
//

import Foundation

public class VersionDataController {
    private static let _sharedInstance: VersionDataController = VersionDataController()
    public static var shared: VersionDataController {
        return _sharedInstance
    }

    var version: Int?
    var installUrl: String?

    func loadVersionData(
        path: String,
        body: [String: Any],
        completion: @escaping ElementListener<Int>
        ) {
        APIClient.shared
            .postRequest(path: path, body: body) { (json: [String: Any], error: Error?) in
                if let version = json["build"] as? String {
                    self.version = Int(version)
                } else {
                    self.version = json["build"] as? Int
                }

                completion(self.version, error)
            }
        }
}

public extension VersionDataController {
    func getVersion() -> Int? {
        return self.version
    }
    
    func setInstallUrl(url: String) {
        installUrl = url
    }
    
    func getInstallUrl() -> String? {
        return self.installUrl
    }

    func loadVersion(
        completion: @escaping ElementListener<Int>
        ) {
        let path = "get_timeapp_info"
        var body: [String: Any] = [:]
        body["device_type"] = "ios"

        self.loadVersionData(path: path, body: body, completion: completion)
    }
}
