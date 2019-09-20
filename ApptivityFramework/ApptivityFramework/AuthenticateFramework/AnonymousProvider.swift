//
//  AnonymousProvider.swift
//  IdentityDemo
//
//  Created by Jason Khong on 12/13/16.
//  Copyright © 2016 Jason Khong. All rights reserved.
//

import Foundation

public protocol AnonymousProvider {
    var isAutomaticSessionEnabled: Bool { get }
    func createAnonymousUser(completion: @escaping (_ uuid: String?, _ error: AuthError?) -> Void)
}

open class LocalAnonymousProvider: AnonymousProvider {
    public init() {

    }
    
    public var isAutomaticSessionEnabled: Bool {
        return true
    }

    public func createAnonymousUser(completion: @escaping (_ uuid: String?, _ error: AuthError?) -> Void) {
        completion(UUID().uuidString, nil)
    }
}
