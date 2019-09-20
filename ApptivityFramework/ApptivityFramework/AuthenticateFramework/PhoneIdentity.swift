//
//  PhoneIdentity.swift
//  IdentityDemo
//
//  Created by Jason Khong on 12/13/16.
//  Copyright © 2016 Jason Khong. All rights reserved.
//

import Foundation
import CoreTelephony

public class PhoneCountry {

    public static func phoneCode(for isoCountryCode: String) -> String? {
        if let countryCode: String = NSDictionary(contentsOf: Bundle(for: PhoneCountry.self).url(forResource: "PhoneCountryCodes", withExtension: "plist")!)?[isoCountryCode] as? String {
            return countryCode
        }
        return nil
    }

    public static func possiblePhoneCode(fromPhoneNumber phoneNumber: String) -> String? {
        guard let dataSourceURL: URL = Bundle(for: PhoneCountry.self).url(forResource: "PhoneCountryCodes", withExtension: "plist"),
            let countryCodesDict: [String : String] = NSDictionary(contentsOf: dataSourceURL) as? [String : String] else {
                return nil
        }

        let cleanPhoneNumber: String = try! NSRegularExpression(pattern: "\\D", options: NSRegularExpression.Options.caseInsensitive).stringByReplacingMatches(in: phoneNumber, options: [], range: NSMakeRange(0, phoneNumber.lengthOfBytes(using: String.Encoding.utf8)), withTemplate: "")

        for countryIsoCode in countryCodesDict.keys {
            if let countryPhoneCode: String = countryCodesDict[countryIsoCode], let rangeInPhoneNumber = cleanPhoneNumber.range(of: countryPhoneCode) {
                if rangeInPhoneNumber.lowerBound == phoneNumber.startIndex {
                    return PhoneCountry.phoneCode(for: countryIsoCode)
                }
            }
        }
        return nil
    }
}

open class PhoneIdentity: Identity {
    open private(set) var type: IdentityType = .phone
    open var isVerified: Bool = false
    open var identifier: String {
        return "\(countryCode)\(phoneNumber)"
    }
    open var challenge: String {
        return self.pin ?? ""
    }
    
    open var countryCode: String
    open var phoneNumber: String
    open var pin: String?
    
    public init(countryCode: String, phoneNumber: String) {
        self.countryCode = countryCode
        self.phoneNumber = phoneNumber
    }
    
    public class func determineCountryCode() -> String? {
        let cellNetworkInfo: CTTelephonyNetworkInfo = CTTelephonyNetworkInfo()
        if let carrier: CTCarrier = cellNetworkInfo.subscriberCellularProvider {
            if !((carrier.mobileNetworkCode ?? "").isEmpty || (carrier.mobileNetworkCode ?? "") == "65535") {
                return PhoneCountry.phoneCode(for: carrier.isoCountryCode ?? "")
            }

        }

        let countryCode = (NSLocale.current as NSLocale).object(forKey: NSLocale.Key.countryCode) as? String
        return PhoneCountry.phoneCode(for: countryCode?.lowercased() ?? "")
    }
}
