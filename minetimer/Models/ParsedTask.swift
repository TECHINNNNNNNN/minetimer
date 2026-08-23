import Foundation

struct ParsedTask: Equatable {
    var title: String
    var priority: Int = 0
    var dueDate: Date? = nil
    var tags: [String] = []
    var project: String? = nil
    var estimate: Int = 0
    var isDone: Bool = false
    var repeatRule: RepeatRule? = nil
    var isChild: Bool = false
    var isRoutine: Bool = false
}
