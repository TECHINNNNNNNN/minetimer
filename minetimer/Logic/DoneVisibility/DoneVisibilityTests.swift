import Foundation
import Testing
@testable import minetimer

struct DoneVisibilityTests {
    let cal = Calendar(identifier: .gregorian)
    func day(_ d: Int, hour: Int = 0) -> Date {
        cal.date(from: DateComponents(year: 2026, month: 8, day: d, hour: hour))!
    }

    @Test func doneTodayStays() {
        #expect(DoneVisibility.isOnPaper(completedAt: day(23, hour: 9), now: day(23, hour: 20), calendar: cal) == true)
    }

    @Test func doneYesterdayLeaves() {
        #expect(DoneVisibility.isOnPaper(completedAt: day(22, hour: 23), now: day(23, hour: 0), calendar: cal) == false)
    }

    @Test func noDateIsHidden() {
        #expect(DoneVisibility.isOnPaper(completedAt: nil, now: day(23), calendar: cal) == false)
    }
}
