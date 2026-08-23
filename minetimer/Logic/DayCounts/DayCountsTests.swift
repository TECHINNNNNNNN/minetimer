import Foundation
import Testing
@testable import minetimer

struct DayCountsTests {
    let cal = Calendar(identifier: .gregorian)
    func day(_ d: Int, hour: Int = 0) -> Date {
        cal.date(from: DateComponents(year: 2026, month: 8, day: d, hour: hour))!
    }

    @Test func sevenDaysOldestFirst() {
        let sessions = [day(23, hour: 9), day(23, hour: 10), day(21, hour: 8), day(10)]
        let out = DayCounts.lastDays(7, sessions: sessions, now: day(23, hour: 20), calendar: cal)
        #expect(out.map(\.count) == [0, 0, 0, 0, 1, 0, 2])
        #expect(out.first?.day == day(17))
        #expect(out.last?.day == day(23))
    }
}
