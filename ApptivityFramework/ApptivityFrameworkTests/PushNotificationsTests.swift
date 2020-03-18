//
//  PushNotificationsTests.swift
//  ApptivityFramework
//
//  Created by Jason Khong on 10/28/16.
//  Copyright © 2016 Apptivity Lab. All rights reserved.
//

import XCTest
@testable import ApptivityFramework

class PushNotificationsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    /*
    func testReceiveNotification() {
        var userInfo: [AnyHashable : Any] = ["aps": ["alert": "As you wish"]]
        
        var beforeCount: Int = PushNotifications.shared.recentNotifications.count
        PushNotifications.shared.receiveRemoteNotification(userInfo: userInfo)
        var afterCount: Int = PushNotifications.shared.recentNotifications.count
        
        XCTAssert((beforeCount + 1) == afterCount, "Receiving notification should increment history by one")
    }
    
    func testUnreadCount() {
        PushNotifications.shared.markAllRead()
        var unreadCount = PushNotifications.shared.unreadBadgeCount()
        
        XCTAssert(unreadCount == 0, "Should have zero unread after marking all read")
        
        var userInfo: [AnyHashable : Any] = ["aps": ["alert": "As you wish"]]
        PushNotifications.shared.receiveRemoteNotification(userInfo: userInfo)
        unreadCount = PushNotifications.shared.unreadBadgeCount()
        
        XCTAssert(unreadCount == 1, "Should have 1 unread after receiving new notification")
    }
     */
}
