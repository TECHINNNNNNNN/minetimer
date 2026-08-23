import Foundation

// Walking out of a focus session after a real start costs a lamp. Breaks are free.
enum AbandonRule {
    static let grace: TimeInterval = 60

    static func isAbandon(phase: Phase, elapsed: TimeInterval) -> Bool {
        phase == .work && elapsed >= grace
    }
}
