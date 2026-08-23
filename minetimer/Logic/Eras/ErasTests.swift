import Testing
@testable import minetimer

struct ErasTests {
    @Test func normalizeTrimsAndLowercases() {
        #expect(Eras.normalize(" Exam Prep ") == "exam prep")
        #expect(Eras.normalize("") == nil)
    }

    @Test func listPutsDefaultFirstThenAlphabetical() {
        #expect(Eras.list(from: ["golden", nil, "exam", "golden"]) == ["daily", "exam", "golden"])
    }

    @Test func listAlwaysHasDefault() {
        #expect(Eras.list(from: []) == ["daily"])
    }
}
