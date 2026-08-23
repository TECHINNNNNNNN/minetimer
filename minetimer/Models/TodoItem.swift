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
    var repeatRaw: String? = nil
    var order: Int
    var createdAt: Date
    var completedAt: Date?

    var repeatRule: RepeatRule? {
        get { repeatRaw.flatMap(RepeatRule.init(raw:)) }
        set { repeatRaw = newValue?.raw }
    }

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
        self.repeatRaw = parsed.repeatRule?.raw
        self.order = order
        self.createdAt = .now
        self.completedAt = parsed.isDone ? .now : nil
    }

    init(nextOf item: TodoItem, dueDate: Date) {
        self.id = UUID()
        self.title = item.title
        self.notes = item.notes
        self.isDone = false
        self.priority = item.priority
        self.dueDate = dueDate
        self.tags = item.tags
        self.project = item.project
        self.pomodoros = 0
        self.estimate = item.estimate
        self.repeatRaw = item.repeatRaw
        self.order = item.order
        self.createdAt = .now
        self.completedAt = nil
    }
}
