//
//  Videos.swift
//  TimeSelfCareData
//
//  Created by Chan Mun Yee on 25/08/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import Foundation

public class Video: JsonRecord {
    public let id: String?
    public var videoId: String?
    public var videoTitle: String?
    public var videoCategory: String?
    public var videoDuration: String?
    public var add_date: String?

    public init() {
        self.id = String()
        self.videoId = String()
        self.videoTitle = String()
        self.videoCategory = String()
        self.videoDuration = String()
        self.add_date = String()
    }

    public required init?(with json: [String : Any]) {
        self.id = json["id"] as? String
        self.videoId = json["videoId"] as? String
        self.videoTitle = json["videoTitle"] as? String
        self.videoCategory = json["videoCategory"] as? String
        self.videoDuration = json["videoDuration"] as? String
        self.add_date = json["add_date"] as? String
    }
}
