//  Ticket.swift
//  TimeSelfCareData/Model
//
//  Opera House | Data - Model Class
//  Updated 2018-03-05
//  Copyright © 2018 Apptivity Lab. All rights reserved.
//

import Foundation

public class Ticket: JsonRecord {
    public let id: String
    public var subject: String?
    public var description: String?
    public var timestamp: Int?
    public var datetime: String?
    public var status: Int?
    public var category: String?

    public var statusOptions: [Int: String] = [:]
    public var statusString: String? {
        get {
            return ((self.statusOptions.first { $0.key == status })?.value)?.localizedUppercase
        }
        set {
            self.status = (self.statusOptions.first { $0.value == newValue })?.key
        }
    }

    public var categoryOptions: [String: String] = [:]
    public var displayCategory: String? {
        get {
            return self.categoryOptions.first { $0.key == self.category }?.value
        }
        set {
            self.category = self.categoryOptions.first { $0.value == newValue }?.key
        }
    }

    // Relationships
    public var accountNo: String?

    public init(id: String) {
        self.id = id
    }

    public required init?(with json: [String: Any]) {
        guard
            let id: String = json["ticket_id"] as? String
        else {
            debugPrint("ERROR: Failed to construct Ticket from JSON\n\(json)")
            return nil
        }

        self.id = id
        (json["list_status"] as? [String: String] ?? [:]).forEach {
            if let key = Int($0.key) {
                self.statusOptions[key] = $0.value
            }
        }

        self.categoryOptions = json["list_category"] as? [String: String] ?? [:]

        self.subject = json["subject"] as? String
        self.description = json["description"] as? String
        self.timestamp = json["timestamp"] as? Int
        self.datetime = json["datetime"] as? String
        self.status = Int(json["status"] as? String ?? "")
        self.category = json["category"] as? String
        self.accountNo = json["account_no"] as? String
    }

    public func toJson() -> [String: Any] {
        var json: [String: Any] = [:]

        // Attributes
        json["subject"] = self.subject
        json["description"] = self.description
        json["category"] = self.category
        json["account_no"] = self.accountNo
        return json
    }
}

public extension Ticket {
    // account: Ticket belongs-to Account
    var account: Account? {
        if let accountNo = self.accountNo {
            return AccountDataController.shared.getAccount(by: accountNo)
        }
        return nil
    }

    // attachments: Ticket has-many Attachment
    var attachments: [Attachment] {
        return AttachmentDataController.shared.getAttachments(ticket: self)
    }

    // conversations: Ticket has-many Conversation
    var conversations: [Conversation] {
        return ConversationDataController.shared.getConversations(ticket: self)
    }

}
