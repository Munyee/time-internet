//
//  ActivityNotification.swift
//  TimeSelfCareData
//
//  Created by Loka on 24/05/2018.
//  Copyright © 2018 Apptivity Lab. All rights reserved.
//

import Foundation
import ApptivityFramework

public class ActivityNotification: AlertNotification {
    public var activity: Activity

    override public init?(userInfo: [AnyHashable : Any]) {
        guard let activitytJson = userInfo["activity"] as? [String: Any] else {
                debugPrint("Notification userInfo does not contain valid activity")
                return nil
        }

        guard let activity = ActivityDataController.shared.processResponse([activitytJson]).first else {
            return nil
        }

        self.activity = activity
        super.init(userInfo: userInfo)
    }
}

public class BillNotification: AlertNotification {
    public var bill: Bill

    override public init?(userInfo: [AnyHashable : Any]) {
        guard let billJson = userInfo["bill"] as? [String: Any] else {
            debugPrint("Notification userInfo does not contain valid activity")
            return nil
        }

        guard let bill = BillDataController.shared.processResponse([billJson]).first else {
            return nil
        }

        self.bill = bill
        super.init(userInfo: userInfo)
    }
}
