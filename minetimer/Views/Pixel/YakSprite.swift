import SwiftUI

// Yak (ยักษ์): Thai temple guardian. Green face, gold chada crown, fangs, red robe.
enum YakSprite {
    static let palette: [Character: Color] = [
        "K": Color(hex: 0x120F0D),
        "G": Theme.jade,
        "g": Theme.jadeDk,
        "Y": Theme.gold,
        "y": Theme.goldDk,
        "W": Color(hex: 0xF4EFE3),
        "B": Color(hex: 0x0A0A0A),
        "R": Theme.lacquer,
        "r": Theme.lacquerDk,
        "E": Theme.ember,
    ]

    static func frame(_ face: YakFace) -> [String] {
        crown + faceRows(face) + body
    }

    private static func faceRows(_ face: YakFace) -> [String] {
        switch face {
        case .open: return faceOpen
        case .blink: return faceBlink
        case .focus: return faceFocus
        }
    }

    private static let crown = [
        "..........Y...........",
        ".........YYY..........",
        ".........YyY..........",
        "........YYYYY.........",
        ".......YyYYYyY........",
        "......YYYYYYYYY.......",
        ".....YyYYyYYyYY.......",
        "....YYYYYYYYYYYY......",
        "...KYYYYYYYYYYYYK.....",
    ]

    private static let faceOpen = [
        "..KGGGGGGGGGGGGGGK....",
        ".KGGKKKGGGGGGKKKGGK...",
        ".KGGWWWGGGGGGWWWGGK...",
        ".KGGWBBWGGGGWBBWGGK...",
        ".KGGWBBWGGGGWBBWGGK...",
        ".KGGGWWGGGGGGWWGGGK...",
        ".KGGGGGGGggGGGGGGGK...",
        ".KGGGGGGGGGGGGGGGGK...",
        ".KGGGKKKKKKKKKKGGGK...",
        ".KGGKRRRRRRRRRRKGGK...",
        ".KGGKRWRRRRRRWRKGGK...",
        ".KGGKRWRRRRRRWRKGGK...",
        ".KGGGKKKKKKKKKKGGGK...",
        "..KGGGGGGGGGGGGGGK....",
        "...KKGGGGGGGGGGKK.....",
    ]

    private static let faceBlink = [
        "..KGGGGGGGGGGGGGGK....",
        ".KGGKKKGGGGGGKKKGGK...",
        ".KGGGGGGGGGGGGGGGGK...",
        ".KGGKKKKGGGGKKKKGGK...",
        ".KGGGGGGGGGGGGGGGGK...",
        ".KGGGGGGGGGGGGGGGGK...",
        ".KGGGGGGGggGGGGGGGK...",
        ".KGGGGGGGGGGGGGGGGK...",
        ".KGGGKKKKKKKKKKGGGK...",
        ".KGGKRRRRRRRRRRKGGK...",
        ".KGGKRWRRRRRRWRKGGK...",
        ".KGGKRWRRRRRRWRKGGK...",
        ".KGGGKKKKKKKKKKGGGK...",
        "..KGGGGGGGGGGGGGGK....",
        "...KKGGGGGGGGGGKK.....",
    ]

    private static let faceFocus = [
        "..KGGGGGGGGGGGGGGK....",
        ".KGGKKKGGGGGGKKKGGK...",
        ".KGGEEEGGGGGGEEEGGK...",
        ".KGGEBBEGGGGEBBEGGK...",
        ".KGGEBBEGGGGEBBEGGK...",
        ".KGGGEEGGGGGGEEGGGK...",
        ".KGGGGGGGggGGGGGGGK...",
        ".KGGGGGGGGGGGGGGGGK...",
        ".KGGGKKKKKKKKKKGGGK...",
        ".KGGKRRRRRRRRRRKGGK...",
        ".KGGKRWRRRRRRWRKGGK...",
        ".KGGKRWRRRRRRWRKGGK...",
        ".KGGGKKKKKKKKKKGGGK...",
        "..KGGGGGGGGGGGGGGK....",
        "...KKGGGGGGGGGGKK.....",
    ]

    private static let body = [
        ".....KGGGGGGGGGGK.....",
        "....KYYYYYYYYYYYYK....",
        "...KRRRYYYYYYYYRRRK...",
        "...KRRRRYYyyYYRRRRK...",
        "...KrRRRRYYYYRRRRrK...",
        "...KKKKKKKKKKKKKKKK...",
    ]
}
