//
//  AuthUser.swift
//  IdentityDemo
//
//  Created by AppLab on 15/12/2016.
//  Copyright © 2016 Jason Khong. All rights reserved.
//

import Foundation

public protocol Person {

}

public protocol PersonDelegate {
    func profileForUser(_ user: AuthUser) -> Person?
    func user(_ user: AuthUser, didUpdateProfile: Person?)
}

public protocol AuthUserDelegate {
    func identityDelegate(for identityType: IdentityType) -> IdentityDelegate?
    func logoutUser(completion: @escaping () -> Void)
    func resetPassword(with identifier: String,completion: ((_ error: AuthError?) -> Void)?)
}

public extension NSNotification.Name {
    // Notification broadcasted when Person changes
    public static let PersonDidChange: NSNotification.Name = NSNotification.Name(rawValue: "ProfileDidChangeNotification")

    // Notification broadcasted when session token changes
    public static let SessionTokenDidChange: NSNotification.Name = NSNotification.Name("SessionTokenDidChangeNotification")
    // Notification broadcasted when session token is removed (changes from a previous (non-nil) to nil)
    public static let SessionTokenDidRemove: NSNotification.Name = NSNotification.Name("SessionTokenDidRemoveNotification")
}

public class AuthUser {

    public typealias CompletionBlock = (_ error: AuthError?) -> Void

    public static var current: AuthUser? = AuthUser()

    public static var authDelegate: AuthUserDelegate?
    public static var anonymousProvider: AnonymousProvider?

    private static var profileDelegate: PersonDelegate?

    public var uuid: String!
    public var sessionToken: String? {
        didSet {
            if oldValue != self.sessionToken {
                if self.sessionToken == nil {
                    NotificationCenter.default.post(name: NSNotification.Name.SessionTokenDidRemove, object: self)
                } else {
                    NotificationCenter.default.post(name: NSNotification.Name.SessionTokenDidChange, object: self)
                }
            }

            self.save()
        }
    }

    public static var isAnonymous: Bool {
        return AuthUser.current?.identities.isEmpty ?? true
    }

    public var identities: [Identity] = []

    public var person: Person? {
        didSet {
            if self.person != nil {
                NotificationCenter.default.post(name: NSNotification.Name.PersonDidChange, object: self)
            }
            AuthUser.profileDelegate?.user(self, didUpdateProfile: self.person)
        }
    }

    // MARK: - Anonymous User
    public class func enableAnonymousUser(with provider: AnonymousProvider?) {
        AuthUser.anonymousProvider = provider

        if (AuthUser.current?.uuid ?? nil) != nil && (AuthUser.current?.sessionToken ?? nil) != nil {
            // We already have an anonymous account
            return
        }

        if provider?.isAutomaticSessionEnabled == true {
            AuthUser.anonymousProvider?.createAnonymousUser(completion: { (uuid: String?, error: AuthError?) in
                AuthUser.current = AuthUser(uuid: uuid)
                AuthUser.current?.save()
            })
        } else {
            AuthUser.current = AuthUser(uuid: UUID().uuidString)
            AuthUser.current?.save()
        }
    }

    public class func enableProfiles(with delegate: PersonDelegate) {
        AuthUser.profileDelegate = delegate

        // Reload profile for current user
        if let currentUser = AuthUser.current {
            currentUser.person = delegate.profileForUser(currentUser)
        }
    }

    // Save and load user from Keychain service
    public func save() {
        try? self.uuid?.saveInKeychain(service: "AuthUser", withKey: "uuid")
        try? self.sessionToken?.saveInKeychain(service: "AuthUser", withKey: "sessionToken")

        for identity in self.identities {
            if identity is KeychainableIdentity {
                self.saveIdentityToKeychain(identity as! KeychainableIdentity)
            }
        }
    }

    // MARK: - Identities

    public func existingIdentity(of type: IdentityType) -> Identity? {
        var index: Int = -1
        for i in 0 ..< self.identities.count {
            let current: Identity = self.identities[i]
            if current.type == type {
                index = i
                break
            }
        }
        if index != -1 {
            return self.identities[index]
        }

        return nil
    }

