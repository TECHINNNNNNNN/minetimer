import SwiftUI

// Zhuge Liang (孔明): scholar's cap, calm eyes, goatee, crane-feather fan. Long dark coat, one gold chain.
enum KongmingSprite {
    static let palette: [Character: Color] = [
        "K": Theme.edge,
        "H": Theme.indigo,
        "h": Color(hex: 0x1C273D),
        "S": Color(hex: 0xE6C59C),
        "s": Color(hex: 0xC9A67C),
        "W": Color(hex: 0xF2EEE4),
        "B": Color(hex: 0x0A0A0A),
        "E": Theme.ember,
        "C": Color(hex: 0x1A1718),
        "c": Color(hex: 0x2A2527),
        "G": Theme.gold,
        "F": Color(hex: 0xECE4D2),
        "f": Color(hex: 0xC6BBA4),
        "R": Theme.lacquerDk,
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
        "...KSSWBWSSSSWBWSSK...",
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
        "...KSSEBESSSSEBESSK...",
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
