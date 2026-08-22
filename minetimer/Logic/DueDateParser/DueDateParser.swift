import Foundation

// today, tomorrow, mon..sun, or 2026-08-30
enum DueDateParser {
    private static let weekdays = ["sun": 1, "mon": 2, "tue": 3, "wed": 4, "thu": 5, "fri": 6, "sat": 7]

    static func date(from word: String, now: Date, calendar: Calendar) -> Date? {
        let w = word.lowercased()
        let today = calendar.startOfDay(for: now)

        if w == "today" || w == "tod" { return today }
        if w == "tomorrow" || w == "tmr" || w == "tom" { return calendar.date(byAdding: .day, value: 1, to: today) }

        if let target = weekdays[String(w.prefix(3))], w.count >= 3 {
            let current = calendar.component(.weekday, from: today)
            var delta = (target - current + 7) % 7
            if delta == 0 { delta = 7 }
            return calendar.date(byAdding: .day, value: delta, to: today)
        }

        let f = DateFormatter()
        f.calendar = calendar
        f.dateFormat = "yyyy-MM-dd"
        return f.date(from: w)
    }
}
