enum NextPhase {
    static func after(_ phase: Phase, completedWorkSessions: Int, longBreakEvery: Int) -> Phase {
        guard phase == .work else { return .work }
        let every = max(1, longBreakEvery)
        return completedWorkSessions > 0 && completedWorkSessions % every == 0 ? .longBreak : .shortBreak
    }
}
