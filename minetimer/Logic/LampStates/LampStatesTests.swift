import Testing
@testable import minetimer

struct LampStatesTests {
    @Test func litThenGutteredThenUnlit() {
        #expect(LampStates.states(goal: 5, lit: 2, guttered: 1) == [.lit, .lit, .guttered, .unlit, .unlit])
    }

    @Test func growsPastGoal() {
        #expect(LampStates.states(goal: 2, lit: 3, guttered: 0) == [.lit, .lit, .lit])
    }

    @Test func nothingYet() {
        #expect(LampStates.states(goal: 3, lit: 0, guttered: 0) == [.unlit, .unlit, .unlit])
    }
}
