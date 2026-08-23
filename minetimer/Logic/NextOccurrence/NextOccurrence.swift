import Foundation

enum NextOccurrence {
    static func date(after date: Date, rule: RepeatRule, calendar: Calendar) -> Date {
        let start = calendar.startOfDay(for: date)
        switch rule {
        case .daily:
            return calendar.date(byAdding: .day, value: 1, to: start)!
        case .weekdays:
            var next = start
            repeat {
                next = calendar.date(byAdding: .day, value: 1, to: next)!
            } while calendar.isDateInWeekend(next)
            return next
        case .weekly(let weekday):
            let current = calendar.component(.weekday, from: start)
            var delta = (weekday - current + 7) % 7
            if delta == 0 { delta = 7 }
            return calendar.date(byAdding: .day, value: delta, to: start)!
        }
    }
}
