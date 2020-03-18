//
//  TestAppDelegate.swift
//  TimeSelfCare
//
//  Created by Loka on 24/10/2019.
//  Copyright © 2019 Apptivity Lab. All rights reserved.
//

import UIKit
import ApptivityFramework


/// The TestsAppDelegate used when the app is run in the test environment
/// This AppDelegate usage is determined in the main.swift file in the main app target
class TestsAppDelegate: NSObject {

    /// This constructor is called at the start of the tests and is a good point for test wide customization
    override init() {
        super.init()
        // Customize any TestsAppDelegate logic here
        AuthUser.authDelegate = AccountController.shared
        AuthUser.enableAnonymousUser(with: LocalAnonymousProvider())
        AuthUser.enableProfiles(with: AccountController.shared)
    }
}

