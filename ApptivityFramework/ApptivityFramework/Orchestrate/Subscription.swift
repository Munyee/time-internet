//
//  InstallationSubscription.swift
//  ApptivityFramework
//
//  Created by AppLab on 26/06/2017.
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import UIKit

public extension Installation {

    public struct Interest {
        public let subjectUuid: UUID
        public let subjectType: String
        public var related: String?

        public init(subjectUuid: UUID, subjectType: String, related: String? = nil) {
            self.subjectUuid = subjectUuid
            self.subjectType = subjectType
            self.related = related
        }
    }

    public struct Subscription: Equatable {
        public let interest: Interest

        public init(forInterest interest: Interest) {
            self.interest = interest
        }

        public init?(with json: [String : Any]) {
            guard let interestSubjectType: String = json["subject_type"] as? String,
                let interestSubjectUuid: UUID = UUID(uuidString: json["subject_uuid"] as? String ?? "")
            else {
                return nil
            }

            self.interest = Interest(subjectUuid: interestSubjectUuid, subjectType: interestSubjectType, related: json["related"] as? String)
        }

        func toJson() -> [String : Any] {
            return [
                "interest_type": self.interest.subjectType,
                "interest_uuid": self.interest.subjectUuid.uuidString.lowercased(),
                "related": self.interest.related ?? NSNull()
            ]
        }

        public static func ==(lhs: Subscription, rhs: Subscription) -> Bool {
            return lhs.interest.subjectUuid == rhs.interest.subjectUuid &&
                lhs.interest.subjectType == rhs.interest.subjectType &&
                lhs.interest.related == rhs.interest.related
        }
    }
}
