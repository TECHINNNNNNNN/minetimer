enum PriorityLabel {
    static func mark(_ p: Int) -> String { String(repeating: "!", count: max(0, min(p, 3))) }

    static func name(_ p: Int) -> String {
        switch p {
        case 1: return "! low"
        case 2: return "!! medium"
        case 3: return "!!! high"
        default: return "none"
        }
    }
}
