//
//  Reward.swift
//  TimeSelfCareData
//
//  Created by Loka on 03/07/2019.
//  Copyright © 2019 Apptivity Lab. All rights reserved.
//

import Foundation

public class Reward: Codable {
    public enum Status: String, Codable {
        case available, grabbed, redeemed
        case fullyGrabbed = "fully_grabbed"
    }

    public enum OutletGroup: String {
        case isGroup = "is_group"
        case ungrouped = "ungrouped"
    }

    public var year: Int?
    public var provider: String?
    public var name: String?
    public var image: String?
    public var howToRedeem: [String]?
    public var outlets: [String: [String]]?
    public var termsAndConditions: [String]?
    public var status: Reward.Status?
    public var canRedeem: Bool?
    public var code: [String]?
    public var codeIsImage: Bool?
    public var totalCode: Int?
    public var validityPeriod: String?

    // Relationships
    public var accountNo: String

    enum CodingKeys: String, CodingKey {
        case year, provider, name
        case image = "img"
        case howToRedeem = "how_to_redeem"
        case outlets
        case termAndCondition = "tnc"
        case status
        case canRedeem = "can_redeem"
        case code
        case codeIsImage = "code_is_img"
        case totalCode = "total_code"
        case accountNo = "account_no"
        case serviceId = "service_id"
        case validityPeriod = "validity_period"
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let yearOptional = try? container.decodeIfPresent(String.self, forKey: .year),
            let year = yearOptional {
            self.year = Int(year)
        } else {
            self.year = try container.decodeIfPresent(Int.self, forKey: .year)
        }
        self.image = try container.decodeIfPresent(String.self, forKey: .image)
        self.provider = try container.decodeIfPresent(String.self, forKey: .provider)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.howToRedeem = try container.decodeIfPresent([String].self, forKey: .howToRedeem)
        self.outlets = try container.decodeIfPresent([String: [String]].self, forKey: .outlets)
        self.termsAndConditions = try container.decodeIfPresent([String].self, forKey: .termAndCondition)
        self.status = try container.decodeIfPresent(Reward.Status.self, forKey: .status)
        self.canRedeem = try container.decodeIfPresent(Bool.self, forKey: .canRedeem)
        self.code = try container.decodeIfPresent([String].self, forKey: .code)
        self.codeIsImage = try container.decodeIfPresent(Bool.self, forKey: .codeIsImage)
        self.totalCode = try container.decodeIfPresent(Int.self, forKey: .totalCode)
        self.accountNo = try container.decode(String.self, forKey: .accountNo)
        self.validityPeriod = try container.decodeIfPresent(String.self, forKey: .validityPeriod)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(self.year, forKey: .year)
        try container.encodeIfPresent(self.image, forKey: .image)
        try container.encodeIfPresent(self.provider, forKey: .provider)
        try container.encodeIfPresent(self.name, forKey: .name)
        try container.encodeIfPresent(self.howToRedeem, forKey: .howToRedeem)
        try container.encodeIfPresent(self.outlets, forKey: .outlets)
        try container.encodeIfPresent(self.termsAndConditions, forKey: .termAndCondition)
        try container.encodeIfPresent(self.status, forKey: .status)
        try container.encodeIfPresent(self.canRedeem, forKey: .canRedeem)
        try container.encodeIfPresent(self.code, forKey: .code)
        try container.encodeIfPresent(self.codeIsImage, forKey: .codeIsImage)
        try container.encodeIfPresent(self.totalCode, forKey: .totalCode)
        try container.encode(self.accountNo, forKey: .accountNo)
        try container.encodeIfPresent(self.validityPeriod, forKey: .validityPeriod)
    }
}
