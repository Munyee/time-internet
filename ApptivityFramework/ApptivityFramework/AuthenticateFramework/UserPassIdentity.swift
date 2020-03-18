//
//  UserPassIdentity.swift
//  IdentityDemo
//
//  Created by AppLab on 16/12/2016.
//  Copyright © 2016 Jason Khong. All rights reserved.
//

import Foundation

open class UserPassIdentity: Identity {
    public private(set) var type: IdentityType = .userpass
    open var isVerified: Bool = false
    open var challenge: String {
        return self.password
    }

    public var identifier: String {
        get { return self.username }
    }

    public var username: String
    public var password: String

    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}
