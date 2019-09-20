//
//  AppDataTests.swift
//  AppDataTests
//
//  Created by AppLab on 01/11/2017.
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import XCTest
@testable import TimeSelfCareData
import ApptivityFramework

class AppDataTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testLogin() {
        let loadingExpectation: XCTestExpectation = expectation(description: "Should login first.")
        UserDefaults.standard.set(true, forKey: Installation.kIsStagingMode)
        let username: String = "770101011111"
        let password: String = "time123"

        APIClient.shared.loginWithEmail(username, password: password) { (error: Error?) in
            XCTAssertNil(error, "Login with valid credentials should not cause error")

            XCTAssertNotNil(AccountController.shared.profile, "After login, app should be able to access TIME profile.")
            loadingExpectation.fulfill()
        }

        self.wait(for: [loadingExpectation], timeout: 10)
    }

    func testLoadAccounts() {
        let loadingExpectation: XCTestExpectation = expectation(description: "Should load accounts.")

        self.testLogin()

        AccountDataController.shared.loadAccounts(profile: AccountController.shared.profile) { (accounts: [Account], error: Error?) in
            XCTAssertTrue(accounts.count > 0, "There should be at least 1 account for logged in user.")
            loadingExpectation.fulfill()
        }

        self.wait(for: [loadingExpectation], timeout: 10)
    }

    func testLoadBillingInfo() {
        let loadingExpectation: XCTestExpectation = expectation(description: "Should load billing info.")

        self.testLoadAccounts()
        BillingInfoDataController.shared.loadBillingInfos(account: AccountDataController.shared.getAccounts().first!) { (billingInfo: [BillingInfo], error: Error?) in
            XCTAssertTrue(!billingInfo.isEmpty, "Account should have ONE billing info")
            debugPrint(BillingInfoDataController.shared.getBillingInfos())

            loadingExpectation.fulfill()
        }

        self.wait(for: [loadingExpectation], timeout: 10)
    }

    func testUpdateBillingInfo() {
        let loadingExpectation: XCTestExpectation = expectation(description: "Should load billing info.")
        self.testLoadBillingInfo()
        var billingInfo: BillingInfo = BillingInfoDataController.shared.getBillingInfos(account: AccountDataController.shared.getAccounts().first!).first!
        billingInfo.billState = "Shah Alam"
        billingInfo.billingEmailAddress = "test@gmail.com"
        BillingInfoDataController.shared.updateBillingInfo(billingInfo: billingInfo) { (error: Error?) in
            XCTAssertNil(error, "Billing info should be updated without errors")
            loadingExpectation.fulfill()
        }
        self.wait(for: [loadingExpectation], timeout: 10)
    }

