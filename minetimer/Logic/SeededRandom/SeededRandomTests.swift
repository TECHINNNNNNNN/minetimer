import Testing
@testable import minetimer

struct SeededRandomTests {
    @Test func sameSeedSameSequence() {
        var a = SeededRandom(seed: 42)
        var b = SeededRandom(seed: 42)
        #expect(a.next() == b.next())
        #expect(a.next() == b.next())
        #expect(a.next() == b.next())
    }

    @Test func differentSeedDifferentValue() {
        var a = SeededRandom(seed: 1)
        var b = SeededRandom(seed: 2)
        #expect(a.next() != b.next())
    }

    @Test func unitValueIsBetweenMinusOneAndOne() {
        var r = SeededRandom(seed: 1)
        let v = r.nextUnit()
        #expect(v >= -1)
        #expect(v <= 1)
    }
}
