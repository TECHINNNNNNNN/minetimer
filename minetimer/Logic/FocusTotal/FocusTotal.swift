import Foundation

enum FocusTotal {
    static func text(seconds: TimeInterval) -> String {
        let m = Int(seconds / 60)
        return m < 60 ? "\(m)m" : m % 60 == 0 ? "\(m / 60)h" : "\(m / 60)h \(m % 60)m"
    }
}
