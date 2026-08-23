import Foundation

// Done tasks stay on the paper until the day ends, then live in history.
enum DoneVisibility {
    static func isOnPaper(completedAt: Date?, now: Date, calendar: Calendar) -> Bool {
        guard let completedAt else { return false }
        return calendar.isDate(completedAt, inSameDayAs: now)
    }
}
