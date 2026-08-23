import Testing
@testable import minetimer

struct ReorderTests {
    @Test func moveDown() {
        #expect(Reorder.move(["a", "b", "c", "d"], moving: "a", onto: "c") == ["b", "c", "a", "d"])
    }

    @Test func moveUp() {
        #expect(Reorder.move(["a", "b", "c", "d"], moving: "d", onto: "b") == ["a", "d", "b", "c"])
    }

    @Test func sameOrUnknownIsNoop() {
        #expect(Reorder.move(["a", "b"], moving: "a", onto: "a") == ["a", "b"])
        #expect(Reorder.move(["a", "b"], moving: "z", onto: "a") == ["a", "b"])
    }
}
