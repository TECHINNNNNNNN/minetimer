import Testing
@testable import minetimer

struct NextPhaseTests {
    @Test func breakAlwaysGoesBackToWork() {
        #expect(NextPhase.after(.shortBreak, completedWorkSessions: 3, longBreakEvery: 4) == .work)
        #expect(NextPhase.after(.longBreak, completedWorkSessions: 4, longBreakEvery: 4) == .work)
    }

    @Test func shortBreakUntilCycleCompletes() {
        #expect(NextPhase.after(.work, completedWorkSessions: 1, longBreakEvery: 4) == .shortBreak)
        #expect(NextPhase.after(.work, completedWorkSessions: 3, longBreakEvery: 4) == .shortBreak)
    }

    @Test func longBreakOnEveryNth() {
        #expect(NextPhase.after(.work, completedWorkSessions: 4, longBreakEvery: 4) == .longBreak)
        #expect(NextPhase.after(.work, completedWorkSessions: 8, longBreakEvery: 4) == .longBreak)
    }

    @Test func zeroEveryDoesNotCrash() {
        #expect(NextPhase.after(.work, completedWorkSessions: 2, longBreakEvery: 0) == .longBreak)
    }
}
