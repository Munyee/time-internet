//
//  Extensions.swift
//  TimeSelfCareData
//
//  Created by Aarief on 01/11/2017.
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import Foundation
import ApptivityFramework
import CommonCrypto

extension Profile: Person { }
public extension Profile {
    var shouldChangeEmail: Bool {
        return self.todo == "update_email_address"
    }

    var shouldChangePassword: Bool {
        return (self.todo ?? "").contains("update_password")
    }

    var passwordHasExpired: Bool {
        return self.todo == "password_expired"
    }
}

extension AccountController {
    var API: APIClient {
        return APIClient.shared
    }
}

public extension Account {
    var isThf: Bool {
       return AccountController.shared.selectedAccount?.services.filter { $0.isThf ?? false }.count ?? 0 > 0
    }

    var freeMinutesService: Service? {
        return AccountController.shared.selectedAccount?.services.first { $0.haveFreeminutes ?? false }
    }

    var hasFreeMinutes: Bool {
        return self.freeMinutesService != nil
    }

    var shouldShowPerformance: Bool {
        return self.custSegment == .residential || self.custSegment == .astro
    }
}

 public extension BillingInfo {
    static var states: [String] {
        return [
            "JOHOR",
            "KEDAH",
            "KELANTAN",
            "MELAKA",
            "NEGERI SEMBILAN",
            "PAHANG",
            "PULAU PINANG",
            "PERAK",
            "PERLIS",
            "SABAH",
            "SARAWAK",
            "SELANGOR",
            "TERENGGANU",
            "WILAYAH PERSEKUTUAN"
        ]
    }
 }

public extension String {
    func toMD5Hex() -> String {
        let messageData = self.data(using:.utf8)! // swiftlint:disable:this force_unwrapping
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))

        _ = digestData.withUnsafeMutableBytes {digestBytes in
            messageData.withUnsafeBytes {messageBytes in
                CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }

        return digestData.map { String(format: "%02hhx", $0) }.joined()
    }

    var htmlAttributedString: NSAttributedString? {
        return try? NSAttributedString(data: Data(utf8), options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
    }

    func snakecased() -> String {
        return self.lowercased().replacingOccurrences(of: " ", with: "_")
    }
}

public extension Ticket {
    var detail: String {
        return "#\(self.id) \(self.displayCategory ?? "")"
    }

    var displayDateTime: String? {
        guard
            let timestamp = self.timestamp
            else {
                return self.datetime
        }
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        return date.string(usingFormat: "hh:mmaa, d MMMM YYYY")
    }
}
