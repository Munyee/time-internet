//
//  HUAE.swift
//  TimeSelfCareData
//
//  Created by Chan Mun Yee on 19/05/2020.
//  Copyright © 2020 Apptivity Lab. All rights reserved.
//

import Foundation

public class HUAE: JsonRecord {
    public let link: String?
    public var title: String?
    public var description: String?
    public var subject: String?
    public var text: String?
    public var fb_id: String?
    public var fb_text: String?
    public var twitter_text: String?
    public var whatsapp_text: String?
    public var email_subject: String?
    public var email_text: String?
    public var link_twitter: String?
    public var huae_consent: String?
    
    public var referral_status_list: [String : Any]?
    public var discount_balance: String?
    public var discount_bill_date: String?
    public var discount_status_list: [String : Any]?

    public init() {
        self.link = String()
        self.title = String()
        self.description = String()
        self.subject = String()
        self.text = String()
        self.fb_id = String()
        self.fb_text = String()
        self.twitter_text = String()
        self.whatsapp_text = String()
        self.email_subject = String()
        self.email_text = String()
        self.link_twitter = String()
        self.huae_consent = String()
        self.referral_status_list = [String : Any]()
        self.discount_balance = String()
        self.discount_bill_date = String()
        self.discount_status_list = [String : Any]()
    }

    public required init?(with json: [String : Any]) {
        guard
            let data = json["data"] as? [String:Any]
            else {
                debugPrint("ERROR: Failed to construct HUAE from JSON\n\(json)")
                return nil
        }
        
        self.link = data["link"] as? String
        self.title = data["title"] as? String
        self.description = data["description"] as? String
        self.subject = data["subject"] as? String
        self.text = data["text"] as? String
        self.fb_id = data["fb_id"] as? String
        self.fb_text = data["fb_text"] as? String
        self.twitter_text = data["twitter_text"] as? String
        self.whatsapp_text = data["whatsapp_text"] as? String
        self.email_subject = data["email_subject"] as? String
        self.email_text = data["email_text"] as? String
        self.link_twitter = data["link_twitter"] as? String
        self.huae_consent = data["huae_consent"] as? String
        
        self.referral_status_list = data["referral_status_list"] as? [String : Any]
        self.discount_balance = data["discount_balance"] as? String
        self.discount_bill_date = data["discount_bill_date"] as? String
        self.discount_status_list = data["discount_status_list"] as? [String : Any]
    }
}

public class ReferralStatus: JsonRecord {
    public let status: String?
    public var signup_date: String?
    public var activation_date: String?
    public var name: String?

    public init() {
        self.status = String()
        self.signup_date = String()
        self.activation_date = String()
        self.name = String()
    }

    public required init?(with json: [String : Any]) {
        self.status = json["status"] as? String
        self.signup_date = json["signup_date"] as? String
        self.activation_date = json["activation_date"] as? String
        self.name = json["name"] as? String
    }
}

public class DiscountStatus: JsonRecord {
    public let bill_date: String?
    public var bill_no: String?
    public var amount: String?

    public init() {
        self.bill_date = String()
        self.bill_no = String()
        self.amount = String()
    }

    public required init?(with json: [String : Any]) {
        self.bill_date = json["bill_date"] as? String
        self.bill_no = json["bill_no"] as? String
        self.amount = json["amount"] as? String
    }
}
