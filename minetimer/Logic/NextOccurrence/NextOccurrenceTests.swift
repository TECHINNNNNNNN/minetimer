import Foundation
import Testing
@testable import minetimer

struct NextOccurrenceTests {
    let cal = Calendar(identifier: .gregorian)
    func day(_ d: Int) -> Date { cal.date(from: DateComponents(year: 2026, month: 8, day: d))! }

    @Test func dailyIsTomorrow() {
        #expect(NextOccurrence.date(after: day(22), rule: .daily, calendar: cal) == day(23))
    }

    @Test func weekdaysSkipTheWeekend() {
        #expect(NextOccurrence.date(after: day(21), rule: .weekdays, calendar: cal) == day(24))
        #expect(NextOccurrence.date(after: day(24), rule: .weekdays, calendar: cal) == day(25))
    }

    @Test func weeklySameDayGoesAWeekAhead() {
        #expect(NextOccurrence.date(after: day(22), rule: .weekly(weekday: 7), calendar: cal) == day(29))
        #expect(NextOccurrence.date(after: day(22), rule: .weekly(weekday: 2), calendar: cal) == day(24))
    }
}
