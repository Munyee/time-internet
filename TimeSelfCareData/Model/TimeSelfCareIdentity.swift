//
//  TimeSelfCareIdentity.swift
//  TimeSelfCare
//
//  Created by AppLab on 05/06/2017.
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import UIKit
import ApptivityFramework

public class TimeSelfCareIdentity: KeychainableIdentity, JsonRecord {

    public let uuid: UUID
    public var userProfileUuid: UUID?

    public var type: IdentityType
    public var identifier: String
    public var challenge: String
    public var isVerified: Bool = false
    public var isActivated: Bool = false

    public init(uuid: UUID = UUID(), identifier: String, challenge: String) {
        self.uuid = uuid
        self.identifier = identifier
        self.challenge = challenge
        self.type = identifier.isEmail ? .userpass : .phone
        self.isVerified = false
        self.isActivated = false
    }

    public required init?(with json: [String : Any]) {
        guard let uuid = UUID(uuidString: json["uuid"] as? String ?? "") else {
            debugPrint("Failed to initialize Identity from JSON")
            return nil
        }

        self.uuid = uuid
        if let userProfileUuid: UUID = UUID(uuidString: json["user_profile_uuid"] as? String ?? "") {
            self.userProfileUuid = userProfileUuid
        }

        self.type = IdentityType(rawValue: json["type"] as? String ?? "") ?? IdentityType.userpass
        self.identifier = json["identifier"] as? String ?? ""
        self.isVerified = json["verified"] as? Bool ?? false
        self.challenge = ""
        self.isActivated = json["is_activated"] as? Bool ?? false
    }

    public required convenience init?(data: Data) {
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? [String : Any] {
                let identifier: String = json["identifier"] as? String ?? ""
                let challenge: String = json["challenge"] as? String ?? ""

                let uuid: UUID
                if let UUIDString = json["uuid"] as? String, let foundationUUID = NSUUID(uuidString: UUIDString) {
                    uuid = foundationUUID as UUID
                } else {
                    uuid = NSUUID() as UUID
                }
                self.init(uuid: uuid, identifier: identifier, challenge: challenge)

                self.type = IdentityType(rawValue: json["type"] as? String ?? "") ?? IdentityType.userpass
                self.isVerified = json["verified"] as? Bool ?? false
                self.isActivated = json["is_activated"] as? Bool ?? false
                return
            }
        } catch {
            debugPrint("Failed to initialize Identity from keychain data")
        }

        return nil
    }

    public func toJson() -> [String : Any] {
        var json: [String : Any] = [
            "uuid"          : self.uuid.uuidString.lowercased(),
            "type"          : self.type.rawValue,
            "identifier"    : self.identifier,
            "verified"      : self.isVerified,
            "challenge"     : self.challenge
        ]
        if let profileUuid = self.userProfileUuid {
            json["user_profile_uuid"] = profileUuid.uuidString.lowercased()
        }
        return json
    }

    public func keychainData() -> Data {
        var json: [String : Any] = [
            "uuid"          : self.uuid.uuidString.lowercased(),
            "type"          : self.type.rawValue,
            "identifier"    : self.identifier,
            "verified"      : self.isVerified,
            "challenge"     : self.challenge,
            "is_activated"  : self.isActivated
        ]
        if let profileUUID = self.userProfileUuid {
            json["user_profile_uuid"] = profileUUID.uuidString.lowercased()
        }
        // swiftlint:disable force_try
        return try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions(rawValue: 0))
    }
}
