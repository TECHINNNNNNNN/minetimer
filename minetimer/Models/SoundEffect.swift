enum SoundEffect: Hashable {
    case key(variant: Int)
    case space
    case enter
    case start
    case pause
    case tick
    case workDone
    case breakDone

    var isTypewriter: Bool {
        switch self {
        case .key, .space, .enter: return true
        default: return false
        }
    }
}
