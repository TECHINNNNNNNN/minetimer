import Foundation
import Testing
@testable import minetimer

struct SessionCountsTests {
    let cal = Calendar(identifier: .gregorian)
    func day(_ d: Int, _ h: Int = 0, _ m: Int = 0) -> Date {
        cal.date(from: DateComponents(year: 2026, month: 8, day: d, hour: h, minute: m))!
    }

    @Test func countsOnlyTodaysSessions() {
        let sessions = [(day(28, 9), 1500.0), (day(30, 22), 1500.0), (day(31, 7), 1500.0), (day(31, 8, 10), 3000.0)]
        let t = SessionCounts.today(sessions: sessions, now: day(31, 9), calendar: cal)
        #expect(t.count == 2)
        #expect(t.seconds == 4500)
    }

    @Test func emptyDayIsZero() {
        let t = SessionCounts.today(sessions: [(day(28, 9), 1500.0)], now: day(31, 9), calendar: cal)
        #expect(t.count == 0)
        #expect(t.seconds == 0)
    }

    @Test func countsLoadedThreeDaysAgoAreStale() {
        #expect(SessionCounts.isStale(loadedDay: day(28), now: day(31, 8, 47), calendar: cal) == true)
    }

    @Test func justAfterMidnightIsStale() {
        #expect(SessionCounts.isStale(loadedDay: day(30, 23, 59), now: day(31, 0, 0), calendar: cal) == true)
    }

    @Test func sameDayIsFresh() {
        #expect(SessionCounts.isStale(loadedDay: day(31, 0, 1), now: day(31, 23, 59), calendar: cal) == false)
    }
}
