import Foundation

// Today's numbers come from the session records themselves, never from a cached counter.
enum SessionCounts {
    static func today(sessions: [(start: Date, duration: TimeInterval)],
                      now: Date, calendar: Calendar) -> (count: Int, seconds: TimeInterval) {
        let dayStart = calendar.startOfDay(for: now)
        let todays = sessions.filter { $0.start >= dayStart && $0.start <= now }
        return (todays.count, todays.reduce(0) { $0 + $1.duration })
    }

    static func isStale(loadedDay: Date, now: Date, calendar: Calendar) -> Bool {
        !calendar.isDate(loadedDay, inSameDayAs: now)
    }
}
