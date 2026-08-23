import SwiftUI

// Night desk: black surfaces, grain, off-white type, one red.
enum Theme {
    static let ink       = Color(hex: 0x0C0B0B)
    static let charcoal  = Color(hex: 0x161514)
    static let paper     = Color(hex: 0x171615)   // card surface
    static let paperLine = Color(hex: 0x2C2926)   // hairlines
    static let paperInk  = Color(hex: 0xE6E1D7)   // primary type
    static let mist      = Color(hex: 0x7C766D)   // secondary type
    static let gold      = Color(hex: 0xC9BBA0)   // warm light, used sparingly
    static let goldDk    = Color(hex: 0x8A8070)
    static let lacquer   = Color(hex: 0xC0301C)   // the one red
    static let lacquerDk = Color(hex: 0x7A1F12)
    static let ember     = Color(hex: 0xD9472F)
    static let jade      = Color(hex: 0x262422)   // key face
    static let jadeDk    = Color(hex: 0x1B1A18)
    static let bronze    = Color(hex: 0x2C2926)
    static let bronzeLt  = Color(hex: 0x3A3633)
    static let indigo    = Color(hex: 0x3A3835)
    static let edge      = Color(hex: 0x050505)

    static func priority(_ p: Int) -> Color {
        switch p {
        case 3: return lacquer
        case 2: return paperInk
        case 1: return mist
        default: return .clear
        }
    }

    static func mono(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .monospaced)
    }

    static func display(_ size: CGFloat, weight: Font.Weight = .light) -> Font {
        .system(size: size, weight: weight, design: .default)
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
