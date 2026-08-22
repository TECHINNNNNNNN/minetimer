import Foundation

// "fix login bug #backend !3 @tomorrow +minetimer"
enum TaskParser {
    static func parse(_ input: String, now: Date = .now, calendar: Calendar = .current) -> ParsedTask {
        var result = ParsedTask(title: "")
        var words: [String] = []

        for word in input.split(separator: " ").map(String.init) {
            if word.hasPrefix("#"), word.count > 1 {
                result.tags.append(String(word.dropFirst()).lowercased())
            } else if word.hasPrefix("+"), word.count > 1 {
                result.project = String(word.dropFirst())
            } else if let p = priority(from: word) {
                result.priority = p
            } else if word.hasPrefix("@"), let d = DueDateParser.date(from: String(word.dropFirst()), now: now, calendar: calendar) {
                result.dueDate = d
            } else {
                words.append(word)
            }
        }
        result.title = words.joined(separator: " ").trimmingCharacters(in: .whitespaces)
        return result
    }

    private static func priority(from word: String) -> Int? {
        if word == "!!!" { return 3 }
        if word == "!!" { return 2 }
        if word == "!" { return 1 }
        if word.hasPrefix("!"), word.count == 2, let n = Int(word.dropFirst()), (1...3).contains(n) { return n }
        return nil
    }
}
