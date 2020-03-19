//
//  Date+Apptivity.swift
//  ApptivityFramework
//
//  Created by Li Theen on 16/11/2016.
//  Copyright © 2016 Apptivity Lab. All rights reserved.
//

import Foundation

public extension Date {

    public func isToday() -> Bool {
        let today: Date = Date()

        let dateComponents: DateComponents = NSCalendar.current.dateComponents([.year, .month, .day], from: self)
        let todayComponents: DateComponents = NSCalendar.current.dateComponents([.year, .month, .day], from: today)
        if dateComponents.year! == todayComponents.year! &&
            dateComponents.month! == todayComponents.month! &&
            dateComponents.day! == todayComponents.day! {
            return true
        }

        return false
    }

    public func relativeDateString(usingTimeZone timeZone: TimeZone = TimeZone.current, localeIdentifier: String = Locale.current.identifier, dateStyle: DateFormatter.Style = .short, timeStyle: DateFormatter.Style = .short) -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.locale = Locale(identifier: localeIdentifier)

        dateFormatter.doesRelativeDateFormatting = true
        dateFormatter.dateStyle = dateStyle
        dateFormatter.timeStyle = timeStyle

        return dateFormatter.string(from: self)
    }

    public func string(usingFormat format: String, usingTimeZone timeZone: TimeZone = TimeZone.current, localeIdentifier: String = Locale.current.identifier) -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = timeZone
        dateFormatter.locale = Locale(identifier: localeIdentifier)
        return dateFormatter.string(from: self)
    }
}

public extension Date {
    public func humanizedDuration(to anotherDate: Date, preferAbbreviated: Bool = false, fallbackFormat: String = "d MMM yyyy") -> String {
        let componentsUpToMonths: DateComponents = Calendar.current.dateComponents(
            [.month],
            from: self,
            to: anotherDate
        )

        guard let months = componentsUpToMonths.month, months < 12 else {
            return self.string(usingFormat: fallbackFormat)
        }

        if months > 0 {
            let unit: String = preferAbbreviated ? NSLocalizedString("mth", comment: "") : (months > 1 ? NSLocalizedString("months", comment: "") : NSLocalizedString("month", comment: ""))
            return preferAbbreviated ? "\(months)\(unit)" : "\(months) \(unit)"
        }

        let componentsUpToDays: DateComponents = Calendar.current.dateComponents(
            [.day, .hour, .minute],
            from: self,
            to: anotherDate
        )

        if let days = componentsUpToDays.day, days > 0 {
            let unit: String = preferAbbreviated ? NSLocalizedString("d", comment: "") : (days > 1 ? NSLocalizedString("days", comment: "") : NSLocalizedString("day", comment: ""))
            return preferAbbreviated ? "\(days)\(unit)" : "\(days) \(unit)"
        }

        var displayComponents: [String] = []

        if componentsUpToDays.hour ?? 0 > 0 {
            let unit: String = preferAbbreviated ? NSLocalizedString("h", comment: "") : (componentsUpToDays.hour ?? 0 > 1 ? NSLocalizedString("hours", comment: "") : NSLocalizedString("hour", comment: ""))
            displayComponents.append(preferAbbreviated ? "\(componentsUpToDays.hour ?? 0)\(unit)" : "\(componentsUpToDays.hour ?? 0) \(unit)")
        }
        if componentsUpToDays.minute ?? 0 > 0 {
            let unit: String = preferAbbreviated ? NSLocalizedString("m", comment: "") : (componentsUpToDays.minute ?? 0 > 1 ? NSLocalizedString("minutes", comment: "") : NSLocalizedString("minute", comment: ""))
            displayComponents.append(preferAbbreviated ? "\(componentsUpToDays.minute ?? 0)\(unit)" : "\(componentsUpToDays.minute ?? 0) \(unit)")
        }
        if displayComponents.isEmpty {
            displayComponents.append(preferAbbreviated ? "< 1m" : NSLocalizedString("< 1 minute", comment: ""))
        }

        return displayComponents.joined(separator: " ")
    }
}
