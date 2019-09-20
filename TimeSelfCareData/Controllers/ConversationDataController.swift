//  ConversationDataController.swift
//  TimeSelfCareData/Controllers
//
//  Opera House | Data - Data Controller
//  Updated 2018-02-23
//  Copyright © 2018 Apptivity Lab. All rights reserved.
//

import Foundation
import Alamofire

public class ConversationDataController {
    private static let _sharedInstance: ConversationDataController = ConversationDataController()
    public static var shared: ConversationDataController {
        return _sharedInstance
    }

    var conversations: [Conversation] = []

    func loadConversationData(
        path: String,
        body: [String: Any],
        completion: @escaping ListListener<Conversation>
        ) {
        APIClient.shared.postRequest(path: path, body: body) { (json: [String: Any], error: Error?) in
            var conversations: [Conversation] = []

            if let dataJson = json["data"] as? [String: Any],
                let conversationsJson = dataJson["conversations"] as? [String: Any] {

                let conversationJsonArray: [[String: Any]] = conversationsJson.keys.compactMap { key in
                    var conversationJson = conversationsJson[key] as? [String: Any]
                    conversationJson?["account_no"] = body["account_no"]
                    conversationJson?["ticket_id"] = body["ticket_id"]

                    let timestamp: Int? = conversationJson?["timestamp"] as? Int
                    conversationJson?["id"] = (body["ticket_id"] as? String ?? String()) + (timestamp == nil ? key : "\(timestamp!)") // swiftlint:disable:this force_unwrapping

                    return conversationJson
                }
                conversations = self.processResponse(conversationJsonArray)
            }

            completion(conversations, error)
        }
    }

    func processResponse(_ jsonArray: [[String: Any]]) -> [Conversation] {
        // Conversation has-many Attachment (attachment)
        var attachmentJsonArray: [[String: Any]] = []
        for json in jsonArray {
            if let attachmentsJson = json["attachments"] as? [String: Any] {
                for key in attachmentsJson.keys {
                    if var attachmentJson = attachmentsJson[key] as? [String: Any] {
                        attachmentJson["conversation_id"] = json["id"]
                        attachmentJsonArray.append(attachmentJson)
                    }
                }
            }
        }
        _ = AttachmentDataController.shared.processResponse(attachmentJsonArray)

        // Process Conversation Data
        var conversations: [Conversation] = []
        conversations += self.process(jsonArray)
        self.insert(conversations)

        return conversations
    }

    private func process(_ jsonArray: [[String: Any]]) -> [Conversation] {
        return jsonArray.compactMap { Conversation(with: $0) }
    }

    private func insert(_ incomingConversations: [Conversation]) {
        let allConversations = incomingConversations + self.conversations

        let incomingIds: [String] = incomingConversations.compactMap { $0.id }
        let existingIds: [String] = self.conversations.compactMap { $0.id }

        let incomingUnionExistingIds = Set<String>(incomingIds + existingIds)
        self.conversations = incomingUnionExistingIds.compactMap { (id: String) -> Conversation? in
            allConversations.first { $0.id == id && $0.status != .success }
        }

        return
    }

    public func reset() {
        self.conversations.removeAll()
    }
}

public extension ConversationDataController {
    func getConversation(by id: String) -> Conversation? {
        return self.conversations.first { $0.id == id }
    }

    func getConversations(
        ticket: Ticket? = nil
        ) -> [Conversation] {
        var filteredItems = self.conversations

        if let ticket = ticket {
            filteredItems = filteredItems.filter { $0.ticketId == ticket.id }
        }
        return filteredItems
    }

    func loadConversations(
        ticket: Ticket? = nil,
        account: Account? = nil,
        completion: @escaping ListListener<Conversation>
        ) {
        let path = "get_ticket_conversations"
        var body: [String: Any] = [:]
        body["username"] = AccountController.shared.profile.username
        body["account_no"] = account?.accountNo
        body["ticket_id"] = ticket?.id
        self.loadConversationData(path: path, body: body, completion: completion)
    }

    func replyConversation(
        conversation: Conversation,
        attachment: [UIImage],
        completion: @escaping SimpleRequestListener
        ) {

        let path: String = "reply_ticket"
        var body: [String: Any] = [:]
        body["username"] = AccountController.shared.profile.username
        body["account_no"] = conversation.ticket?.accountNo

        for (key, value) in conversation.toJson() {
            body[key] = value
        }

        self.insert([conversation])

        APIClient.shared.uploadMultipart(path: path, body: body, images: attachment, completion: completion)
    }

    func remove(conversation: Conversation) {
        if let index = self.conversations.index(where: { $0.id == conversation.id }) {
            self.conversations.remove(at: index)
        }
    }
}
