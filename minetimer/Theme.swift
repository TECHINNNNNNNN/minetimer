import SwiftUI

// Cream paper, ink black, one orange-red. Nothing else.
enum Theme {
    static let ink       = Color(hex: 0x141210)
    static let charcoal  = Color(hex: 0x1E1B18)
    static let paper     = Color(hex: 0xEFE6D2)
    static let paperLine = Color(hex: 0xD6CBB3)
    static let paperInk  = Color(hex: 0x141210)
    static let mist      = Color(hex: 0x6B6357)
    static let gold      = Color(hex: 0xE8431F)
    static let goldDk    = Color(hex: 0xB42E12)
    static let lacquer   = Color(hex: 0xE8431F)
    static let lacquerDk = Color(hex: 0xB42E12)
    static let ember     = Color(hex: 0xE8431F)
    static let jade      = Color(hex: 0xDCD1B8)
    static let jadeDk    = Color(hex: 0xB9AD93)
    static let bronze    = Color(hex: 0x2A2623)
    static let bronzeLt  = Color(hex: 0x3A3531)
    static let indigo    = Color(hex: 0x2A2623)
    static let edge      = Color(hex: 0x141210)
    static let creamDim  = Color(hex: 0x9A9183)

    static func priority(_ p: Int) -> Color {
        switch p {
        case 3: return lacquer
        case 2: return paperInk
        case 1: return paperLine
        default: return .clear
        }
    }

    static func mono(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .monospaced)
    }

    static func display(_ size: CGFloat, weight: Font.Weight = .bold) -> Font {
        .system(size: size, weight: weight, design: .default).width(.condensed)
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
