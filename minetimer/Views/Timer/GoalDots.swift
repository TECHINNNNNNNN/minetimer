import SwiftUI

struct GoalDots: View {
    let done: Int
    let goal: Int

    var body: some View {
        HStack(spacing: 3) {
            ForEach(0..<max(goal, 1), id: \.self) { i in
                RoundedRectangle(cornerRadius: 1)
                    .fill(i < done ? Theme.gold : Theme.charcoal)
                    .frame(width: 6, height: 6)
            }
            if done > goal {
                Text("+\(done - goal)")
                    .font(Theme.mono(8, weight: .bold))
                    .foregroundStyle(Theme.gold)
            }
        }
    }
}
