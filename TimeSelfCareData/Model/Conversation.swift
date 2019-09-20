//  Conversation.swift
//  TimeSelfCareData/Model
//
//  Opera House | Data - Model Class
//  Updated 2018-03-05
//  Copyright © 2018 Apptivity Lab. All rights reserved.
//

import Foundation

public class Conversation: JsonRecord {
    public enum Status {
        case sending, success, failed, undefined
    }

    public var timestamp: Int?
    public var datetime: String?
    public var userId: String?
    public var fullname: String?
    public var body: String?
    public let id: String
    public var status: Status = .undefined
    public var images: [UIImage] = []

    // Relationships
    public var attachmentsName: [String] = []
    public var ticketId: String

    public init(
        ticket: Ticket
        ) {
        self.id = UUID().uuidString
        self.ticketId = ticket.id
    }

    public required init?(with json: [String: Any]) {
        guard
            let id: String = json["id"] as? String,
            let ticketId = json["ticket_id"] as? String
        else {
                debugPrint("ERROR: Failed to construct Conversation from JSON\n\(json)")
                return nil
        }

        self.timestamp = json["timestamp"] as? Int
        self.datetime = json["datetime"] as? String
        self.userId = json["user_id"] as? String
        self.fullname = json["fullname"] as? String
        self.body = json["body"] as? String
        self.id = id
        self.attachmentsName = (json["attachments_uuid"] as? String ?? String()).components(separatedBy: ",")
        self.ticketId = ticketId
    }

    public func toJson() -> [String : Any] {
        var json: [String: Any] = [:]

        // Attributes
        json["account_no"] = self.ticket?.accountNo
        json["ticket_id"] = self.ticketId
        json["body"] = self.body
        return json
    }
}

public extension Conversation {
    // attachment: Conversation has-many Attachment
    var attachment: [Attachment] {
        return AttachmentDataController.shared.getAttachments(conversation: self)
    }

    // ticket: Conversation belongs-to Ticket
    var ticket: Ticket? {
        return TicketDataController.shared.getTicket(by: self.ticketId)
    }

}
