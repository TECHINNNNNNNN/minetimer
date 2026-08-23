enum RepeatRule: Equatable {
    case daily
    case weekdays
    case weekly(weekday: Int)

    var raw: String {
        switch self {
        case .daily: return "daily"
        case .weekdays: return "weekdays"
        case .weekly(let d): return "weekly:\(d)"
        }
    }

    init?(raw: String) {
        switch raw {
        case "daily": self = .daily
        case "weekdays": self = .weekdays
        default:
            guard raw.hasPrefix("weekly:"), let d = Int(raw.dropFirst(7)), (1...7).contains(d) else { return nil }
            self = .weekly(weekday: d)
        }
    }
}
