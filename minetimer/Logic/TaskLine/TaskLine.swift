import Foundation

// The opposite of TaskParser: turns a task back into one editable line.
enum TaskLine {
    static func format(title: String, priority: Int, dueDate: Date?, tags: [String], project: String?,
                       estimate: Int, repeatRule: RepeatRule?, calendar: Calendar) -> String {
        var parts = [title]
        parts += tags.map { "#" + $0 }
        if let project { parts.append("+" + project) }
        if priority > 0 { parts.append(PriorityLabel.mark(priority)) }
        if let dueDate {
            var gregorian = Calendar(identifier: .gregorian)
            gregorian.timeZone = calendar.timeZone
            let c = gregorian.dateComponents([.year, .month, .day], from: dueDate)
            parts.append(String(format: "@%04d-%02d-%02d", c.year!, c.month!, c.day!))
        }
        if estimate > 0 { parts.append("~\(estimate)") }
        if let repeatRule { parts.append("*" + repeatWord(repeatRule)) }
        return parts.joined(separator: " ")
    }

    private static func repeatWord(_ rule: RepeatRule) -> String {
        switch rule {
        case .daily: return "daily"
        case .weekdays: return "weekdays"
        case .weekly(let d): return ["sun", "mon", "tue", "wed", "thu", "fri", "sat"][d - 1]
        }
    }
}
