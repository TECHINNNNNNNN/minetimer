import Foundation

// Plain, file-friendly shape of a task. Used for JSON export/import.
struct TaskRecord: Codable, Equatable {
    var id: UUID
    var title: String
    var notes: String
    var isDone: Bool
    var priority: Int
    var dueDate: Date?
    var tags: [String]
    var project: String?
    var pomodoros: Int
    var estimate: Int
    var repeatRule: String?
    var parentID: UUID?
    var isRoutine: Bool?
    var era: String?
    var order: Int
    var createdAt: Date
    var completedAt: Date?

    init(_ item: TodoItem) {
        id = item.id
        title = item.title
        notes = item.notes
        isDone = item.isDone
        priority = item.priority
        dueDate = item.dueDate
        tags = item.tags
        project = item.project
        pomodoros = item.pomodoros
        estimate = item.estimate
        repeatRule = item.repeatRaw
        parentID = item.parentID
        isRoutine = item.isRoutine
        era = item.era
        order = item.order
        createdAt = item.createdAt
        completedAt = item.completedAt
    }
}
