import Testing
@testable import minetimer

struct TopTasksTests {
    @Test func rankedByCountThenName() {
        let out = TopTasks.ranked(["b", "a", "b", nil, "c", "a"], limit: 3)
        #expect(out.map(\.title) == ["a", "b", "(no task)"])
        #expect(out.map(\.count) == [2, 2, 1])
    }
}
