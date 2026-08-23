import Foundation
import Testing
@testable import minetimer

struct TaskAgeTests {
    let cal = Calendar(identifier: .gregorian)
    func day(_ d: Int, hour: Int = 0) -> Date {
        cal.date(from: DateComponents(year: 2026, month: 8, day: d, hour: hour))!
    }

    @Test func createdTodayHasNoLabel() {
        #expect(TaskAge.label(created: day(23, hour: 1), now: day(23, hour: 22), calendar: cal) == nil)
    }

    @Test func yesterdayLateNightStillCountsAsOneDay() {
        #expect(TaskAge.label(created: day(22, hour: 23), now: day(23, hour: 1), calendar: cal) == "↩1d")
    }

    @Test func olderTasks() {
        #expect(TaskAge.label(created: day(20), now: day(23), calendar: cal) == "↩3d")
    }
}
