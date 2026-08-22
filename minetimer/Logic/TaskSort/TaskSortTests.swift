import Testing
@testable import minetimer

struct TaskSortTests {
    @Test func urgentFirstThenImportantThenManualOrder() {
        let items = [("a", 0, 1), ("b", 3, 5), ("c", 2, 4), ("d", 1, 2), ("e", 3, 3)]
        let out = TaskSort.sorted(items, priority: { $0.1 }, order: { $0.2 })
        #expect(out.map { $0.0 } == ["e", "b", "c", "a", "d"])
    }

    @Test func lowPriorityIsNotPinned() {
        let items = [("a", 1, 2), ("b", 0, 1)]
        let out = TaskSort.sorted(items, priority: { $0.1 }, order: { $0.2 })
        #expect(out.map { $0.0 } == ["b", "a"])
    }
}