    public func saveIdentityToKeychain(_ identity: KeychainableIdentity) {
        try? identity.keychainData().saveInKeychain(service: "AuthUser.identities", withKey: "\(identity.type.rawValue)::\(identity.identifier)")

        // Quick fix to add identity to self.identities if doesn't exist (to refactor)
        var index: Int = -1
        for i in 0 ..< self.identities.count {
            let current: Identity = self.identities[i]
            if current.type == identity.type && current.identifier == identity.identifier {
                index = i
                break
            }
        }
        if index == -1 {
            self.identities.append(identity)
        }
    }

    private func loadIdentitiesFromKeychain() {
        self.identities.removeAll()

        let keys: [String] = Keychain.allKeys(in: "AuthUser.identities")
        for key in keys {
            var typeString = key
            if key.contains("::") {
                typeString = String(key[..<key.range(of: "::")!.lowerBound])
            }

            if let type: IdentityType = IdentityType(rawValue: typeString)  {
                if let data: Data = Data.fromKeychain(service: "AuthUser.identities", withKey: key), let identity: Identity = AuthUser.authDelegate?.identityDelegate(for: type)?.savedIdentity(with: data, belongingToUser: self) {
                        self.identities.append(identity)
                }
            }
        }
    }

    public func validateInput(for identity: Identity) -> Bool {
        guard let identityDelegate: IdentityDelegate = AuthUser.authDelegate?.identityDelegate(for: identity.type) else {
            // No delegate to handle this identity type
            return false
        }
        return identityDelegate.validateInput(for: identity)
    }

    public func addIdentity(_ identity: Identity, completion: ((_ identity: Identity?, _ error: AuthError?) -> Void)?) {
        guard let identityDelegate: IdentityDelegate = AuthUser.authDelegate?.identityDelegate(for: identity.type) else {
            // No delegate to handle this identity type
            completion?(nil, AuthError.unsupportedIdentityType)
            return
        }

        identityDelegate.addIdentity(identity, for: self, completion: { (identity: Identity?, addError: AuthError?) -> Void in
            if addError == nil {
                if identity is KeychainableIdentity {
                    self.saveIdentityToKeychain(identity as! KeychainableIdentity)
                }
            }
            completion?(identity, addError)
        })
    }

    public func updateIdentity(_ identity: Identity, completion: ((_ error: AuthError?) -> Void)?) {
        guard let identityDelegate: IdentityDelegate = AuthUser.authDelegate?.identityDelegate(for: identity.type) else {
            // No delegate to handle this identity type
            completion?(AuthError.unsupportedIdentityType)
            return
        }

        identityDelegate.updateIdentity(identity, for: self) { (error: AuthError?) in
            if error == nil {
                if identity is KeychainableIdentity {
                    self.saveIdentityToKeychain(identity as! KeychainableIdentity)
                }
            }

            completion?(error)
        }
    }

    public func removeIdentity(_ identity: Identity, completion: CompletionBlock? = nil) {
        guard let identityDelegate: IdentityDelegate = AuthUser.authDelegate?.identityDelegate(for: identity.type) else {
            // No delegate to handle this identity type
            completion?(AuthError.unsupportedIdentityType)
            return
        }

        identityDelegate.removeIdentity(identity, for: self) { (error: AuthError?) in
            guard error == nil else {
                completion?(error)
                return
            }

            // Remove from instance variable
            var index: Int = -1
            for i in 0 ..< self.identities.count {
                let current: Identity = self.identities[i]
                if current.type == identity.type && current.identifier == identity.identifier {
                    index = i
                    break
                }
            }
            if index != -1 {
                self.identities.remove(at: index)
            }

            // Remove from keychain
            if identity is KeychainableIdentity {
                if !Keychain.delete(key: "\(identity.type.rawValue)::\(identity.identifier)", inService: "AuthUser.identities") {
                    debugPrint("Unable to remove identity from keychain")
                }
            }
            completion?(nil)
        }
    }

    public func activateIdentity(_ identity: Identity, withCode activationCode: String, completion: CompletionBlock? = nil) {
        guard let identityDelegate: IdentityDelegate = AuthUser.authDelegate?.identityDelegate(for: identity.type) else {
            // No delegate to handle this identity type
            completion?(AuthError.unsupportedIdentityType)
            return
        }

        identityDelegate.activateIdentity(identity, for: self, withCode: activationCode, completion: completion)
    }

    public func resendActivationCode(for identity: Identity, completion: CompletionBlock? = nil) {
        guard let identityDelegate: IdentityDelegate = AuthUser.authDelegate?.identityDelegate(for: identity.type) else {
            // No delegate to handle this identity type
            return
        }

        identityDelegate.resendActivationCode(for: identity, completion: completion)
    }

