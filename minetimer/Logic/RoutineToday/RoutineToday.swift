import Foundation

// Builds today's routine state from the log.
enum RoutineToday {
    static func state(logs: [(itemID: UUID, day: Date)], now: Date, calendar: Calendar) -> RoutineState {
        let today = calendar.startOfDay(for: now)
        var byItem: [UUID: Set<Date>] = [:]
        for log in logs { byItem[log.itemID, default: []].insert(calendar.startOfDay(for: log.day)) }
        var state = RoutineState()
        for (id, days) in byItem {
            if days.contains(today) { state.doneToday.insert(id) }
            state.streaks[id] = Streak.days(sessions: Array(days), now: now, calendar: calendar)
        }
        return state
    }
}
