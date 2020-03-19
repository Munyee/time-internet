//
//  Keychain.swift
//  ApptivityFramework
//
//  Created by Li Theen Kok on 02/11/2016.
//  Copyright © 2016 Apptivity Lab. All rights reserved.
//

import Foundation

public class Keychain {

    public static func delete(key: String, inService service: String) -> Bool {
        let query: [NSString : NSObject] = [
            kSecClass           : kSecClassGenericPassword,
            kSecAttrService     : service as NSObject,
            kSecAttrAccount     : key as NSObject
        ]

        let status: OSStatus = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess || status == errSecItemNotFound
    }

    public static func clear(service: String) -> Bool {
        let item: [NSString : NSObject] = [
            kSecAttrService : service as NSObject,
            kSecClass       : kSecClassGenericPassword
        ]
        let status: OSStatus = SecItemDelete(item as CFDictionary)
        return status == errSecSuccess || status == errSecItemNotFound
    }

    public static func allKeys(in service: String) -> [String] {
        var keys: [String] = []

        let query: [NSString : NSObject] = [
            kSecClass            : kSecClassGenericPassword,
            kSecAttrService      : service as NSObject,
            kSecMatchLimit       : kSecMatchLimitAll,
            kSecReturnAttributes : kCFBooleanTrue
        ]

        var result: AnyObject?
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &result)
        if status == errSecSuccess {
            if let attributesDicts = result as? [[String : Any]] {
                for attributes in attributesDicts {
                    if let key = attributes[kSecAttrAccount as String] {
                        keys.append(key as! String)
                    }
                }
            }
        }

        return keys
    }
}

public extension Data {

    public static func fromKeychain(service: String, withKey key: String) -> Data? {
        let queryDict: [NSString : NSObject] = [
            kSecClass           : kSecClassGenericPassword,
            kSecAttrService     : service as NSObject,
            kSecAttrAccount     : key as NSObject,
            kSecMatchLimit      : kSecMatchLimitOne,
            kSecReturnData      : kCFBooleanTrue
        ]

        var result: AnyObject?
        let status: OSStatus = SecItemCopyMatching(queryDict as CFDictionary, &result)

        guard status == errSecSuccess else {
            return nil
        }

        if let resultData: Data = result as? Data {
            return resultData
        }
        return nil
    }

    public func saveInKeychain(service: String, withKey key: String) throws {

        let queryDict: [NSString : NSObject] = [
            kSecClass           : kSecClassGenericPassword,
            kSecAttrService     : service as NSObject,
            kSecAttrAccount     : key as NSObject,
            kSecMatchLimit      : kSecMatchLimitOne,
            kSecReturnData      : kCFBooleanTrue
        ]

        var result: AnyObject?
        var status: OSStatus = SecItemCopyMatching(queryDict as CFDictionary, &result)

        if status == errSecItemNotFound {
            let addQuery: [NSString : NSObject] = [
                kSecClass       : kSecClassGenericPassword,
                kSecAttrService : service as NSObject,
                kSecAttrAccount : key as NSObject,
                kSecValueData   : self as NSObject
            ]
            status = SecItemAdd(addQuery as CFDictionary, &result)
        } else {
            let updateQuery: [NSString : NSObject] = [
                kSecClass       : kSecClassGenericPassword,
                kSecAttrService : service as NSObject,
                kSecAttrAccount : key as NSObject,
                ]
            let updateObject: [NSString : NSObject] = [
                kSecValueData   : self as NSObject
            ]
            status = SecItemUpdate(updateQuery as CFDictionary, updateObject as CFDictionary)
        }

        if status != errSecSuccess {
            let error: NSError = NSError(domain: "com.apptivitylab", code: Int(status), userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("Failed to securely save user data in keychain.", comment: "Failed to securely save user data in keychain.")])
            throw error
        }
    }
}

public extension String {

    public static func fromKeychain(service: String, withKey key: String) -> String? {
        if let data: Data = Data.fromKeychain(service: service, withKey: key) {
            return String(data: data, encoding: String.Encoding.utf8)
        }
        return nil
    }

    public func saveInKeychain(service: String, withKey key: String) throws {
        if let data: Data = self.data(using: String.Encoding.utf8) {
            try data.saveInKeychain(service: service, withKey: key)
        }
    }
}
