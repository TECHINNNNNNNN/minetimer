import Testing
@testable import minetimer

struct PomodoroDotsTests {
    @Test func twoOfThree() {
        #expect(PomodoroDots.text(done: 2, estimate: 3) == "●●○")
    }

    @Test func overEstimateShowsOnlyFilled() {
        #expect(PomodoroDots.text(done: 4, estimate: 2) == "●●●●")
    }

    @Test func noEstimate() {
        #expect(PomodoroDots.text(done: 1, estimate: 0) == "●")
    }

    @Test func cappedAtMax() {
        #expect(PomodoroDots.text(done: 20, estimate: 0, max: 8) == "●●●●●●●●")
    }
}
