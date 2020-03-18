//
//  AlertNotification.swift
//  ApptivityFramework
//
//  Created by Jason Khong on 10/28/16.
//  Copyright © 2016 Apptivity Lab. All rights reserved.
//

import Foundation

open class GeneralNotification : Equatable {
    var uuid: String
    
    public init(uuid: String) { 
        self.uuid = uuid
    }
    
    public static func ==(lhs: GeneralNotification, rhs: GeneralNotification) -> Bool {
        return (lhs.uuid == rhs.uuid)
    }
}

open class AlertNotification : GeneralNotification {
    public var title: String?
    public var body: String?
    
    public var badge: Int?
    public var sound: String?
    public var contentAvailable: Bool?
    public var category: String?
    
    public var unread: Bool = false
    
    public init?(userInfo: [AnyHashable : Any]) {
        guard
            let apsDict: [AnyHashable : Any] = userInfo["aps"] as? [AnyHashable : Any],
            let uuid = userInfo["uuid"] as? String,
            let unread = userInfo["unread"] as? Bool
        else {
            debugPrint("GeneralNotification init failed")
            return nil
        }

        super.init(uuid: uuid)
        self.unread = unread
        
        if let alertString = apsDict["alert"] as? String {
            self.title = alertString
        } else if let alertDict = apsDict["alert"] as? [AnyHashable : Any] {
            self.title = alertDict["title"] as? String
            self.body = alertDict["body"] as? String
        }
    }
    
    static func ==(lhs: AlertNotification, rhs: AlertNotification) -> Bool {
        return (lhs.uuid == rhs.uuid)
    }
}

public class SilentNotification : GeneralNotification {
    var badge: Int?
    var contentAvailable: Bool?
    var category: String?
    
    public init?(userInfo: [AnyHashable : Any]) {
        guard
            let uuid = userInfo["uuid"] as? String,
            let _ = userInfo["unread"] as? Bool
            else {
                debugPrint("GeneralNotification init failed")
                return nil
        }
        
        super.init(uuid: uuid)
    }
}
