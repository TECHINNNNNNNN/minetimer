import AppKit

enum WindowMode: String, CaseIterable {
    case desktop, normal, alwaysOnTop

    var label: String {
        switch self {
        case .desktop: return "On desktop"
        case .normal: return "Normal window"
        case .alwaysOnTop: return "Always on top"
        }
    }

    var level: NSWindow.Level {
        switch self {
        case .desktop: return NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.desktopIconWindow)) + 1)
        case .normal: return .normal
        case .alwaysOnTop: return .floating
        }
    }
}
