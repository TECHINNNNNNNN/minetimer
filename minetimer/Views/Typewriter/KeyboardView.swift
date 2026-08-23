import SwiftUI

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

// Jade tiles on a lacquer board.
struct KeyCap: View {
    let label: String
    let isPressed: Bool

    var body: some View {
        Text(label)
            .font(Theme.mono(9, weight: .bold))
            .foregroundStyle(isPressed ? Theme.ink : Theme.paper)
            .frame(width: 27, height: 25)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(LinearGradient(colors: isPressed ? [Theme.gold, Theme.goldDk] : [Theme.jade, Theme.jadeDk],
                                         startPoint: .top, endPoint: .bottom)))
            .overlay(RoundedRectangle(cornerRadius: 4).stroke(Theme.edge, lineWidth: 1.5))
            .shadow(color: .black.opacity(isPressed ? 0 : 0.5), radius: 0, y: 2)
            .offset(y: isPressed ? 2 : 0)
            .animation(.easeOut(duration: 0.08), value: isPressed)
    }
}
