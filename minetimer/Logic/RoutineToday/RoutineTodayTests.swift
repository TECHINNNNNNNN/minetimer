import Foundation
import Testing
@testable import minetimer

struct RoutineTodayTests {
    let cal = Calendar(identifier: .gregorian)
    let a = UUID(), b = UUID()
    func day(_ d: Int) -> Date { cal.date(from: DateComponents(year: 2026, month: 8, day: d))! }

    @Test func doneTodayAndStreaks() {
        let logs = [(itemID: a, day: day(22)), (itemID: a, day: day(23)), (itemID: b, day: day(21))]
        let s = RoutineToday.state(logs: logs, now: day(23), calendar: cal)
        #expect(s.doneToday == [a])
        #expect(s.streaks[a] == 2)
        #expect(s.streaks[b] == 0)
    }

    @Test func emptyLog() {
        let s = RoutineToday.state(logs: [], now: day(23), calendar: cal)
        #expect(s.doneToday.isEmpty)
        #expect(s.streaks.isEmpty)
    }
}
