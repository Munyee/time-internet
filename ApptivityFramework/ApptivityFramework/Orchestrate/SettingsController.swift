//
//  SettingsController.swift
//  ApptivityFramework
//
//  Created by AppLab on 07/08/2017.
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import UIKit

public extension NSNotification.Name {
    public static let SettingsDidLoad: NSNotification.Name = NSNotification.Name(rawValue: "Orchestra.SettingsDidLoadNotification")
}

public class SettingsController {

    fileprivate static let _shared: SettingsController = SettingsController()
    fileprivate var settings: [Setting] = []

    public static func shared() -> SettingsController? {
        guard OrchestraURLSessionProvider.shared() != nil else {
            return nil
        }
        return SettingsController._shared
    }

    init() {
        if let cacheDirectoryURL = FileManager.default.urls(for: FileManager.SearchPathDirectory.cachesDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first {
            let cachedSettingsJsonURL = cacheDirectoryURL.appendingPathComponent("settings.json")
            do {
                let data = try Data(contentsOf: cachedSettingsJsonURL)
                self.settings = try self.populateSettingsFromCachedData(data)
            } catch {
                debugPrint("Failed to load cached settings")
            }
        }
    }

    private func cacheSettingsData(jsonData: Data) {
        if let cacheDirectoryURL = FileManager.default.urls(for: FileManager.SearchPathDirectory.cachesDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first {
            let cachedSettingsJsonURL = cacheDirectoryURL.appendingPathComponent("settings.json")
            do {
                try jsonData.write(to: cachedSettingsJsonURL)
            } catch {
                debugPrint("Error caching settings: \(error)")
            }
        }
    }

    private func populateSettingsFromCachedData(_ jsonData: Data) throws -> [Setting] {
        var settings: [Setting] = []

        if let jsonObject: [String : Any] = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : Any],
            let resource: [[String: Any]] = jsonObject["resource"] as? [[String : Any]] {
            for settingJson in resource {
                if let setting: Setting = Setting(with: settingJson) {
                    settings.append(setting)
                }
            }
        }

        return settings
    }

    public func refreshSettings(completion: @escaping ((_ settings: [Setting], _ error: Error?) -> Void)) {
        guard let bundleIdentifier: String = Bundle.main.bundleIdentifier,
            let sessionProvider = OrchestraURLSessionProvider.shared(),
            let request: URLRequest = sessionProvider.orchestraURLRequest(with: "GET", path: "settings/iOS/\(bundleIdentifier)") else {
                completion([], NSError(domain: "orchestra", code: 400, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Invalid request.", comment: "Invalid request.")]))
                return
        }

        let dataTask = sessionProvider.session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            var actualError: Error? = error
            var settings: [Setting] = []

            do {
                if let jsonData = data,
                    let jsonObject: [String : Any] = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : Any],
                    let resource: [[String: Any]] = jsonObject["resource"] as? [[String : Any]] {
                    for settingJson in resource {
                        if let setting: Setting = Setting(with: settingJson) {
                            settings.append(setting)
                        }
                    }

                    self.cacheSettingsData(jsonData: jsonData)
                } else if let error = error {
                    debugPrint("Error fetching settings: \(error)")
                }
            } catch {
                debugPrint("Error fetching settings: \(error)")
                actualError = error
            }

            DispatchQueue.main.async {
                if actualError == nil {
                    self.settings = settings
                }

                NotificationCenter.default.post(name: NSNotification.Name.SettingsDidLoad, object: nil)
                completion(settings, actualError)
            }
        }
        dataTask.resume()
    }

    public func settingValue(withName name: String) -> String? {
        return self.settings.first(where: { $0.name == name })?.value
    }

    public func boolValue(withName name: String) -> Bool? {
        guard let setting = self.settingValue(withName: name) else {
            return nil
        }
        if setting == "true" || (setting as NSString).boolValue {
            return true
        } else {
            return false
        }
    }

    public func intValue(withName name: String) -> Int? {
        guard let setting = self.settingValue(withName: name) else {
            return nil
        }
        return (setting as NSString).integerValue
    }

    public func doubleValue(withName name: String) -> Double? {
        guard let setting = self.settingValue(withName: name) else {
            return nil
        }
        return (setting as NSString).doubleValue
    }
}