    // Send (or resend) challenge phrase externally to user
    public func resendChallenge(for identity: Identity, completion: CompletionBlock? = nil) {
        guard let identityDelegate: IdentityDelegate = AuthUser.authDelegate?.identityDelegate(for: identity.type) else {
            // No delegate to handle this identity type
            return
        }

        identityDelegate.resendChallenge(for: identity, completion: completion)
    }

    // Confirm identity by providing the challenge phrase (sent externally)
    public func verifyIdentity(_ identity: Identity, with challenge: String?, completion: CompletionBlock? = nil) {
        // Ask IdentityDelegate to confirm external verifcation
        guard let identityDelegate: IdentityDelegate = AuthUser.authDelegate?.identityDelegate(for: identity.type) else {
            // No delegate to handle this identity type
            return
        }

        identityDelegate.verifyIdentity(identity, with: challenge, for: self, completion: { (success: Bool, error: AuthError?) -> Void in
            if success {
                if identity is KeychainableIdentity {
                    self.saveIdentityToKeychain(identity as! KeychainableIdentity)
                }
            }

            completion?(error)
        })
    }

    // MARK: - Passwords
    public func changePassword(for identity: Identity, from challenge: String, to newChallenge: String, completion: ((_ error: AuthError?) -> Void)?) {
        guard identity.type == .userpass, let identityDelegate: IdentityDelegate = AuthUser.authDelegate?.identityDelegate(for: identity.type) else {
            completion?(AuthError.invalidIdentity)
            return
        }

        identityDelegate.changeChallenge(for: identity, from: challenge, to: newChallenge, completion: completion)
    }

    public static func resetPassword(with identifier: String, completion: ((_ error: AuthError?) -> Void)?) {
        AuthUser.authDelegate?.resetPassword(with: identifier, completion: completion)
    }

    // MARK: - Login
    public static func login(with identity: Identity, completion: @escaping (_ identity: Identity?, _ error: AuthError?) -> Void) {
        guard let identityDelegate: IdentityDelegate = AuthUser.authDelegate?.identityDelegate(for: identity.type) else {
            // No delegate to handle this identity type
            completion(nil, AuthError.unsupportedIdentityType)
            return
        }

        identityDelegate.authenticate(using: identity, completion: completion)
    }

    public static func becomeUser(with uuid: String, sessionToken: String) {
        AuthUser.current?.uuid = uuid
        AuthUser.current?.sessionToken = sessionToken
        AuthUser.current?.save()
    }

    // MARK: - Logout
    public func logout(completion: CompletionBlock? = nil) {
        InstallationController.shared()?.unlinkUserFromInstallation(Installation.current(), completion: nil)

        // Remove each identity
        self.identities.removeAll()
        if !Keychain.clear(service: "AuthUser.identities") {
            debugPrint("Failed to clear keychain of all saved identities")
        }

        // Inform server if needed
        if let authDelegate = AuthUser.authDelegate {
            authDelegate.logoutUser {
                AuthUser.current?.uuid = nil
                AuthUser.current?.sessionToken = nil
                if !Keychain.clear(service: "AuthUser") {
                    debugPrint("Failed to clear keychain of user uuid and sessionToken")
                }
                AuthUser.current?.person = nil

                AuthUser.enableAnonymousUser(with: AuthUser.anonymousProvider)
                completion?(nil)
            }
        } else {
            AuthUser.current?.uuid = nil
            AuthUser.current?.sessionToken = nil
            if !Keychain.clear(service: "AuthUser") {
                debugPrint("Failed to clear keychain of user uuid and sessionToken")
            }
            AuthUser.current?.person = nil

            AuthUser.enableAnonymousUser(with: AuthUser.anonymousProvider)
        }
    }

    // MARK: - Initializers
    private init?(uuid: String? = nil) {
        if let uuid: String = uuid {
            self.uuid = uuid
        } else {
            // Check if keychain has existing user
            if let uuid: String = String.fromKeychain(service: "AuthUser", withKey: "uuid") {
                self.uuid = uuid
                self.sessionToken = String.fromKeychain(service: "AuthUser", withKey: "sessionToken")
                self.person = AuthUser.profileDelegate?.profileForUser(self)
                self.loadIdentitiesFromKeychain()
            } else {
                return nil
            }
        }
    }
}
