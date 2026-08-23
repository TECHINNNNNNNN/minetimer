import Foundation
import Testing
@testable import minetimer

struct TodayFilterTests {
    let cal = Calendar(identifier: .gregorian)
    func day(_ d: Int, hour: Int = 0) -> Date {
        cal.date(from: DateComponents(year: 2026, month: 8, day: d, hour: hour))!
    }

    @Test func undatedIsToday() {
        #expect(TodayFilter.isToday(dueDate: nil, now: day(23), calendar: cal) == true)
    }

    @Test func dueTodayAndOverdueAreToday() {
        #expect(TodayFilter.isToday(dueDate: day(23, hour: 23), now: day(23, hour: 1), calendar: cal) == true)
        #expect(TodayFilter.isToday(dueDate: day(20), now: day(23), calendar: cal) == true)
    }

    @Test func tomorrowIsNot() {
        #expect(TodayFilter.isToday(dueDate: day(24), now: day(23, hour: 23), calendar: cal) == false)
    }
}
