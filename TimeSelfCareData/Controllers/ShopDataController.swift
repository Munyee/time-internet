//
//  ShopDataController.swift
//  TimeSelfCareData
//
//  Created by Raviteja Gadige on 10/09/2020.
//  Copyright © 2020 Apptivity Lab. All rights reserved.
//

import Foundation
import Alamofire

public class ShopDataController {
    private static let _sharedInstance: ShopDataController = ShopDataController()
    public static var shared: ShopDataController {
        return _sharedInstance
    }
}

