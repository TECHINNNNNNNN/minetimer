import SwiftUI

struct GoalDots: View {
    let done: Int
    let goal: Int

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<max(goal, 1), id: \.self) { i in
                Rectangle()
                    .fill(i < done ? Theme.paperInk : Theme.paperLine)
                    .frame(width: 8, height: 3)
            }
            if done > goal {
                Text("+\(done - goal)")
                    .font(Theme.mono(8, weight: .bold))
                    .foregroundStyle(Theme.paperInk)
            }
        }
    }
}
