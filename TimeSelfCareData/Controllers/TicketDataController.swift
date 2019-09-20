//  TicketDataController.swift
//  TimeSelfCareData/Controllers
//
//  Opera House | Data - Data Controller
//  Updated 2018-02-23
//  Copyright © 2018 Apptivity Lab. All rights reserved.
//

import Foundation
import Alamofire

public class TicketDataController {
    private static let _sharedInstance: TicketDataController = TicketDataController()
    public static var shared: TicketDataController {
        return _sharedInstance
    }

    var tickets: [Ticket] = []

    public var categoryOptions: [String: String] = [:]

    func loadTicketData(
        path: String,
        body: [String: Any],
        completion: @escaping ListListener<Ticket>
    ) {
        APIClient.shared.postRequest(path: path, body: body) { (json: [String: Any], error: Error?) in
            var tickets: [Ticket] = []

            if let dataJson = json["data"] as? [String: Any],
                let ticketsJson = dataJson["tickets"] as? [String: Any] {

                var ticketJsonArray: [[String: Any]] = []
                for key in ticketsJson.keys {
                    if var ticketJson = ticketsJson[key] as? [String: Any] {
                        ticketJson["account_no"] = body["account_no"]
                        ticketJson["list_status"] = dataJson["list_status"]
                        ticketJson["list_category"] = dataJson["list_category"]
                        ticketJsonArray.append(ticketJson)
                    }
                }

                tickets = self.processResponse(ticketJsonArray)
                self.categoryOptions = dataJson["list_category"] as? [String: String] ?? [:]
            }
            completion(tickets, error)
        }
    }

    func processResponse(_ jsonArray: [[String: Any]]) -> [Ticket] {
        var attachmentJsonArray: [[String: Any]] = []
        for json in jsonArray {
            if let attachmentsJson = json["attachments"] as? [String: Any] {
                for key in attachmentsJson.keys {
                    if var attachmentJson = attachmentsJson[key] as? [String: Any] {
                        attachmentJson["ticket_id"] = json["ticket_id"]
                        attachmentJson["name"] = "\(json["ticket_id"] ?? "")-\(attachmentJson["name"])"
                        attachmentJsonArray.append(attachmentJson)
                    }
                }
            }
        }
       _ = AttachmentDataController.shared.processResponse(attachmentJsonArray)

        var tickets: [Ticket] = []
        tickets += self.process(jsonArray)
        self.insert(tickets)

        return tickets
    }

    private func process(_ jsonArray: [[String: Any]]) -> [Ticket] {
        return jsonArray.compactMap { Ticket(with: $0) }
    }

    private func insert(_ incomingTickets: [Ticket]) {
        let allTickets = incomingTickets + self.tickets

        let incomingIds: [String] = incomingTickets.compactMap { $0.id }
        let existingIds: [String] = self.tickets.compactMap { $0.id }

        let incomingUnionExistingIds = Set<String>(incomingIds + existingIds)
        self.tickets = incomingUnionExistingIds.compactMap { (id: String) -> Ticket? in
            allTickets.first { $0.id == id }
        }

        let sortedList = self.tickets
                .sorted {
                    $0.timestamp ?? Int.min > $1.timestamp ?? Int.min
                }
        self.tickets = sortedList
        return
    }

    public func reset() {
        self.tickets.removeAll()
    }
}

public extension TicketDataController {
    func getTicket(by id: String) -> Ticket? {
        return self.tickets.first { $0.id == id }
    }

    func getTickets(
        account: Account? = nil
    ) -> [Ticket] {
        var filteredItems = self.tickets

        if let account = account {
            filteredItems = filteredItems.filter { $0.accountNo == account.accountNo }
        }
        return filteredItems
    }

    func loadTickets(
        account: Account? = nil,
        completion: @escaping ListListener<Ticket>
    ) {
        let path = "get_tickets_info"
        var body: [String: Any] = [:]
        body["username"] = AccountController.shared.profile?.username
        body["account_no"] = account?.accountNo

        self.loadTicketData(path: path, body: body, completion: completion)
    }

    func createTicket(
        _ ticket: Ticket,
        account: Account? = nil,
        attachments: [UIImage],
        completion: @escaping SimpleRequestListener
    ) {
        let path: String = "raise_ticket"

        var body: [String: Any] = [:]
        body["username"] = AccountController.shared.profile.username

        for (key, value) in ticket.toJson() {
            body[key] = value
        }

       APIClient.shared.uploadMultipart(path: path, body: body, images: attachments, completion: completion)
    }
}
