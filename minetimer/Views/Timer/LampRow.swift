import SwiftUI

// The seven-star lamps. Lit when a session is finished; guttered when one was abandoned.
struct LampRow: View {
    let states: [LampState]

    var body: some View {
        HStack(spacing: 8) {
            ForEach(Array(states.enumerated()), id: \.offset) { _, s in
                Lamp(state: s)
            }
        }
    }
}

struct Lamp: View {
    let state: LampState

    var body: some View {
        VStack(spacing: 1) {
            Ellipse()
                .fill(flame)
                .frame(width: 5, height: state == .unlit ? 3 : 8)
                .shadow(color: state == .lit ? Theme.lacquer.opacity(0.8) : .clear, radius: 4)
            RoundedRectangle(cornerRadius: 1)
                .fill(state == .unlit ? Theme.bronzeLt : Theme.paper)
                .frame(width: 10, height: 4)
        }
        .frame(height: 13, alignment: .bottom)
        .animation(.easeOut(duration: 0.5), value: state)
    }

    private var flame: Color {
        switch state {
        case .lit: return Theme.lacquer
        case .guttered: return Theme.creamDim.opacity(0.5)
        case .unlit: return .clear
        }
    }
}
