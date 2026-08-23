import SwiftUI

// Drum pads. The struck one flashes orange.
struct KeyboardView: View {
    let pressed: Character?

    private let rows = ["1234567890", "QWERTYUIOP", "ASDFGHJKL", "ZXCVBNM,.?"]

    var body: some View {
        VStack(spacing: 5) {
            ForEach(rows, id: \.self) { row in
                HStack(spacing: 5) {
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
            .font(Theme.mono(8, weight: .semibold))
            .foregroundStyle(isPressed ? Theme.paper : Theme.mist)
            .frame(width: 30, height: 26)
            .background(isPressed ? Theme.lacquer : Theme.jade)
            .overlay(alignment: .bottom) {
                Rectangle().fill(isPressed ? Theme.lacquerDk : Theme.jadeDk).frame(height: 3)
            }
            .offset(y: isPressed ? 1 : 0)
            .animation(.easeOut(duration: 0.08), value: isPressed)
    }
}
