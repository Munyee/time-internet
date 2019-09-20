//
//  UIApplication+Apptivity.swift
//  ApptivityFramework
//
//  Created by Jason Khong on 10/24/16.
//  Copyright © 2016 Apptivity Lab. All rights reserved.
//

import UIKit
import UserNotifications
import CoreLocation

public extension UIApplication {

    public enum NavigationProvider {
        case googleMaps
        case waze
        case appleMaps

        public var urlScheme: String {
            switch self {
            case .googleMaps:
                return "comgooglemaps://"
            case .waze:
                return "waze://"
            case .appleMaps:
                return "https://maps.apple.com/"
            }
        }

        public var title: String {
            switch self {
            case .googleMaps:
                return "Google Maps"
            case .waze:
                return "Waze"
            case .appleMaps:
                return "Apple Maps"
            }
        }
    }

    public func openApplicationSettings() {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
        }
    }

    public func makePhoneCall(phoneNumber: String) {
        let strArray = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted)
        let trimmedPhoneNumber = strArray.joined(separator: "")

        guard
            self.canOpenURL(URL(string: "tel://")!),
            let url = URL(string: "tel://\(trimmedPhoneNumber)")
        else {
            return
        }

        if #available(iOS 10.0, *) {
            self.open(url)
        } else {
            self.openURL(url)
        }
    }

    public func canNavigateWith(provider: NavigationProvider) -> Bool {
        return self.canOpenURL(URL(string: provider.urlScheme)!)
    }

    public func navigateWithGoogleMaps(coordinate: CLLocationCoordinate2D) {
        if self.canNavigateWith(provider: .googleMaps) {
            guard let url = URL(string: "\(NavigationProvider.googleMaps.urlScheme)?center=\(coordinate.latitude),\(coordinate.longitude)&q=\(coordinate.latitude),\(coordinate.longitude)") else {
                return
            }

            if #available(iOS 10.0, *) {
                self.open(url)
            } else {
                self.openURL(url)
            }
        }
    }

    public func searchWithGoogleMaps(address: String) {
        if self.canNavigateWith(provider: .googleMaps) {
            let formattedAddress: String = address.replacingOccurrences(of: " ", with: "+")

            guard let url = URL(string: "\(NavigationProvider.googleMaps.urlScheme)?center=\(formattedAddress)&q=\(formattedAddress)") else {
                return
            }

            if #available(iOS 10.0, *) {
                self.open(url)
            } else {
                self.openURL(url)
            }
        }
    }

    public func navigateWithWaze(coordinate: CLLocationCoordinate2D) {
        if self.canNavigateWith(provider: .waze) {
            guard let url = URL(string: "\(NavigationProvider.waze.urlScheme)?ll=\(coordinate.latitude),\(coordinate.longitude)&navigate=yes") else {
                return
            }

            if #available(iOS 10.0, *) {
                self.open(url)
            } else {
                self.openURL(url)
            }
        }
    }

    public func searchWithWaze(address: String) {
        if self.canNavigateWith(provider: .waze) {
            guard
                let formattedAddress: String = (address as NSString).addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
                let url = URL(string: "\(NavigationProvider.waze.urlScheme)?q=\(formattedAddress)")
                else {
                    return
            }

            if #available(iOS 10.0, *) {
                self.open(url)
            } else {
                self.openURL(url)
            }
        }
    }

    public func navigateWithAppleMaps(coordinate: CLLocationCoordinate2D) {
        if self.canNavigateWith(provider: .appleMaps) {
            guard let url = URL(string: "\(NavigationProvider.appleMaps.urlScheme)?daddr=\(coordinate.latitude),\(coordinate.longitude)") else {
                return
            }

            if #available(iOS 10.0, *) {
                self.open(url)
            } else {
                self.openURL(url)
            }
        }
    }

    public func searchWithAppleMaps(address: String) {
        if self.canNavigateWith(provider: .appleMaps) {
            let formattedAddress: String = address.replacingOccurrences(of: " ", with: "+")

            guard let url = URL(string: "\(NavigationProvider.appleMaps.urlScheme)?q=\(formattedAddress)") else {
                return
            }

            if #available(iOS 10.0, *) {
                self.open(url, options: [:], completionHandler: nil)
            } else {
                self.openURL(url)
            }
        }
    }
}
