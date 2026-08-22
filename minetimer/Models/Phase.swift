enum Phase: String, CaseIterable {
    case work, shortBreak, longBreak

    var label: String {
        switch self {
        case .work: return "FOCUS"
        case .shortBreak: return "BREAK"
        case .longBreak: return "LONG BREAK"
        }
    }

    var isBreak: Bool { self != .work }
}
