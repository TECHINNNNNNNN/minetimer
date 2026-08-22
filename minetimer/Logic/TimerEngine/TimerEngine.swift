import Foundation
import SwiftData
import Observation

@Observable
@MainActor
final class TimerEngine {
    static let shared = TimerEngine()

    private(set) var phase: Phase = .work
    private(set) var isRunning = false
    private(set) var remaining: TimeInterval = 0
    private(set) var total: TimeInterval = 0
    private(set) var completedToday = 0
    private(set) var completedThisCycle = 0
    var activeTask: TodoItem?

    private var endDate: Date?
    private var sessionStart: Date?
    private var ticker: Timer?
    private let defaults = UserDefaults.standard
    private let daily = DailyCount()
    private let context = ModelContext(Persistence.container)

    private init() {
        completedToday = daily.load()
        reset(to: .work)
    }

    var dailyGoal: Int { defaults.integer(forKey: SettingsKey.dailyGoal) }
    var goalProgress: Double { min(1, Double(completedToday) / Double(max(1, dailyGoal))) }
    var progress: Double { total > 0 ? 1 - remaining / total : 0 }
    var clock: String { ClockFormat.mmss(remaining) }
    var minutesLeft: Int { ClockFormat.minutesLeft(remaining) }

    func duration(for phase: Phase) -> TimeInterval {
        let key: String
        switch phase {
        case .work: key = SettingsKey.workMinutes
        case .shortBreak: key = SettingsKey.shortBreakMinutes
        case .longBreak: key = SettingsKey.longBreakMinutes
        }
        return TimeInterval(max(1, defaults.integer(forKey: key)) * 60)
    }

    func toggle() { isRunning ? pause() : start() }

    func start() {
        guard !isRunning else { return }
        if sessionStart == nil { sessionStart = .now }
        endDate = Date().addingTimeInterval(remaining)
        isRunning = true
        ticker?.invalidate()
        let t = Timer(timeInterval: 0.25, repeats: true) { [weak self] _ in
            Task { @MainActor in self?.tick() }
        }
        RunLoop.main.add(t, forMode: .common)
        ticker = t
        SoundPlayer.shared.play(.start)
    }

    func pause() {
        guard isRunning else { return }
        isRunning = false
        ticker?.invalidate()
        ticker = nil
        if let endDate { remaining = max(0, endDate.timeIntervalSinceNow) }
        endDate = nil
        SoundPlayer.shared.play(.pause)
    }

    func restart() {
        pause()
        sessionStart = nil
        reset(to: phase)
    }

    func skip() {
        pause()
        sessionStart = nil
        advance(completed: false)
    }

    func jump(to phase: Phase) {
        pause()
        sessionStart = nil
        reset(to: phase)
    }

    func refreshDurations() {
        guard !isRunning, remaining == total else { return }
        reset(to: phase)
    }

    private func reset(to p: Phase) {
        phase = p
        total = duration(for: p)
        remaining = total
    }

    private func tick() {
        guard isRunning, let endDate else { return }
        let r = endDate.timeIntervalSinceNow
        guard r > 0 else {
            remaining = 0
            isRunning = false
            ticker?.invalidate()
            ticker = nil
            self.endDate = nil
            advance(completed: true)
            return
        }
        if defaults.bool(forKey: SettingsKey.tickSound), Int(remaining) != Int(r) {
            SoundPlayer.shared.play(.tick)
        }
        remaining = r
    }

    private func advance(completed: Bool) {
        let finished = phase
        if finished == .work, completed { recordWorkSession() }

        let next = NextPhase.after(finished,
                                   completedWorkSessions: completedThisCycle,
                                   longBreakEvery: defaults.integer(forKey: SettingsKey.longBreakEvery))
        reset(to: next)
        sessionStart = nil
        guard completed else { return }

        SoundPlayer.shared.play(finished == .work ? .workDone : .breakDone)
        Notifier.phaseEnded(finished, next: next, completedToday: completedToday,
                            goal: dailyGoal, taskTitle: activeTask?.title)

        let autoKey = next.isBreak ? SettingsKey.autoStartBreaks : SettingsKey.autoStartWork
        if defaults.bool(forKey: autoKey) { start() }
    }

    private func recordWorkSession() {
        completedThisCycle += 1
        completedToday += 1
        daily.save(completedToday)
        activeTask?.pomodoros += 1
        context.insert(FocusSession(start: sessionStart ?? Date().addingTimeInterval(-total),
                                    duration: total,
                                    taskTitle: activeTask?.title,
                                    taskID: activeTask?.id))
        try? context.save()
    }
}
