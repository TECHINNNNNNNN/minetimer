import Foundation

struct ParsedTask: Equatable {
    var title: String
    var priority: Int = 0
    var dueDate: Date? = nil
    var tags: [String] = []
    var project: String? = nil
}
