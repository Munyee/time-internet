//  ProfileDataController.swift
//  TimeSelfCareData/Controllers
//
//  Opera House | Data - Data Controller
//  Updated 2017-11-13
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import Foundation
import Alamofire

public class ProfileDataController {
    private static let _sharedInstance: ProfileDataController = ProfileDataController()
    public static var shared: ProfileDataController {
        return _sharedInstance
    }

    var profiles: [Profile] = []

    func loadProfileData(
        related: [String] = [],
        filters: [String] = [],
        order: [String] = [],
        offset: Int = 0,
        limit: Int = 1_000,
        completion: @escaping ListListener<Profile>
    ) {
        let combinedRelated = ([
            ] + related).joined(separator: ",")

        let combinedFilter = ([
            ] + filters).joined(separator: " AND ")

        let combinedOrder = ([
            ] + order).joined(separator: ",")

        APIClient.shared
            .getRequest(
                path: "data/profiles",
                filter: combinedFilter,
                related: combinedRelated,
                order: combinedOrder,
                offset: offset,
                limit: limit)
            .responseJSON { (response: DataResponse<Any>) in
                var profiles: [Profile] = []
                var responseError: Error? = nil

                do {
                    let responseJSON = try APIClient.shared.JSONFromResponse(response: response)
                    if let resourceJSON = responseJSON["resource"] as? [[String : Any]] {
                        profiles = self.processResponse(resourceJSON)
                    }
                } catch {
                    responseError = error
                    debugPrint("Error loading profiles: \(error)")
                }

                completion(profiles, responseError)
            }
    }

    func processResponse(_ jsonArray: [[String : Any]]) -> [Profile] {
        // Process Profile Data
        var profiles: [Profile] = []
        profiles += self.process(jsonArray)
        self.insert(profiles)

        return profiles
    }

    private func process(_ jsonArray: [[String : Any]]) -> [Profile] {
        return jsonArray.flatMap { Profile(with: $0) }
    }

    private func insert(_ incomingProfiles: [Profile]) {
        let allProfiles = incomingProfiles + self.profiles

        let incomingUsernames: [String] = incomingProfiles.flatMap { $0.username }
        let existingUsernames: [String] = self.profiles.flatMap { $0.username }

        let incomingUnionExistingUsernames = Set<String>(incomingUsernames + existingUsernames)
        self.profiles = incomingUnionExistingUsernames.flatMap { (username: String) -> Profile? in
            allProfiles.first { $0.username == username }
        }

        return
    }
}

public extension ProfileDataController {
    func getProfile(by username: String) -> Profile? {
        return self.profiles.first { $0.username == username }
    }

    func getProfiles(
        searchText: String? = nil
    ) -> [Profile] {
        var filteredItems = self.profiles

        return filteredItems
    }

    func loadProfiles(
        username: String? = nil,
        searchText: String? = nil,
        order: [String] = [],
        offset: Int = 0,
        limit: Int = 1_000,
        completion: @escaping ListListener<Profile>
    ) {
        var filters: [String] = []

        if let username = username {
            filters.append("(username = \(username))")
        }

        self.loadProfileData(
            filters: filters,
            order: order,
            offset: offset,
            limit: limit,
            completion: completion)
    }

}
