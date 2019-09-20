import Foundation

public protocol JsonRecord {
    init?(with json: [String : Any])
    func toJson() -> [String : Any]
}

public extension JsonRecord {
    func toJson() -> [String : Any] {
        return [:]
    }
}
