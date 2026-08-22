import Foundation
import SwiftData

@Model
final class FocusSession {
    var start: Date
    var duration: TimeInterval
    var taskTitle: String?
    var taskID: UUID?

    init(start: Date, duration: TimeInterval, taskTitle: String?, taskID: UUID?) {
        self.start = start
        self.duration = duration
        self.taskTitle = taskTitle
        self.taskID = taskID
    }
}
