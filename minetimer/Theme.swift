import SwiftUI

enum Theme {
    static let ink       = Color(hex: 0x15120F)
    static let charcoal  = Color(hex: 0x231E1A)
    static let lacquer   = Color(hex: 0x9E2E27)
    static let lacquerDk = Color(hex: 0x6E1E19)
    static let gold      = Color(hex: 0xD9A441)
    static let goldDk    = Color(hex: 0x9C7122)
    static let paper     = Color(hex: 0xEFE4CC)
    static let paperLine = Color(hex: 0xD5C7A8)
    static let paperInk  = Color(hex: 0x2B2118)
    static let jade      = Color(hex: 0x3F8A4F)
    static let jadeDk    = Color(hex: 0x2A5F36)
    static let mist      = Color(hex: 0xB8AE9C)
    static let ember     = Color(hex: 0xE0633A)

    static func mono(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .monospaced)
    }
}

extension Color {
    init(hex: UInt32, alpha: Double = 1) {
        self.init(.sRGB,
                  red: Double((hex >> 16) & 0xFF) / 255,
                  green: Double((hex >> 8) & 0xFF) / 255,
                  blue: Double(hex & 0xFF) / 255,
                  opacity: alpha)
    }
}
