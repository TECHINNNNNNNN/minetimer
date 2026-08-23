import Foundation
import Testing
@testable import minetimer

struct MarkdownExportTests {
    let cal = Calendar(identifier: .gregorian)

    func record(_ title: String, id: UUID, parent: UUID? = nil, done: Bool = false, tags: [String] = [],
                due: Date? = nil, priority: Int = 0) -> TaskRecord {
        var r = TaskRecord(TodoItem(ParsedTask(title: title), order: 0))
        r.id = id
        r.parentID = parent
        r.isDone = done
        r.tags = tags
        r.dueDate = due
        r.priority = priority
        return r
    }

    @Test func parentThenIndentedChild() {
        let a = UUID(), b = UUID()
        let due = cal.date(from: DateComponents(year: 2026, month: 9, day: 1))
        let text = MarkdownExport.text([
            record("plan talk", id: a, tags: ["work"], due: due, priority: 2),
            record("slides", id: b, parent: a, done: true),
        ], calendar: cal)
        #expect(text == "- [ ] plan talk #work !! @2026-09-01\n  - [x] slides\n")
    }

    @Test func emptyIsEmpty() {
        #expect(MarkdownExport.text([], calendar: cal) == "")
    }
}
