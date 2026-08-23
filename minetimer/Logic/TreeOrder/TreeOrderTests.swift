import Testing
@testable import minetimer

struct TreeOrderTests {
    @Test func childrenFollowParents() {
        let items: [(String, String?)] = [("a", nil), ("b", nil), ("a1", "a"), ("b1", "b"), ("a2", "a")]
        let out = TreeOrder.flatten(items, id: { $0.0 }, parent: { $0.1 })
        #expect(out.map { $0.item.0 } == ["a", "a1", "a2", "b", "b1"])
        #expect(out.map(\.depth) == [0, 1, 1, 0, 1])
    }

    @Test func missingParentBecomesTopLevel() {
        let items: [(String, String?)] = [("x", "gone"), ("y", nil)]
        let out = TreeOrder.flatten(items, id: { $0.0 }, parent: { $0.1 })
        #expect(out.map { $0.item.0 } == ["x", "y"])
        #expect(out.map(\.depth) == [0, 0])
    }
}
