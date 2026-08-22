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
    var order: Int
    var createdAt: Date
    var completedAt: Date?

    init(title: String,
         priority: Int = 0,
         dueDate: Date? = nil,
         tags: [String] = [],
         project: String? = nil,
         order: Int = 0) {
        self.id = UUID()
        self.title = title
        self.notes = ""
        self.isDone = false
        self.priority = priority
        self.dueDate = dueDate
        self.tags = tags
        self.project = project
        self.pomodoros = 0
        self.order = order
        self.createdAt = .now
        self.completedAt = nil
    }
}
