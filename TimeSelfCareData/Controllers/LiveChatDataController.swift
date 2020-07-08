//
//  LiveChatDataController.swift
//  TimeSelfCareData
//
//  Created by Chan Mun Yee on 19/06/2020.
//  Copyright © 2020 Apptivity Lab. All rights reserved.
//

import Foundation
import Alamofire

public class LiveChatDataController {
    private static let _sharedInstance: LiveChatDataController = LiveChatDataController()
    public static var shared: LiveChatDataController {
        return _sharedInstance
    }

    var status: String?
    var manager: Alamofire.SessionManager!

    private init() {
        let config = URLSessionConfiguration.default
        let serverTrust: [String: ServerTrustPolicy] = [
            "211.24.220.161": .disableEvaluation
        ]

        self.manager = Alamofire.SessionManager(configuration: config, delegate: SessionDelegate(), serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrust))
    }

    func loadStatusData(
        path: String,
        body: [String: Any],
        completion: @escaping ((_ status: String?) -> Void)
    ) {
        self.request(method: .get).responseJSON { (response: DataResponse<Any>) in
           if let json = response.result.value as? [String: Any],
               let status = json["live_chat_status"] as? String {
               completion(status)
           } else {
               completion(nil)
           }
        }
    }

    func request(
        method: HTTPMethod,
        parameters: [String: Any]? = nil,
        additionalHeaders: [String: String]? = nil,
        encoding: ParameterEncoding = JSONEncoding.default) -> DataRequest {
        var headers: [String: String] = [:]
        if let additionalHeaders: [String: String] = additionalHeaders {
            for (key, value) in additionalHeaders {
                headers[key] = value
            }
        }

        let requestURL: String = "https://www.time.com.my/api/getLiveChatStatus.php"

        return self.manager.request(
            requestURL,
            method: method,
            parameters: parameters,
            encoding: encoding,
            headers: headers)
    }
}

public extension LiveChatDataController {

    func getStatus() -> String? {
        return self.status
    }

    func loadStatus(
        completion: @escaping ((_ status: String?) -> Void)
        ) {
        let path = "getLiveChatStatus"
        var body: [String: Any] = [:]
        body["device_type"] = "ios"

        self.loadStatusData(path: path, body: body, completion: completion)
    }
}
