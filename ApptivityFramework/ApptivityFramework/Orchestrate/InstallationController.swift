//
//  InstallationController.swift
//  ApptivityFramework
//
//  Created by AppLab on 27/06/2017.
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import UIKit

class InstallationController {
    fileprivate static let _shared: InstallationController = InstallationController()

    static func shared() -> InstallationController? {
        guard OrchestraURLSessionProvider.shared() != nil else {
                return nil
        }
        return InstallationController._shared
    }

    func createInstallation(_ installation: Installation, completion: ((_ error: Error?) -> Void)?) {
        guard let sessionProvider = OrchestraURLSessionProvider.shared(),
            let request: URLRequest = sessionProvider.orchestraURLRequest(with: "POST", path: "installations", body: installation.toJson()) else {
            completion?(NSError(domain: "orchestra", code: 400, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Invalid request.", comment: "Invalid request.")]))
            return
        }

        let dataTask = sessionProvider.session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            var actualError: Error? = error

            do {
                if let jsonData = data,
                    let jsonObject: [String : Any] = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : Any] {
                    debugPrint("Created installation successfully: \(jsonObject)")
                } else if let error = error {
                    debugPrint("Error saving installation: \(error)")
                }
            } catch {
                debugPrint("Error saving installation: \(error)")
                actualError = error
            }

            DispatchQueue.main.async {
                completion?(actualError)
            }
        }
        dataTask.resume()
    }

    func updateInstallation(_ installation: Installation, completion: ((_ error: Error?) -> Void)?) {
        guard let sessionProvider = OrchestraURLSessionProvider.shared(),
            let request: URLRequest = sessionProvider.orchestraURLRequest(with: "PATCH", path: "installations/\(installation.uuid.uuidString.lowercased())", body: installation.toJson()) else {
            completion?(NSError(domain: "orchestra", code: 400, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Invalid request.", comment: "Invalid request.")]))
            return
        }

        let dataTask = sessionProvider.session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            var actualError: Error? = error

            do {
                if let jsonData = data,
                    let jsonObject: [String : Any] = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : Any] {
                    debugPrint("Updated installation successfully: \(jsonObject)")
                } else if let error = error {
                    debugPrint("Error saving installation: \(error)")
                }
            } catch {
                debugPrint("Error saving installation: \(error)")
                actualError = error
            }

            DispatchQueue.main.async {
                completion?(actualError)
            }
        }
        dataTask.resume()
    }

    func unlinkUserFromInstallation(_ installation: Installation, completion: ((_ error: Error?) -> Void)?) {
        installation.clearSubscriptions()

        guard let sessionProvider = OrchestraURLSessionProvider.shared(),
            let request: URLRequest = sessionProvider.orchestraURLRequest(with: "DELETE", path: "installations/\(installation.uuid.uuidString.lowercased())/user_profile_uuid") else {
            completion?(NSError(domain: "orchestra", code: 400, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Invalid request.", comment: "Invalid request.")]))
            return
        }

        let dataTask = sessionProvider.session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            var actualError: Error? = error

            do {
                if let jsonData = data,
                    let jsonObject: [String : Any] = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : Any] {
                    debugPrint("Unlinked installation successfully: \(jsonObject)")
                } else if let error = error {
                    debugPrint("Error unlinking installation: \(error)")
                }
            } catch {
                debugPrint("Error unlinking installation: \(error)")
                actualError = error
            }

            DispatchQueue.main.async {
                completion?(actualError)
            }
        }
        dataTask.resume()
    }

    func fetchSubscriptionsForInstallation(_ installation: Installation, completion: @escaping ((_ subscriptions: [Installation.Subscription], _ error: Error?) -> Void)) {
        guard let sessionProvider = OrchestraURLSessionProvider.shared(),
            let request: URLRequest = sessionProvider.orchestraURLRequest(with: "GET", path: "data/installation_subscriptions", query: [
            "filter": "((installation_uuid=\(installation.uuid.uuidString.lowercased())) AND (deleted_at IS NULL))",
            "related": "installations_by_installation_uuid"
            ]) else {
                completion([], NSError(domain: "orchestra", code: 400, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Invalid request.", comment: "Invalid request.")]))
                return
        }

        let dataTask = sessionProvider.session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            var actualError: Error? = error
            var subscriptions: [Installation.Subscription] = []

            do {
                if let jsonData = data,
                    let jsonObject: [String : Any] = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : Any],
                    let resource: [[String: Any]] = jsonObject["resource"] as? [[String : Any]] {
                    for subscriptionJson in resource {
                        if let subscription: Installation.Subscription = Installation.Subscription(with: subscriptionJson) {
                            subscriptions.append(subscription)
                        }
                    }
                } else if let error = error {
                    debugPrint("Error fetching subscriptions for installation: \(error)")
                }
            } catch {
                debugPrint("Error fetching subscriptions for installation: \(error)")
                actualError = error
            }

            DispatchQueue.main.async {
                completion(subscriptions, actualError)
            }
        }
        dataTask.resume()
    }

    func createSubscription(_ subscription: Installation.Subscription, forInstallation installation: Installation, completion: ((_ error: Error?) -> Void)?) {
        guard let sessionProvider = OrchestraURLSessionProvider.shared(),
            let request: URLRequest = sessionProvider.orchestraURLRequest(with: "POST", path: "installations/\(installation.uuid.uuidString.lowercased())/subscribe", body: subscription.toJson()) else {
            completion?(NSError(domain: "orchestra", code: 400, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Invalid request.", comment: "Invalid request.")]))
            return
        }

        let dataTask = sessionProvider.session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            var actualError: Error? = error

            do {
                if let jsonData = data,
                    let jsonObject: [String : Any] = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : Any] {
                    debugPrint("Successfully subscribe installation to interest: \(jsonObject)")
                } else if let error = error {
                    debugPrint("Error subscribing installation to interest: \(error)")
                }
            } catch {
                debugPrint("Error subscribing installation to interest: \(error)")
                actualError = error
            }

            DispatchQueue.main.async {
                completion?(actualError)
            }
        }
        dataTask.resume()
    }
}
