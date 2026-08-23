import Testing
@testable import minetimer

struct LampStatesTests {
    @Test func goalOfSevenIsOneSessionPerLamp() {
        #expect(LampStates.fills(goal: 7, lit: 3) == [1, 1, 1, 0, 0, 0, 0])
    }

    @Test func bigGoalFillsLampsGradually() {
        #expect(LampStates.fills(goal: 28, lit: 6) == [1, 0.5, 0, 0, 0, 0, 0])
    }

    @Test func overGoalStaysFull() {
        #expect(LampStates.fills(goal: 7, lit: 9) == [1, 1, 1, 1, 1, 1, 1])
    }

    @Test func nothingYet() {
        #expect(LampStates.fills(goal: 28, lit: 0) == [0, 0, 0, 0, 0, 0, 0])
    }
}
