import SwiftUI

// War room palette: blackened bronze, cinnabar, aged gold, bone, a little jade.
enum Theme {
    static let ink       = Color(hex: 0x0F0D0C)
    static let charcoal  = Color(hex: 0x1E1A17)
    static let bronze    = Color(hex: 0x4A3726)
    static let bronzeLt  = Color(hex: 0x7A5C3A)
    static let lacquer   = Color(hex: 0xA8321F)
    static let lacquerDk = Color(hex: 0x6E1E14)
    static let gold      = Color(hex: 0xC9973A)
    static let goldDk    = Color(hex: 0x8C6424)
    static let paper     = Color(hex: 0xE9E1CF)
    static let paperLine = Color(hex: 0xCDC2A8)
    static let paperInk  = Color(hex: 0x241C16)
    static let jade      = Color(hex: 0x5E8F6E)
    static let jadeDk    = Color(hex: 0x2F4F3A)
    static let mist      = Color(hex: 0x9A9184)
    static let ember     = Color(hex: 0xE0633A)
    static let indigo    = Color(hex: 0x2B3A5C)
    static let edge      = Color(hex: 0x0A0908)

    static func priority(_ p: Int) -> Color {
        switch p {
        case 3: return lacquer
        case 2: return gold
        case 1: return paperLine
        default: return .clear
        }
    }

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
