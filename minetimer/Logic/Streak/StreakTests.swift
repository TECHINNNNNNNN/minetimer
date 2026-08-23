import Foundation
import Testing
@testable import minetimer

struct StreakTests {
    let cal = Calendar(identifier: .gregorian)
    func day(_ d: Int) -> Date { cal.date(from: DateComponents(year: 2026, month: 8, day: d))! }

    @Test func countsBackFromToday() {
        #expect(Streak.days(sessions: [day(23), day(22), day(21), day(19)], now: day(23), calendar: cal) == 3)
    }

    @Test func emptyTodayStillCountsYesterday() {
        #expect(Streak.days(sessions: [day(22), day(21)], now: day(23), calendar: cal) == 2)
    }

    @Test func gapBreaksIt() {
        #expect(Streak.days(sessions: [day(20)], now: day(23), calendar: cal) == 0)
    }
}
