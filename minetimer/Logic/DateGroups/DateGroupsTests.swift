import Foundation
import Testing
@testable import minetimer

struct DateGroupsTests {
    let cal = Calendar(identifier: .gregorian)
    func day(_ d: Int, hour: Int = 0) -> Date {
        cal.date(from: DateComponents(year: 2026, month: 8, day: d, hour: hour))!
    }

    @Test func groupsByDayAscending() {
        let items = [("a", day(25)), ("b", day(24, hour: 9)), ("c", day(24, hour: 18))]
        let out = DateGroups.sections(items, date: { $0.1 }, calendar: cal, ascending: true) { "\(cal.component(.day, from: $0))" }
        #expect(out.map(\.title) == ["24", "25"])
        #expect(out[0].items.map(\.0) == ["b", "c"])
    }

    @Test func descendingSkipsNilDates() {
        let items = [("a", day(22) as Date?), ("b", nil), ("c", day(23))]
        let out = DateGroups.sections(items, date: { $0.1 }, calendar: cal, ascending: false) { "\(cal.component(.day, from: $0))" }
        #expect(out.map(\.title) == ["23", "22"])
    }
}
