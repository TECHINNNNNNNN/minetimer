enum PomodoroDots {
    static func text(done: Int, estimate: Int, max: Int = 8) -> String {
        let filled = min(done, max)
        let empty = Swift.max(0, min(estimate, max) - filled)
        return String(repeating: "●", count: filled) + String(repeating: "○", count: empty)
    }
}
