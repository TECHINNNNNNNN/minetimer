import Foundation

enum DueLabel {
    static func text(for date: Date, now: Date = .now, calendar: Calendar = .current) -> String {
        let today = calendar.startOfDay(for: now)
        let days = calendar.dateComponents([.day], from: today, to: calendar.startOfDay(for: date)).day ?? 0
        switch days {
        case ..<0: return "\(-days)d late"
        case 0: return "today"
        case 1: return "tmr"
        case 2...6:
            let f = DateFormatter()
            f.dateFormat = "EEE"
            return f.string(from: date).lowercased()
        default:
            let f = DateFormatter()
            f.dateFormat = "d MMM"
            return f.string(from: date).lowercased()
        }
    }

    static func isOverdue(_ date: Date, now: Date = .now, calendar: Calendar = .current) -> Bool {
        calendar.startOfDay(for: date) < calendar.startOfDay(for: now)
    }
}