//    func testLoadAccountActivity() {
//        let loadingExpectation: XCTestExpectation = expectation(description: "Should load account activity.")
//
//        self.testLoadAccounts()
//
//        ActivityDataController.shared.loadActivities(account: AccountController.shared.profile.accounts.first!) { (activities: [Activity], error: Error?) in
//            XCTAssertTrue(!activities.isEmpty, "Accounts should have at least one activities.")
//            loadingExpectation.fulfill()
//        }
//        self.wait(for: [loadingExpectation], timeout: 10)
//    }

    func testLoadNotificationSetting() {
        let loadingExpectation: XCTestExpectation = expectation(description: "Should load notification setting.")
        self.testLoadAccounts()

        NotificationSettingDataController.shared.loadNotificationSettings(account: AccountDataController.shared.getAccounts().first!) { (notificationSettings: [NotificationSetting], error: Error?) in
            XCTAssertNil(error, "Load notification setting should not have error.")
            XCTAssertTrue(!notificationSettings.isEmpty, "Accounts should have at least one notifications.")
            loadingExpectation.fulfill()
        }
        self.wait(for: [loadingExpectation], timeout: 10)
    }

    func testUpdateNotificationSetting() {
        let loadingExpectation: XCTestExpectation = expectation(description: "Should load notification setting.")
        self.testLoadAccounts()
        self.testLoadNotificationSetting()

        let notificationSetting: NotificationSetting = NotificationSettingDataController.shared.getNotificationSettings(account: AccountDataController.shared.getAccounts().first!).first!

        notificationSetting.methodsString = notificationSetting.methodOptions.keys.joined(separator: ",")

        NotificationSettingDataController.shared.updateNotificationSetting(notificationSetting: notificationSetting) { (error: Error?) in
            XCTAssertNil(error, "Notification setting should be updated without errors")
            loadingExpectation.fulfill()
        }

        self.wait(for: [loadingExpectation], timeout: 10)
    }

    func testLoadServices() {
        let loadingExpectation: XCTestExpectation = expectation(description: "Should load services.")
        self.testLoadAccounts()
        let account = AccountDataController.shared.getAccounts().first!

        ServiceDataController.shared.loadServices(profile: account.profile, accountNo: account.accountNo) { (services: [Service], error: Error?) in
            XCTAssertNil(error, "Load services should not have error.")
            XCTAssertTrue(!services.isEmpty, "Services should have at least one service.")
            loadingExpectation.fulfill()
        }
        self.wait(for: [loadingExpectation], timeout: 10)
    }

    func testLoadSsids() {
        let loadingExpectation: XCTestExpectation = expectation(description: "Should load ssid.")
        self.testLoadAccounts()
        self.testLoadServices()
        
        let account = AccountDataController.shared.getAccounts().first!
        let service = ServiceDataController.shared.getServices(account: account).first(where: { $0.category == .broadband || $0.category == .broadbandAstro })

        SsidDataController.shared.loadSsids(account: account, service: service) { (ssid: [Ssid], error: Error?) in
            XCTAssertNil(error, "Load services should not have error.")
            XCTAssertTrue(!ssid.isEmpty, "Ssids should have at least one service.")
            loadingExpectation.fulfill()
        }

        self.wait(for: [loadingExpectation], timeout: 10)
    }

