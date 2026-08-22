import Foundation
import SwiftData

@Model
final class TodoItem {
    var id: UUID
    var title: String
    var notes: String
    var isDone: Bool
    var priority: Int
    var dueDate: Date?
    var tags: [String]
    var project: String?
    var pomodoros: Int
    var estimate: Int = 0
    var order: Int
    var createdAt: Date
    var completedAt: Date?

    init(_ parsed: ParsedTask, order: Int) {
        self.id = UUID()
        self.title = parsed.title
        self.notes = ""
        self.isDone = parsed.isDone
        self.priority = parsed.priority
        self.dueDate = parsed.dueDate
        self.tags = parsed.tags
        self.project = parsed.project
        self.pomodoros = 0
        self.estimate = parsed.estimate
        self.order = order
        self.createdAt = .now
        self.completedAt = parsed.isDone ? .now : nil
    }
}
