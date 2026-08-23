import Testing
@testable import minetimer

struct GroupByTests {
    @Test func sortedSectionsThenOrphans() {
        let items = [("a", ["web"]), ("b", []), ("c", ["api", "web"]), ("d", [])]
        let out = GroupBy.sections(items, keys: { $0.1 }, title: { $0.uppercased() }, fallback: "—")
        #expect(out.map(\.title) == ["API", "WEB", "—"])
        #expect(out[0].items.map(\.0) == ["c"])
        #expect(out[1].items.map(\.0) == ["a", "c"])
        #expect(out[2].items.map(\.0) == ["b", "d"])
    }

    @Test func noOrphansNoFallback() {
        let out = GroupBy.sections([("a", ["x"])], keys: { $0.1 }, title: { $0 }, fallback: "—")
        #expect(out.map(\.title) == ["x"])
    }
}
