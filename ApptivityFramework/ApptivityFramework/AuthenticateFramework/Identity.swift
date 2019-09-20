//
//  Identity.swift
//  IdentityDemo
//
//  Created by Jason Khong on 12/2/16.
//  Copyright © 2016 Jason Khong. All rights reserved.
//

import Foundation

public protocol Identity {
    var type: IdentityType { get }
    var identifier: String { get }
    var isVerified: Bool { get }
    var challenge: String { get }
}

public enum IdentityType: String {
    case email, userpass, phone, social

    var requiresExternalChallenge: Bool {
        switch self {
        case .email, .phone:
            return true
        default:
            return false
        }
    }
}

public protocol KeychainableIdentity: Identity {
    init?(data: Data)
    func keychainData() -> Data
}

public protocol IdentityDelegate {
    
    func savedIdentity(with data: Data, belongingToUser user: AuthUser) -> Identity?

    func validateInput(for identity: Identity) -> Bool
    
    func addIdentity(_ identity: Identity, for user: AuthUser, completion: ((_ identity: Identity?, _ error: AuthError?) -> Void)?)

    func removeIdentity(_ identity: Identity, for user: AuthUser, completion: ((_ error: AuthError?) -> Void)?)

    func updateIdentity(_ identity: Identity, for user: AuthUser, completion: ((_ error: AuthError?) -> Void)?)

    func activateIdentity(_ identity: Identity, for user: AuthUser, withCode: String, completion: AuthUser.CompletionBlock?)

    func resendActivationCode(for identity: Identity, completion: AuthUser.CompletionBlock?)

    func resendChallenge(for identity: Identity, completion: AuthUser.CompletionBlock?)

    // Check with external server to see if challenge phrase matches identity
    func verifyIdentity(_ identity: Identity, with challenge: String?, for user: AuthUser, completion: ((_ success: Bool, _ error: AuthError?) -> Void)?)

    func authenticate(using identity: Identity, completion: ((_ identity: Identity?, _ error: AuthError?) -> Void)?)

    func changeChallenge(for identity: Identity, from challenge: String, to newChallenge: String, completion: ((_ error: AuthError?) -> Void)?)
}

public enum AuthError: Error {
    case unsupportedIdentityType
    case identityNotFound
    case invalidIdentity
    case identityTaken
    case identityNotActivated
    case invalidCredentials
    case invalidActivationCode
    case unknown(message: String?)
}

extension AuthError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unknown(let message):
            return message
        default:
            return nil
        }
    }
}
