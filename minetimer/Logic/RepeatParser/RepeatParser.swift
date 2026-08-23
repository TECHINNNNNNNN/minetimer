// *daily, *weekdays, *mon ... *sun
enum RepeatParser {
    private static let weekdays = ["sun": 1, "mon": 2, "tue": 3, "wed": 4, "thu": 5, "fri": 6, "sat": 7]

    static func rule(from word: String) -> RepeatRule? {
        let w = word.lowercased()
        if w == "daily" || w == "day" || w == "everyday" { return .daily }
        if w == "weekdays" || w == "weekday" { return .weekdays }
        if w.count >= 3, let d = weekdays[String(w.prefix(3))] { return .weekly(weekday: d) }
        return nil
    }
}
