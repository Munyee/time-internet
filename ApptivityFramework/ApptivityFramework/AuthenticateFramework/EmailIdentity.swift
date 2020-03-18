//
//  EmailIdentity.swift
//  IdentityDemo
//
//  Created by Jason Khong on 12/13/16.
//  Copyright © 2016 Jason Khong. All rights reserved.
//

import Foundation

open class EmailIdentity: Identity {

    public private(set) var type: IdentityType = .email
    open var isVerified: Bool = false
    open var challenge: String {
        return self.confirmationCode ?? ""
    }
    public var identifier: String {
        return self.email
    }
    
    public var email: String
    public var confirmationCode: String?
    
    public init(email: String) {
        self.email = email
    }
}