//    func testUpdateSSid() {
//        let loadingExpectation: XCTestExpectation = expectation(description: "Should load notification setting.")
//        self.testLoadSsids()
//        let account = AccountDataController.shared.getAccounts().first!
//        let service = ServiceDataController.shared.getServices(account: account).first(where: { $0.category == .broadband || $0.category == .broadbandAstro })
//
//        let ssid = SsidDataController.shared.getSsids(account: account, service: service).first!
//        ssid.name = "ApptivityLab 5-GHz"
//        ssid.password = "12345678"
//        SsidDataController.shared.updateSsid(ssid: ssid) { (error: Error?) in
//            XCTAssertNil(error, "Updating ssid should not have error.")
//            loadingExpectation.fulfill()
//        }
//
//        self.wait(for: [loadingExpectation], timeout: 10)
//    }

    func testLoadTickets() {
        let loadingExpectation: XCTestExpectation = expectation(description: "Should create ticket.")
        self.testLoadAccounts()
        let account = AccountDataController.shared.getAccounts().first!

        TicketDataController.shared.loadTickets(account: account) { (tickets: [Ticket], error: Error?) in
            XCTAssertNil(error, "Load ticket should not have error.")
            loadingExpectation.fulfill()
        }

        self.wait(for: [loadingExpectation], timeout: 10)
    }

    func testCreateTicket() {
        let loadingExpectation: XCTestExpectation = expectation(description: "Should create ticket.")
        self.testLoadTickets()
        let ticket = Ticket(id: "")
        ticket.categoryOptions = TicketDataController.shared.categoryOptions
        ticket.displayCategory = "Connection Issue"
        ticket.subject = "Test ticket - \(Date().string(usingFormat: "YYYY-MM-dd hh:mm:ss"))"
        ticket.description = "Test"
        ticket.accountNo = AccountDataController.shared.getAccounts().first!.accountNo

        let image: UIImage = UIImage(named: "time_router.jpg", in: Bundle(for: type(of: self)), compatibleWith: nil)!
        TicketDataController.shared.createTicket(ticket, attachments: [image]) { (error: Error?) in
            XCTAssertNil(error, "Create ticket should not have error.")
            loadingExpectation.fulfill()
        }
        self.wait(for: [loadingExpectation], timeout: 10)
    }

    func testLoadConversation() {
        let loadingExpectation: XCTestExpectation = expectation(description: "Should load conversation.")
        self.testLoadAccounts()
        let account = AccountDataController.shared.getAccounts().first!

        self.testCreateTicket()
        TicketDataController.shared.loadTickets { tickets, error in
            guard error == nil,
                let ticket = tickets.first else {
                    loadingExpectation.fulfill()
                    XCTAssert(true, "Should have at least 1 ticket and no error.")
                    return
            }

            ConversationDataController.shared.loadConversations(ticket: ticket, account: account) { (conversations: [Conversation], error: Error?) in
                XCTAssertNil(error, "Load conversation should not have error.")
                XCTAssert(!conversations.isEmpty, "Conversation should not be empty.")
                loadingExpectation.fulfill()
            }

        }
        self.wait(for: [loadingExpectation], timeout: 10)

    }

    func testReplyConversation() {
        let loadingExpectation: XCTestExpectation = expectation(description: "Should reply conversation.")
        self.testLoadAccounts()
        let account = AccountDataController.shared.getAccounts().first!

        self.testCreateTicket()
        TicketDataController.shared.loadTickets { tickets, error in
            guard error == nil,
                let ticket = tickets.first else {
                    loadingExpectation.fulfill()
                    XCTAssert(true, "Should have at least 1 ticket and no error.")
                    return
            }

            ConversationDataController.shared.loadConversations(ticket: ticket, account: account) { (conversations: [Conversation], error: Error?) in
                XCTAssertNil(error, "Load conversation should not have error.")
                XCTAssert(!conversations.isEmpty, "Conversation should not be empty.")
                loadingExpectation.fulfill()

                let conversation = Conversation(ticket: ticket)
                conversation.body = "Reply from test - \(Date().string(usingFormat: "YYYY-MM-dd hh:mm:ss"))"

                ConversationDataController.shared.replyConversation(conversation: conversation, attachment: []) { (error: Error?) in
                    XCTAssertNil(error, "Reply conversation should not have error.")
                    loadingExpectation.fulfill()
                }
            }

        }
        self.wait(for: [loadingExpectation], timeout: 10)
    }

    func testReplyConversationWithImage() {
        let loadingExpectation: XCTestExpectation = expectation(description: "Should reply conversation.")
        self.testLoadAccounts()
        let account = AccountDataController.shared.getAccounts().first!

        self.testCreateTicket()
        TicketDataController.shared.loadTickets { tickets, error in
            guard error == nil,
                let ticket = tickets.first else {
                    loadingExpectation.fulfill()
                    XCTAssert(true, "Should have at least 1 ticket and no error.")
                    return
            }

            ConversationDataController.shared.loadConversations(ticket: ticket, account: account) { (conversations: [Conversation], error: Error?) in
                XCTAssertNil(error, "Load conversation should not have error.")
                XCTAssert(!conversations.isEmpty, "Conversation should not be empty.")
                loadingExpectation.fulfill()

                let conversation = Conversation(ticket: ticket)
                conversation.body = "Reply from test - \(Date().string(usingFormat: "YYYY-MM-dd hh:mm:ss"))"

                let image: UIImage = UIImage(named: "time_router.jpg", in: Bundle(for: type(of: self)), compatibleWith: nil)!

                ConversationDataController.shared.replyConversation(conversation: conversation, attachment: [image]) { (error: Error?) in
                    XCTAssertNil(error, "Reply conversation should not have error.")
                    loadingExpectation.fulfill()
                }
            }

        }

        self.wait(for: [loadingExpectation], timeout: 10)
    }

    func testLoadRewards() {
        let loadingExpectation: XCTestExpectation = expectation(description: "Should load rewards.")
        self.testLoadAccounts()
        let account = AccountDataController.shared.getAccounts().first!

        RewardDataController.shared.loadRewards(account: account) { (rewards: [Reward], error: Error?) in
            XCTAssertNil(error, "Load rewards should not have error.")
            XCTAssert(!rewards.isEmpty, "Conversation should not be empty.")
            loadingExpectation.fulfill()
        }
        self.wait(for: [loadingExpectation], timeout: 10)
    }
}
