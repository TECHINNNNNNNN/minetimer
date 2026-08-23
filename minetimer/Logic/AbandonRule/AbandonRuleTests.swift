import Testing
@testable import minetimer

struct AbandonRuleTests {
    @Test func quittingFocusAfterAMinuteCounts() {
        #expect(AbandonRule.isAbandon(phase: .work, elapsed: 60) == true)
        #expect(AbandonRule.isAbandon(phase: .work, elapsed: 900) == true)
    }

    @Test func earlyQuitIsFree() {
        #expect(AbandonRule.isAbandon(phase: .work, elapsed: 59) == false)
    }

    @Test func breaksAreFree() {
        #expect(AbandonRule.isAbandon(phase: .shortBreak, elapsed: 600) == false)
        #expect(AbandonRule.isAbandon(phase: .longBreak, elapsed: 600) == false)
    }
}
