//
//  RewardDataController.swift
//  TimeSelfCareData
//
//  Created by Loka on 03/07/2019.
//  Copyright © 2019 Apptivity Lab. All rights reserved.
//

import Foundation

public class RewardDataController {
    private static let _sharedInstance: RewardDataController = RewardDataController()
    public static var shared: RewardDataController {
        return _sharedInstance
    }

    var rewards: [Reward] = []

    func loadRewardData(
        path: String,
        body: [String: Any],
        completion: @escaping ListListener<Reward>
        ) {
        APIClient.shared
            .postRequest(path: path, body: body) { (json: [String: Any], error: Error?) in
                var rewards: [Reward] = []
                if var dataJson: [String: Any] = json["data"] as? [String: Any] {
                    let rewardsJson: [[String: Any]] = dataJson.values.compactMap { value in
                        var dict = value as? [String: Any]

                        dict?["account_no"] = body["account_no"]

                        if let keys = (dict?["outlets"] as? [String: Any])?.keys {
                            dict?["sorted_outlet_keys"] = Array(keys)
                        }

                        if (dict?["group_outlets"] as? Bool) == false {
                            let outlets = dict?["outlets"] ?? []
                            dict?["outlets"] = [Reward.OutletGroup.ungrouped.rawValue: outlets]
                        }

                        return dict
                    }
                    rewards = self.processResponse(rewardsJson)
                }
                completion(rewards, error)
            }
        }

    func processResponse(_ jsonArray: [[String: Any]]) -> [Reward] {
        var rewards: [Reward] = []
        rewards += self.process(jsonArray)
        self.insert(rewards)

        return rewards
    }

    private func process(_ jsonArray: [[String: Any]]) -> [Reward] {
        return jsonArray.compactMap { try? Reward(from: $0) }
    }

    private func insert(_ incomingRewards: [Reward]) {
        self.rewards = incomingRewards
    }

    public func reset() {
        self.rewards.removeAll()
    }
}

public extension RewardDataController {
    func getReward(by accountNo: String) -> Reward? {
        return self.rewards.first { $0.accountNo == accountNo }
    }

    func getRewards(
        account: Account? = nil
        ) -> [Reward] {
        var filteredItems = self.rewards

        if let account = account {
            filteredItems = filteredItems.filter { $0.accountNo == account.accountNo }
        }

        return filteredItems
    }

    func loadRewards(
        account: Account? = nil,
        completion: @escaping ListListener<Reward>
        ) {
        let path = "get_rewards_info"
        var body: [String: Any] = [:]
        body["username"] = account?.profileUsername
        body["account_no"] = account?.accountNo

        self.loadRewardData(path: path, body: body, completion: completion)
    }

    func grabReward(_ reward: Reward,
                    account: Account?,
                    completion: @escaping SimpleRequestListener) {
        var body: [String: Any] = [:]
        body["username"] = account?.profileUsername
        body["provider"] = reward.provider
        body["account_no"] = account?.accountNo

        APIClient.shared.postRequest(path: "grab_reward", body: body) { response, error in
            completion(response, error)
        }
    }

    func redeemReward(_ reward: Reward,
                      account: Account?,
                      completion: @escaping SimpleRequestListener) {
        var body: [String: Any] = [:]
        body["username"] = account?.profileUsername
        body["account_no"] = account?.accountNo
        body["provider"] = reward.provider
        body["year"] = reward.year

        APIClient.shared.postRequest(path: "redeem_reward", body: body) { response, error in
            completion(response, error)
        }

    }
}

/// JSONObject Extensions
extension Array where Element == [String: Any] {
    func asJSONData() throws -> Data {
        return try JSONSerialization.data(withJSONObject: self, options: [])
    }
}

extension Decodable {
    init(from: Any) throws {
        let data = try JSONSerialization.data(withJSONObject: from, options: .prettyPrinted)
        let decoder = JSONDecoder()
        self = try decoder.decode(Self.self, from: data)
    }
}
