import SwiftUI

// The seven-star lamps. Each flame grows with its share of the goal.
struct LampRow: View {
    let fills: [Double]
    let lit: Int
    let goal: Int
    let out: Int

    var body: some View {
        VStack(spacing: 6) {
            HStack(spacing: 9) {
                ForEach(Array(fills.enumerated()), id: \.offset) { _, f in
                    Lamp(fill: f)
                }
            }
            HStack(spacing: 6) {
                Text("\(lit) / \(goal)")
                    .foregroundStyle(lit >= goal ? Theme.lacquer : Theme.creamDim)
                if out > 0 {
                    Text("· \(out) out").foregroundStyle(Theme.bronzeLt)
                }
            }
            .font(Theme.mono(8, weight: .medium))
            .tracking(1.5)
        }
    }
}

struct Lamp: View {
    let fill: Double

    var body: some View {
        VStack(spacing: 1) {
            Ellipse()
                .fill(Theme.lacquer)
                .frame(width: 5, height: 2 + 8 * fill)
                .opacity(fill > 0 ? 1 : 0)
                .shadow(color: Theme.lacquer.opacity(0.8 * fill), radius: 4)
            RoundedRectangle(cornerRadius: 1)
                .fill(fill > 0 ? Theme.paper : Theme.bronzeLt)
                .frame(width: 10, height: 4)
        }
        .frame(height: 15, alignment: .bottom)
        .animation(.easeOut(duration: 0.5), value: fill)
    }
}
