//
//  BillingPopUp.swift
//  TimeSelfCareData
//
//  Created by Chan Mun Yee on 15/03/2022.
//  Copyright © 2022 Apptivity Lab. All rights reserved.
//

import Foundation

public class BillingPopUp: JsonRecord {
    public var show: Bool?
    public var pdf_url: String?
    
    public required init?(with json: [String : Any]) {
       
        self.show = json["show"] as? Bool
        self.pdf_url = json["pdf_url"] as? String
    }
}
