import Foundation
import Testing
@testable import minetimer

struct TaskParserTests {
    let cal = Calendar(identifier: .gregorian)
    var now: Date { cal.date(from: DateComponents(year: 2026, month: 8, day: 22))! }

    @Test func plainTitle() {
        #expect(TaskParser.parse("write the readme", now: now, calendar: cal) == ParsedTask(title: "write the readme"))
    }

    @Test func extractsEverything() {
        let p = TaskParser.parse("fix login #backend #auth !!! @tomorrow +minetimer", now: now, calendar: cal)
        #expect(p.title == "fix login")
        #expect(p.tags == ["backend", "auth"])
        #expect(p.priority == 3)
        #expect(p.project == "minetimer")
        #expect(p.dueDate == cal.date(from: DateComponents(year: 2026, month: 8, day: 23)))
    }

    @Test func estimateAndChecklistPrefix() {
        let p = TaskParser.parse("- [x] ship it ~3", now: now, calendar: cal)
        #expect(p.title == "ship it")
        #expect(p.estimate == 3)
        #expect(p.isDone == true)
    }

    @Test func repeatRule() {
        let p = TaskParser.parse("standup *weekdays", now: now, calendar: cal)
        #expect(p.title == "standup")
        #expect(p.repeatRule == .weekdays)
    }

    @Test func subtaskPrefix() {
        let p = TaskParser.parse("> write tests", now: now, calendar: cal)
        #expect(p.title == "write tests")
        #expect(p.isChild == true)
        #expect(TaskParser.parse("  - indented", now: now, calendar: cal).isChild == true)
        #expect(TaskParser.parse("top", now: now, calendar: cal).isChild == false)
    }

    @Test func numericPriority() {
        #expect(TaskParser.parse("a !2", now: now, calendar: cal).priority == 2)
        #expect(TaskParser.parse("a !9", now: now, calendar: cal).title == "a !9")
    }

    @Test func unknownAtWordStaysInTitle() {
        #expect(TaskParser.parse("email @bob", now: now, calendar: cal).title == "email @bob")
    }
}
