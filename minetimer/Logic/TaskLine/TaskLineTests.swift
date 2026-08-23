import Foundation
import Testing
@testable import minetimer

struct TaskLineTests {
    let cal = Calendar(identifier: .gregorian)

    @Test func fullLine() {
        let due = cal.date(from: DateComponents(year: 2026, month: 9, day: 1))!
        let line = TaskLine.format(title: "write readme", priority: 2, dueDate: due, tags: ["docs"],
                                   project: "web", estimate: 3, repeatRule: .weekly(weekday: 2), calendar: cal)
        #expect(line == "write readme #docs +web !! @2026-09-01 ~3 *mon")
    }

    @Test func bareTitle() {
        let line = TaskLine.format(title: "buy milk", priority: 0, dueDate: nil, tags: [],
                                   project: nil, estimate: 0, repeatRule: nil, calendar: cal)
        #expect(line == "buy milk")
    }
}
