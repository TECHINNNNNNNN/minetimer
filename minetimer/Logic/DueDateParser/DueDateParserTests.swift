import Foundation
import Testing
@testable import minetimer

struct DueDateParserTests {
    let cal = Calendar(identifier: .gregorian)
    var saturday: Date { cal.date(from: DateComponents(year: 2026, month: 8, day: 22))! }
    func day(_ d: Int) -> Date { cal.date(from: DateComponents(year: 2026, month: 8, day: d))! }

    @Test func todayAndTomorrow() {
        #expect(DueDateParser.date(from: "today", now: saturday, calendar: cal) == day(22))
        #expect(DueDateParser.date(from: "tmr", now: saturday, calendar: cal) == day(23))
    }

    @Test func weekdayIsAlwaysInTheFuture() {
        #expect(DueDateParser.date(from: "mon", now: saturday, calendar: cal) == day(24))
        #expect(DueDateParser.date(from: "friday", now: saturday, calendar: cal) == day(28))
        #expect(DueDateParser.date(from: "sat", now: saturday, calendar: cal) == day(29))
    }

    @Test func isoDate() {
        let sept1 = cal.date(from: DateComponents(year: 2026, month: 9, day: 1))
        #expect(DueDateParser.date(from: "2026-09-01", now: saturday, calendar: cal) == sept1)
    }

    @Test func isoDateIsGregorianEvenOnBuddhistCalendar() {
        var buddhist = Calendar(identifier: .buddhist)
        buddhist.timeZone = cal.timeZone
        let sept1 = cal.date(from: DateComponents(year: 2026, month: 9, day: 1))
        #expect(DueDateParser.date(from: "2026-09-01", now: saturday, calendar: buddhist) == sept1)
    }

    @Test func garbageIsNil() {
        #expect(DueDateParser.date(from: "bob", now: saturday, calendar: cal) == nil)
    }
}
