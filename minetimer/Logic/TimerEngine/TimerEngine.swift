import AppKit
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
    private(set) var abandonedToday = 0
    private(set) var focusedToday: TimeInterval = 0
    private(set) var completedThisCycle = 0
    private(set) var startCount = 0
    private(set) var finishCount = 0
    var activeTask: TodoItem?
    var activeTrackNumber: Int?
    private(set) var suggestedTask: TodoItem?
    private(set) var askDone: TodoItem?

    private var endDate: Date?
    private var sessionStart: Date?
    private var ticker: Timer?
    private let defaults = UserDefaults.standard
    private let abandoned = DailyCount(prefix: "abandoned")
    private let context = ModelContext(Persistence.container)
    private var countsDay: Date = .distantPast

    private init() {
        reloadCounts()
        reset(to: .work)
        watchDayChange()
    }

    // Today's numbers are recomputed from the session records; a cached counter can never go stale.
    private func reloadCounts() {
        let sessions = (try? context.fetch(FetchDescriptor<FocusSession>())) ?? []
        let today = SessionCounts.today(sessions: sessions.map { ($0.start, $0.duration) },
                                        now: .now, calendar: .current)
        completedToday = today.count
        focusedToday = today.seconds
        abandonedToday = abandoned.load()
        countsDay = Calendar.current.startOfDay(for: .now)
    }

    private func rolloverIfNeeded() {
        guard SessionCounts.isStale(loadedDay: countsDay, now: .now, calendar: .current) else { return }
        reloadCounts()
        completedThisCycle = 0
    }

    // The day can change while we sleep, nap, or idle; listen to everything and double-check every minute.
    private func watchDayChange() {
        let nc = NotificationCenter.default
        nc.addObserver(forName: .NSCalendarDayChanged, object: nil, queue: .main) { [weak self] _ in
            Task { @MainActor in self?.rolloverIfNeeded() }
        }
        NSWorkspace.shared.notificationCenter.addObserver(forName: NSWorkspace.didWakeNotification,
                                                          object: nil, queue: .main) { [weak self] _ in
            Task { @MainActor in self?.rolloverIfNeeded() }
        }
        let t = Timer(timeInterval: 60, repeats: true) { [weak self] _ in
            Task { @MainActor in self?.rolloverIfNeeded() }
        }
        RunLoop.main.add(t, forMode: .common)
    }

    var dailyGoal: Int { defaults.integer(forKey: SettingsKey.dailyGoal) }
    var goalProgress: Double { min(1, Double(completedToday) / Double(max(1, dailyGoal))) }
    var progress: Double { total > 0 ? 1 - remaining / total : 0 }
    var clock: String { ClockFormat.mmss(remaining) }

    /// Hours focused today, counting the session that's burning right now.
    var focusedLive: TimeInterval {
        focusedToday + (isRunning && phase == .work ? total - remaining : 0)
    }

    var goalSeconds: TimeInterval { TimeInterval(dailyGoal) * duration(for: .work) }

    var elapsedClock: String { ClockFormat.mmss(total - remaining) }
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
        rolloverIfNeeded()
        suggestedTask = nil
        if sessionStart == nil { sessionStart = .now }
        endDate = Date().addingTimeInterval(remaining)
        isRunning = true
        ticker?.invalidate()
        let t = Timer(timeInterval: 0.25, repeats: true) { [weak self] _ in
            Task { @MainActor in self?.tick() }
        }
        RunLoop.main.add(t, forMode: .common)
        ticker = t
        startCount += 1
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
        recordAbandonIfNeeded()
        sessionStart = nil
        reset(to: phase)
    }

    func skip() {
        pause()
        recordAbandonIfNeeded()
        sessionStart = nil
        advance(completed: false)
    }

    func jump(to phase: Phase) {
        pause()
        recordAbandonIfNeeded()
        sessionStart = nil
        reset(to: phase)
    }

    private func recordAbandonIfNeeded() {
        guard AbandonRule.isAbandon(phase: phase, elapsed: total - remaining) else { return }
        abandonedToday += 1
        abandoned.save(abandonedToday)
    }

    /// The task being worked on was checked off. Offer the next one.
    func taskFinished(_ task: TodoItem) {
        askDone = nil
        guard activeTask?.id == task.id else { return }
        activeTask = nil
        activeTrackNumber = nil
        suggestedTask = topTask(excluding: task.id)
    }

    /// "Done with it?" after a track has played all its estimated sessions.
    func markAskedDone() {
        guard let t = askDone else { return }
        t.isDone = true
        t.completedAt = .now
        try? context.save()
        taskFinished(t)
    }

    func keepGoing() { askDone = nil }

    func acceptSuggestion() {
        guard let s = suggestedTask else { return }
        activeTask = s
        suggestedTask = nil
        if !isRunning { start() }
    }

    func dismissSuggestion() { suggestedTask = nil }

    private func topTask(excluding: UUID) -> TodoItem? {
        let all = (try? context.fetch(FetchDescriptor<TodoItem>(sortBy: [SortDescriptor(\.order)]))) ?? []
        let ordered = TaskSort.sorted(all, priority: \.priority, order: \.order)
        return NextTask.pick(ordered,
                             isOpen: { !$0.isDone && TodayFilter.isToday(dueDate: $0.dueDate, now: .now, calendar: .current) },
                             isTopLevel: { $0.parentID == nil },
                             excluding: { $0.id == excluding })
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
        rolloverIfNeeded()
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
        rolloverIfNeeded()
        completedThisCycle += 1
        completedToday += 1
        finishCount += 1
        activeTask?.pomodoros += 1
        if let t = activeTask, t.estimate > 0, t.pomodoros >= t.estimate { askDone = t }
        context.insert(FocusSession(start: sessionStart ?? Date().addingTimeInterval(-total),
                                    duration: total,
                                    taskTitle: activeTask?.title,
                                    taskID: activeTask?.id))
        try? context.save()
        focusedToday += total
    }
}
