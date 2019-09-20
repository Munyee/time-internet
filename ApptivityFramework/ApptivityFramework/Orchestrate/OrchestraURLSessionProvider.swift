//
//  OrchestraURLSessionProvider.swift
//  ApptivityFramework
//
//  Created by AppLab on 07/08/2017.
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import UIKit

class OrchestraURLSessionProvider {

    fileprivate static let _shared: OrchestraURLSessionProvider = OrchestraURLSessionProvider()

    let session: URLSession

    var applicationKey: String = ""
    var baseURL: URL!

    static func shared() -> OrchestraURLSessionProvider? {
        guard !OrchestraURLSessionProvider._shared.applicationKey.isEmpty,
            OrchestraURLSessionProvider._shared.baseURL != nil else {
                return nil
        }
        return OrchestraURLSessionProvider._shared
    }

    fileprivate init() {
        self.session = URLSession(configuration: URLSessionConfiguration.default)
    }

    static func setup(with applicationKey: String, baseURL: URL) {
        OrchestraURLSessionProvider._shared.applicationKey = applicationKey
        OrchestraURLSessionProvider._shared.baseURL = baseURL
    }

    func orchestraURLRequest(with method: String, path: String, query: [String : String]? = nil, body: [String : Any]? = nil) -> URLRequest? {
        var queryComponents: [String] = []
        for (key, value) in query ?? [:] {
            if let escapedValue: String = value.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
                queryComponents.append("\(key)=\(escapedValue.replacingOccurrences(of: "=", with: "%3D"))")
            }
        }

        let pathWithQuery: String = "/\(path)?\(queryComponents.joined(separator: "&"))"
        guard let baseURL: URL = OrchestraURLSessionProvider.shared()?.baseURL,
            let url: URL = URL(string: "\(baseURL.absoluteString)\(pathWithQuery)") else {
                return nil
        }

        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = method

        do {
            if let body = body {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions(rawValue: 0))
            }
        } catch {
            debugPrint("HTTP request body is not set: \(error)")
        }

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        request.addValue(self.applicationKey, forHTTPHeaderField: "X-Application-Key")
        request.addValue(self.applicationKey, forHTTPHeaderField: "X-Harbour-Application-Key")

        if let sessionToken: String = AuthUser.current?.sessionToken {
            request.addValue("Bearer \(sessionToken)", forHTTPHeaderField: "Authorization")
        }
        
        return request
    }
}
