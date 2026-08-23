import SwiftUI

// Shows one line for a few seconds, then leaves.
struct MottoView: View {
    let text: String
    let trigger: Int
    @State private var visible = false

    var body: some View {
        Text(text)
            .font(.system(size: 15, weight: .medium, design: .serif))
            .tracking(6)
            .foregroundStyle(Theme.paper)
            .opacity(visible ? 1 : 0)
            .offset(y: visible ? 0 : 6)
            .onChange(of: trigger) { _, _ in
                withAnimation(.easeOut(duration: 0.8)) { visible = true }
                Task {
                    try? await Task.sleep(for: .seconds(3.2))
                    withAnimation(.easeIn(duration: 1.2)) { visible = false }
                }
            }
    }
}
