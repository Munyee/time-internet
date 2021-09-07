//
//  SupportDataController.swift
//  TimeSelfCareData
//
//  Created by Chan Mun Yee on 25/08/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import Foundation
import Alamofire

public class SupportDataController {
    private static let _sharedInstance: SupportDataController = SupportDataController()
    public static var shared: SupportDataController {
        return _sharedInstance
    }
    
    var supportVideos: [Video] = []
    
    func loadSupportVideosData(
        path: String,
        body: [String: Any],
        completion: @escaping ListListener<Video>
    ) {
        APIClient.shared.postRequest(path: path, body: body) { (json: [String: Any], error: Error?) in
            var videos: [Video] = []

            if let dataJson = json["data"] as? [String: Any], let youtubeList = dataJson["youtube_list"] as? [String: Any] {
                let videoJsonArray: [[String: Any]] = youtubeList.values.compactMap { value in
                    let dict = value as? [String: Any]
                    return dict
                }

               videos = self.processResponse(videoJsonArray)
            }
            completion(videos.sorted { Int($0.id ?? "") ?? 0 < Int($1.id ?? "") ?? 0 }, error)
        }
    }
    
    func processResponse(_ jsonArray: [[String: Any]]) -> [Video] {
        var videos: [Video] = []
        videos += self.process(jsonArray)
        self.insert(videos)

        return videos
    }

    private func process(_ jsonArray: [[String: Any]]) -> [Video] {
        return jsonArray.compactMap { Video(with: $0) }
    }


    private func insert(_ incomingVideos: [Video]) {
        self.supportVideos = incomingVideos
    }

    public func reset() {
        self.supportVideos.removeAll()
    }

}

public extension SupportDataController {
    func loadSupportVideos(
        completion: @escaping ListListener<Video>
    ) {
        let path = "get_youtube_list"
        let body: [String: Any] = [:]

        self.loadSupportVideosData(path: path, body: body, completion: completion)
    }
}
