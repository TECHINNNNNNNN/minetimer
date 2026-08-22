import Foundation

// Turns "- [x] buy milk" into ("buy milk", done: true). Plain lines pass through.
enum ChecklistLine {
    static func strip(_ line: String) -> (text: String, isDone: Bool) {
        var s = line.trimmingCharacters(in: .whitespaces)
        for bullet in ["- ", "* ", "+ "] where s.hasPrefix(bullet) {
            s = String(s.dropFirst(2))
        }
        if let dot = s.firstIndex(of: "."), s[..<dot].allSatisfy(\.isNumber), !s[..<dot].isEmpty,
           s.index(after: dot) < s.endIndex, s[s.index(after: dot)] == " " {
            s = String(s[s.index(dot, offsetBy: 2)...])
        }
        var done = false
        if s.hasPrefix("[ ] ") {
            s = String(s.dropFirst(4))
        } else if s.lowercased().hasPrefix("[x] ") {
            s = String(s.dropFirst(4))
            done = true
        }
        return (s.trimmingCharacters(in: .whitespaces), done)
    }

    static func lines(from text: String) -> [String] {
        text.components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty && !$0.hasPrefix("#") }
    }
}
