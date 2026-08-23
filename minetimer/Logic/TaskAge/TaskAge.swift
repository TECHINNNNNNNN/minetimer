import Foundation

enum TaskAge {
    static func label(created: Date, now: Date, calendar: Calendar) -> String? {
        let days = calendar.dateComponents([.day], from: calendar.startOfDay(for: created),
                                           to: calendar.startOfDay(for: now)).day ?? 0
        return days > 0 ? "↩\(days)d" : nil
    }
}
