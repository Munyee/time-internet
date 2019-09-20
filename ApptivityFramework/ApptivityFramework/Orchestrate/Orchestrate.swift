//
//  Orchestrate.swift
//  ApptivityFramework
//
//  Created by AppLab on 27/06/2017.
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import UIKit

public class Orchestrate {

    static var applicationKey: String = ""
    static var baseURL: URL! = URL(string: "")

    public static func with(applicationKey: String, baseURL: String) {
        if !Installation.hasExistingInstallation() {
            let _ = Keychain.clear(service: "AuthUser")
            let _ = Keychain.clear(service: "AuthUser.identities")

            if let bundleIdentifier = Bundle.main.bundleIdentifier {
                let _ = Keychain.clear(service: bundleIdentifier)
            }
        }

        self.applicationKey = applicationKey
        self.baseURL = URL(string: baseURL)

        OrchestraURLSessionProvider.setup(with: self.applicationKey, baseURL: self.baseURL)
    }
}
