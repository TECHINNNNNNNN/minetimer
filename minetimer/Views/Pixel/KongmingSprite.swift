import SwiftUI

// Zhuge Liang (孔明): scholar's cap, calm eyes, goatee, crane-feather fan. Long dark coat, one gold chain.
enum KongmingSprite {
    // Monochrome, like a grainy print. Four grays, one red for focus.
    static let palette: [Character: Color] = [
        "K": Color(hex: 0x0A0A0A),
        "H": Color(hex: 0x3A3835),
        "h": Color(hex: 0x2A2826),
        "S": Color(hex: 0xB9B2A6),
        "s": Color(hex: 0x8F887D),
        "W": Color(hex: 0xB9B2A6),
        "B": Color(hex: 0x0A0A0A),
        "E": Theme.lacquer,
        "C": Color(hex: 0x1C1B19),
        "c": Color(hex: 0x262523),
        "G": Color(hex: 0xE6E1D7),
        "F": Color(hex: 0xDAD4C8),
        "f": Color(hex: 0xA39C90),
        "R": Color(hex: 0x4A4540),
    ]

    static func frame(_ face: SpriteFace) -> [String] {
        let body = cap + faceRows(face) + coat
        return zip(body, fan).map { $0 + $1 }
    }

    private static func faceRows(_ face: SpriteFace) -> [String] {
        switch face {
        case .open: return faceOpen
        case .blink: return faceBlink
        case .focus: return faceFocus
        }
    }

    private static let cap = [
        "........KKKKKK........",
        ".......KHHHHHHK.......",
        "......KHHhHHhHHK......",
        "......KHHHHHHHHK......",
        ".....KHHhHHHHhHHK.....",
        ".....KHHHHHHHHHHK.....",
        "....KhhhhhhhhhhhhK....",
        "....KHHHHHHHHHHHHK....",
    ]

    private static let faceOpen = [
        "....KSSSSSSSSSSSSK....",
        "...KSSSSSSSSSSSSSSK...",
        "...KSSKKSSSSSSKKSSK...",
        "...KSSKBKSSSSKBKSSK...",
        "...KSSSSSSSSSSSSSSK...",
        "...KSSSSSSssSSSSSSK...",
        "...KSSSSSSSSSSSSSSK...",
        "...KSSSSKKKKKKSSSSK...",
        "....KSSSSSKKSSSSSK....",
        ".....KSSSSKKSSSSK.....",
        "......KKKKKKKKKK......",
        ".........KKKK.........",
    ]

    private static let faceBlink = [
        "....KSSSSSSSSSSSSK....",
        "...KSSSSSSSSSSSSSSK...",
        "...KSSKKSSSSSSKKSSK...",
        "...KSSKKKSSSSKKKSSK...",
        "...KSSSSSSSSSSSSSSK...",
        "...KSSSSSSssSSSSSSK...",
        "...KSSSSSSSSSSSSSSK...",
        "...KSSSSKKKKKKSSSSK...",
        "....KSSSSSKKSSSSSK....",
        ".....KSSSSKKSSSSK.....",
        "......KKKKKKKKKK......",
        ".........KKKK.........",
    ]

    private static let faceFocus = [
        "....KSSSSSSSSSSSSK....",
        "...KSSSSSSSSSSSSSSK...",
        "...KSKKKSSSSSSKKKSK...",
        "...KSSKEKSSSSKEKSSK...",
        "...KSSSSSSSSSSSSSSK...",
        "...KSSSSSSssSSSSSSK...",
        "...KSSSSSSSSSSSSSSK...",
        "...KSSSSKKKKKKSSSSK...",
        "....KSSSSSKKSSSSSK....",
        ".....KSSSSKKSSSSK.....",
        "......KKKKKKKKKK......",
        ".........KKKK.........",
    ]

    private static let coat = [
        ".......KSSSSSSK.......",
        ".....KCCKSSSSKCCK.....",
        "....KCCCCKSSKCCCCKCCK.",
        "...KCCCCCGGGGCCCCCKCK.",
        "..KCCCCCGCCCCGCCCCCK..",
        "..KCCCCCCCGGCCCCCCCK..",
        "..KCcCCCCCCCCCCCCcCK..",
        "..KCcCCCCCCCCCCCCcCK..",
        "..KKKKKKKKKKKKKKKKKK..",
    ]

    private static let fan = [
        "....", "....", "....", "....", "....", "....",
        "..FF", ".FFF",
        ".FfF", "FFFF", "FfFF", "FFFF", ".FfF", ".FFF", "..FF",
        "..R.", "..R.", "..R.", "..R.", "..R.",
        "..R.", ".SRS", ".SSS", ".KKK",
        "....", "....", "....", "....", "....",
    ]
}
