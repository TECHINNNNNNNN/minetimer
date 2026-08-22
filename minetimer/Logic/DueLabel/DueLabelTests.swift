import Foundation
import Testing
@testable import minetimer

struct DueLabelTests {
    let cal = Calendar(identifier: .gregorian)
    var now: Date { cal.date(from: DateComponents(year: 2026, month: 8, day: 22, hour: 15))! }
    func day(_ d: Int) -> Date { cal.date(from: DateComponents(year: 2026, month: 8, day: d))! }

    @Test func labels() {
        #expect(DueLabel.text(for: day(22), now: now, calendar: cal) == "today")
        #expect(DueLabel.text(for: day(23), now: now, calendar: cal) == "tmr")
        #expect(DueLabel.text(for: day(25), now: now, calendar: cal) == "tue")
        #expect(DueLabel.text(for: day(20), now: now, calendar: cal) == "2d late")
    }

    @Test func overdue() {
        #expect(DueLabel.isOverdue(day(21), now: now, calendar: cal))
        #expect(!DueLabel.isOverdue(day(22), now: now, calendar: cal))
    }
}
