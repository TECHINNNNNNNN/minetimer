import Testing
@testable import minetimer

struct NextTaskTests {
    // (name, open, topLevel)
    let items = [("done", false, true), ("child", true, false), ("a", true, true), ("b", true, true)]

    @Test func firstOpenTopLevel() {
        let out = NextTask.pick(items, isOpen: { $0.1 }, isTopLevel: { $0.2 }, excluding: { _ in false })
        #expect(out?.0 == "a")
    }

    @Test func skipsTheExcludedOne() {
        let out = NextTask.pick(items, isOpen: { $0.1 }, isTopLevel: { $0.2 }, excluding: { $0.0 == "a" })
        #expect(out?.0 == "b")
    }

    @Test func nothingLeft() {
        let out = NextTask.pick([("x", false, true)], isOpen: { $0.1 }, isTopLevel: { $0.2 }, excluding: { _ in false })
        #expect(out == nil)
    }
}
