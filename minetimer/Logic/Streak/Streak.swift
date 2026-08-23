import Foundation

// Days in a row with at least one pomodoro. Today doesn't break the streak if it's still empty.
enum Streak {
    static func days(sessions: [Date], now: Date, calendar: Calendar) -> Int {
        let worked = Set(sessions.map { calendar.startOfDay(for: $0) })
        var day = calendar.startOfDay(for: now)
        var streak = 0
        if !worked.contains(day) { day = calendar.date(byAdding: .day, value: -1, to: day)! }
        while worked.contains(day) {
            streak += 1
            day = calendar.date(byAdding: .day, value: -1, to: day)!
        }
        return streak
    }
}
