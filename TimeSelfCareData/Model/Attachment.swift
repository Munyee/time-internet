//  Attachment.swift
//  TimeSelfCareData/Model
//
//  Opera House | Data - Model Class
//  Updated 2018-03-05
//  Copyright © 2018 Apptivity Lab. All rights reserved.
//

import Foundation

public class Attachment: JsonRecord {
    public let name: String
    public var urlString: String
    public var url: URL? {
        return URL(string: urlString)
    }

    // Relationships
    public var ticketId: String?
    public var conversationId: String?

    public init(
        ticket: Ticket,
        url: String
        ) {
        self.name = String()
        self.ticketId = ticket.id
        self.urlString = url
    }

    public required init?(with json: [String: Any]) {
        guard
            let name: String = json["name"] as? String,
            let url: String = json["attachment_url"] as? String
        else {
                debugPrint("ERROR: Failed to construct Attachment from JSON\n\(json)")
                return nil
        }

        self.name = name
        self.urlString = url
        self.ticketId = json["ticket_id"] as? String
        self.conversationId = json["conversation_id"] as? String
    }

}

public extension Attachment {
    // ticket: Attachment belongs-to Ticket
    var ticket: Ticket? {
        if let ticketId = self.ticketId {
            return TicketDataController.shared.getTicket(by: ticketId)
        }
        return nil
    }

    // conversation: Attachment belongs-to Conversation
    var conversation: Conversation? {
        if let conversationId = self.conversationId {
            return ConversationDataController.shared.getConversation(by: conversationId)
        }
        return nil
    }

}
