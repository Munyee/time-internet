//
//  BillingPopUpDataController.swift
//  TimeSelfCareData
//
//  Created by Chan Mun Yee on 15/03/2022.
//  Copyright © 2022 Apptivity Lab. All rights reserved.
//

import Foundation
import Alamofire

public class BillingPopUpDataController {
    private static let _sharedInstance: BillingPopUpDataController = BillingPopUpDataController()
    public static var shared: BillingPopUpDataController {
        return _sharedInstance
    }

    var billingPopup: BillingPopUp?

    func loadBillingPopupData(
        path: String,
        body: [String: Any],
        completion: @escaping ElementListener<BillingPopUp>
    ) {
        APIClient.shared
            .postRequest(path: path, body: body) { (json: [String: Any], error: Error?) in
                if let dataJSON = json["data"] as? [String: Any] {
                    let result = BillingPopUp(with: dataJSON)
                    completion(result, error)
                }
            }
    }
}

public extension BillingPopUpDataController {
    func loadBillingPopUp (
        account: Account? = nil,
        completion: @escaping ElementListener<BillingPopUp>
    ) {
        let path = "get_popup"
        let body = [
            "username": AccountController.shared.profile?.username,
            "account_no": account?.accountNo,
        ]
        self.loadBillingPopupData(path: path, body: body, completion: completion)
    }
}
