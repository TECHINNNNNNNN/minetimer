import Foundation

// What the paper needs to know about the routine today.
struct RoutineState {
    var doneToday: Set<UUID> = []
    var streaks: [UUID: Int] = [:]
}
