import SwiftUI

struct TimerWidgetView: View {
    @State private var engine = TimerEngine.shared
    @State private var hovering = false

    var body: some View {
        VStack(spacing: 6) {
            ZStack(alignment: .bottom) {
                YakView(isRunning: engine.isRunning, isBreak: engine.phase.isBreak, pixel: 7)
                    .padding(.bottom, 96)
                TimerDisc(engine: engine)
                    .frame(width: 120, height: 120)
                    .shadow(color: .black.opacity(0.5), radius: 8, y: 4)
            }
            GoalDots(done: engine.completedToday, goal: engine.dailyGoal)
            controls
                .opacity(hovering ? 1 : 0)
        }
        .padding(10)
        .onHover { hovering = $0 }
        .contextMenu { TimerMenu(engine: engine) }
    }

    private var controls: some View {
        HStack(spacing: 14) {
            Button { engine.restart() } label: { Image(systemName: "arrow.counterclockwise") }
            Button { engine.skip() } label: { Image(systemName: "forward.end") }
        }
        .buttonStyle(.plain)
        .font(.system(size: 11, weight: .bold))
        .foregroundStyle(Theme.mist)
    }
}
