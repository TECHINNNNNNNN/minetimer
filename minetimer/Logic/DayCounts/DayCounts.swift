import Foundation

// Pomodoros per day for the last `days` days, oldest first, today last.
enum DayCounts {
    static func lastDays(_ days: Int, sessions: [Date], now: Date, calendar: Calendar) -> [(day: Date, count: Int)] {
        let today = calendar.startOfDay(for: now)
        var counts: [Date: Int] = [:]
        for s in sessions { counts[calendar.startOfDay(for: s), default: 0] += 1 }
        return (0..<days).reversed().map { back in
            let day = calendar.date(byAdding: .day, value: -back, to: today)!
            return (day, counts[day] ?? 0)
        }
    }
}
