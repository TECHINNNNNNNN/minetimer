import Foundation
import Testing
@testable import minetimer

struct TaskRecordTests {
    @Test func jsonRoundTrip() throws {
        var r = TaskRecord(TodoItem(ParsedTask(title: "write readme", priority: 2, tags: ["docs"], estimate: 3), order: 7))
        r.dueDate = Date(timeIntervalSince1970: 1_800_000_000)
        r.repeatRule = "weekly:2"
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let back = try decoder.decode(TaskRecord.self, from: try encoder.encode(r))
        #expect(back.title == "write readme")
        #expect(back.priority == 2)
        #expect(back.tags == ["docs"])
        #expect(back.estimate == 3)
        #expect(back.order == 7)
        #expect(back.repeatRule == "weekly:2")
        #expect(back.dueDate == Date(timeIntervalSince1970: 1_800_000_000))
        #expect(back.id == r.id)
    }
}
