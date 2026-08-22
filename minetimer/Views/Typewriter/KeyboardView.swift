import SwiftUI

struct KeyboardView: View {
    let pressed: Character?

    private let rows = ["1234567890", "QWERTYUIOP", "ASDFGHJKL", "ZXCVBNM,.?"]

    var body: some View {
        VStack(spacing: 6) {
            ForEach(rows, id: \.self) { row in
                HStack(spacing: 6) {
                    ForEach(Array(row), id: \.self) { key in
                        KeyCap(label: String(key), isPressed: pressed == key)
                    }
                }
            }
        }
    }
}

struct KeyCap: View {
    let label: String
    let isPressed: Bool

    var body: some View {
        Text(label)
            .font(Theme.mono(9, weight: .bold))
            .foregroundStyle(Theme.paperInk)
            .frame(width: 26, height: 26)
            .background(Circle().fill(isPressed ? Theme.gold : Theme.paper))
            .overlay(Circle().stroke(Color(hex: 0x120F0D), lineWidth: 2))
            .offset(y: isPressed ? 2 : 0)
            .animation(.easeOut(duration: 0.08), value: isPressed)
    }
}
