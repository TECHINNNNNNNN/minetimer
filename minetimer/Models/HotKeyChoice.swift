import Carbon

enum HotKeyChoice: String, CaseIterable {
    case ctrlOptN, ctrlOptT, ctrlOptSpace, cmdShiftSpace, off

    var label: String {
        switch self {
        case .ctrlOptN: return "⌃⌥N"
        case .ctrlOptT: return "⌃⌥T"
        case .ctrlOptSpace: return "⌃⌥Space"
        case .cmdShiftSpace: return "⌘⇧Space"
        case .off: return "Off"
        }
    }

    var keyCode: UInt32? {
        switch self {
        case .ctrlOptN: return UInt32(kVK_ANSI_N)
        case .ctrlOptT: return UInt32(kVK_ANSI_T)
        case .ctrlOptSpace, .cmdShiftSpace: return UInt32(kVK_Space)
        case .off: return nil
        }
    }

    var modifiers: UInt32 {
        switch self {
        case .cmdShiftSpace: return UInt32(cmdKey | shiftKey)
        default: return UInt32(controlKey | optionKey)
        }
    }
}
