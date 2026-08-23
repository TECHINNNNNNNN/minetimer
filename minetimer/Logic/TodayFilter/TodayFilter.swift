import Foundation

// Today = open tasks that are due today, overdue, or have no date at all.
enum TodayFilter {
    static func isToday(dueDate: Date?, now: Date, calendar: Calendar) -> Bool {
        guard let dueDate else { return true }
        return calendar.startOfDay(for: dueDate) <= calendar.startOfDay(for: now)
    }
}
