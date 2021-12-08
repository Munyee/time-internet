//
//  FreshChatManager.swift
//  TimeSelfCare
//
//  Created by Adrian Kok Jee Wai on 26/11/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import Foundation

class FreshChatManager {
    static let shared: FreshChatManager = FreshChatManager()
    static let kRestoreId: String = "RestoreID"
    
    var restoreID: String? {
        get {
            return UserDefaults.standard.string(forKey: FreshChatManager.kRestoreId)
        }
    }
    
    // Called from app delegate
    func listenForRestoreId() {
        NotificationCenter.default.addObserver(self, selector: #selector(userRestoreIdReceived), name: NSNotification.Name(rawValue: FRESHCHAT_USER_RESTORE_ID_GENERATED), object: nil)
    }
    
    @objc func userRestoreIdReceived() {
        if let restoreID = FreshchatUser.sharedInstance().restoreID {
            UserDefaults.standard.set(restoreID, forKey: FreshChatManager.kRestoreId)
        }
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: FreshChatManager.kRestoreId)
        Freshchat.sharedInstance().resetUser(completion: nil)
    }
}
