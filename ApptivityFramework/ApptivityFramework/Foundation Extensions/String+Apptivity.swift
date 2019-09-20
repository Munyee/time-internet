//
//  String+Apptivity.swift
//  ApptivityFramework
//
//  Created by Aarief on 24/11/2016.
//
//

import Foundation

public extension String {

    public var intValue: Int? {
        return Int(self)
    }

    public var isEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }

    public var isPhone: Bool {
        let mobileRegex = "^[+]?\\d{7,}$"
        return NSPredicate(format: "SELF MATCHES %@", mobileRegex).evaluate(with: self.withoutWhitespace())
    }

    public func isSafePassword(ofLength length: Int) -> Bool {
        guard self.lengthOfBytes(using: String.Encoding.utf8) >= length else {
            return false
        }
        
        let passwordRegex = "^(?=.*[0-9\\W])(?=.*[a-zA-Z\\W])([a-zA-Z0-9\\W]+)$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }

    public var nameInitials: String {
        let components: [String] = self.components(separatedBy: " ").filter({ !$0.withoutWhitespace().replacingOccurrences(of: "\\W", with: "", options: String.CompareOptions.regularExpression, range: $0.startIndex ..< $0.endIndex).isEmpty }).map({ $0.withoutWhitespace().replacingOccurrences(of: "\\W", with: "", options: String.CompareOptions.regularExpression, range: $0.startIndex ..< $0.endIndex) })
        if components.count > 2 {
            return [components.first ?? "", components.last ?? ""].map({ $0.substring(to: 1).uppercased() }).joined(separator: "")
        }
        return components.map({ $0.substring(to: 1).uppercased() }).joined(separator: "")
    }

    public var excerpt: String {
        let withoutNewlines: String = self.replacingOccurrences(of: "\\n", with: " ", options: String.CompareOptions.regularExpression, range: self.startIndex ..< self.endIndex)
        return withoutNewlines.components(separatedBy: " ")
            .filter({ !$0.withoutWhitespace().isEmpty })
            .joined(separator: " ")
    }

    public func withoutWhitespace() -> String {
        let input: String = try! NSRegularExpression(pattern: "\\s", options: NSRegularExpression.Options.caseInsensitive).stringByReplacingMatches(in: self, options: [], range: NSMakeRange(0, (self as NSString).length), withTemplate: "")
        return input
    }

    public func alphaNumeric() -> String {
        let allowedChars : Set<Character> =
            Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890")
        return String(self.filter {allowedChars.contains($0) })
    }
    
    public init(randomWithLength length: Int, allowedCharacters: String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789") {
        let allowedCharsCount: UInt32 = UInt32(allowedCharacters.count)
        var randomString: String = ""

        for _ in 0 ..< length {
            let randomNum: Int = Int(arc4random_uniform(allowedCharsCount))
            let randomIndex: String.Index = allowedCharacters.index(allowedCharacters.startIndex, offsetBy: randomNum)
            let newCharacter = allowedCharacters[randomIndex]
            randomString += String(newCharacter)
        }

        self = randomString
    }

    public func firstPrefixCharacter(_ string: String, minCharacter: Int, seperatedBy component: String = " ") -> String {
        let stringArr: [String] = string.components(separatedBy: component)
        var characterPrefix: String = ""
        for index in 0...min(stringArr.count - 1, minCharacter) {
            if let character: Character = stringArr[index].first {
                characterPrefix.append(character)
            }
        }
        return characterPrefix
    }

    private func index(from: Int) -> Index {
        return self.index(self.startIndex, offsetBy: from)
    }

    func substring(to: Int) -> String {
        return String(prefix(to))
    }

    func substring(from: Int) -> String {
        let index = self.index(from: from)
        return String(self[index...])
    }

    func substring(with range: Range<Int>) -> String {
        let startIndex = self.index(from: range.lowerBound)
        let endIndex = self.index(from: range.upperBound)
        return String(self[startIndex ..< endIndex])
    }

    func height(constrainedToWidth width: CGFloat, using font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        return ceil(boundingBox.height)
    }
}

public extension String {

    internal static let dateFormatter: DateFormatter = DateFormatter()

    public func date(withFormat format: String, timeZone: TimeZone = TimeZone.current, locale: Locale? = Locale.current) -> Date? {
        String.dateFormatter.dateFormat = format
        String.dateFormatter.timeZone = timeZone
        String.dateFormatter.locale = locale
        return String.dateFormatter.date(from: self)
    }

    public func date(withTimeZone timeZone: TimeZone, format: String) -> Date? {
        return self.date(withFormat: format, timeZone: timeZone, locale: Locale(identifier: "en_US_POSIX"))
    }
    
    public func dateWithGMTTimeZone(format: String) -> Date? {
        if let timeZone = TimeZone(abbreviation: "GMT") {
            return self.date(withFormat: format, timeZone: timeZone, locale: Locale(identifier: "en_US_POSIX"))
        }
        return nil
    }
}

// MARK: - Attributed Strings
public extension String {
    public func attributedTextFromHTML(withFont font: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)) -> NSAttributedString? {
        let htmlString: String = String(format: "<html><head><style>body { font-family: \"%@\", sans-serif; font-size: %.0fpx } </style></head><body>%@</body></html>", font.fontName, font.pointSize, self)
        do {
            if let htmlData = htmlString.data(using: String.Encoding.utf8) {
                let attributedString = try NSAttributedString(data: htmlData, options: [.documentType : (Any).self], documentAttributes: nil)
                return attributedString
            }
        } catch {
            debugPrint("Failed to convert HTML string to NSAttributedString: \(error)")
        }

        return nil
    }

    func highlight(_ text: String, withColor highlightColor: UIColor, ignoreCase: Bool? = true, attributes: [NSAttributedStringKey: Any]? = [:]) -> NSMutableAttributedString {
        let fullText: String = (ignoreCase ?? true) ? self.lowercased() : self
        let matchingText: String = (ignoreCase ?? true) ? text.lowercased() : text
        let matchingTextWordRange: NSRange = (fullText as NSString).range(of: matchingText)
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: self, attributes: attributes)
        attributedString.addAttributes([NSAttributedStringKey.foregroundColor: highlightColor], range: matchingTextWordRange)
        return attributedString
    }
}

// MARK: - Barcode Image
public extension String {

    public func QRImage(withScale scale: CGFloat) -> UIImage? {
        if let stringData = self.data(using: String.Encoding.isoLatin1) {
            return stringData.QRImage(withScale: scale)
        }

        return nil
    }

    public func barcodeImage(withScale scale: CGFloat, type: BarcodeType = .code128) -> UIImage? {
        if let stringData = self.data(using: String.Encoding.isoLatin1) {
            return stringData.barcodeImage(withScale: scale, filterName: type.filterName)
        }
        return nil
    }
}

public enum BarcodeType {
    case code128
    case qr

    var filterName: String {
        switch self {
        case .code128:
            return "CICode128BarcodeGenerator"
        case .qr:
            return "CIQRCodeGenerator"
        }
    }
}


