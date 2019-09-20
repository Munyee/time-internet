//  AttachmentDataController.swift
//  TimeSelfCareData/Controllers
//
//  Opera House | Data - Data Controller
//  Updated 2018-02-23
//  Copyright © 2018 Apptivity Lab. All rights reserved.
//

import Foundation
import Alamofire

public class AttachmentDataController {
    private static let _sharedInstance: AttachmentDataController = AttachmentDataController()
    public static var shared: AttachmentDataController {
        return _sharedInstance
    }

    var attachments: [Attachment] = []

    func processResponse(_ jsonArray: [[String: Any]]) -> [Attachment] {
        var attachments: [Attachment] = []
        attachments += self.process(jsonArray)
        self.insert(attachments)

        return attachments
    }

    private func process(_ jsonArray: [[String: Any]]) -> [Attachment] {
        return jsonArray.compactMap { Attachment(with: $0) }
    }

    private func insert(_ incomingAttachments: [Attachment]) {
        let allAttachments = incomingAttachments + self.attachments

        let incomingNames: [String] = incomingAttachments.compactMap { $0.name }
        let existingNames: [String] = self.attachments.compactMap { $0.name }

        let incomingUnionExistingNames = Set<String>(incomingNames + existingNames)
        self.attachments = incomingUnionExistingNames.compactMap { (name: String) -> Attachment? in
            allAttachments.first { $0.name == name }
        }

        return
    }

    public func reset() {
        self.attachments.removeAll()
    }
}

public extension AttachmentDataController {
    func getAttachment(by name: String) -> Attachment? {
        return self.attachments.first { $0.name == name }
    }

    func getAttachments(
        ticket: Ticket? = nil,
        conversation: Conversation? = nil,
        url: String? = nil,
        searchText: String? = nil
        ) -> [Attachment] {
        var filteredItems = self.attachments

        if let ticket = ticket {
            filteredItems = filteredItems.filter { $0.ticketId == ticket.id }
        }
        if let conversation = conversation {
            filteredItems = filteredItems.filter { $0.conversationId == conversation.id }
        }
        return filteredItems.sorted { $0.name < $1.name }
    }
}
