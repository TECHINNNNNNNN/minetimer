import Foundation

enum ClockFormat {
    static func mmss(_ seconds: TimeInterval) -> String {
        let s = max(0, Int(seconds.rounded(.up)))
        return String(format: "%02d:%02d", s / 60, s % 60)
    }

    static func minutesLeft(_ seconds: TimeInterval) -> Int {
        max(0, Int((seconds / 60).rounded(.up)))
    }
}
