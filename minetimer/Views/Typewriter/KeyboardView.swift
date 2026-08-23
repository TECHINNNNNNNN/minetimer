import SwiftUI

struct KeyboardView: View {
    let pressed: Character?

    private let rows = ["1234567890", "QWERTYUIOP", "ASDFGHJKL", "ZXCVBNM,.?"]

    var body: some View {
        VStack(spacing: 4) {
            ForEach(rows, id: \.self) { row in
                HStack(spacing: 4) {
                    ForEach(Array(row), id: \.self) { key in
                        KeyCap(label: String(key), isPressed: pressed == key)
                    }
                }
            }
        }
    }
}

// Flat black keys. A struck key inverts.
struct KeyCap: View {
    let label: String
    let isPressed: Bool

    var body: some View {
        Text(label)
            .font(Theme.mono(9, weight: .medium))
            .foregroundStyle(isPressed ? Theme.ink : Theme.mist)
            .frame(width: 28, height: 24)
            .background(Rectangle().fill(isPressed ? Theme.paperInk : Theme.jade))
            .overlay(Rectangle().stroke(Theme.paperLine, lineWidth: 1))
            .animation(.easeOut(duration: 0.06), value: isPressed)
    }
}
