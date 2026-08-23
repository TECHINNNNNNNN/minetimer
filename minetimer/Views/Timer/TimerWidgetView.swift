import SwiftUI

struct TimerWidgetView: View {
    @State private var engine = TimerEngine.shared
    @State private var hovering = false
    @State private var showStats = false

    var body: some View {
        VStack(spacing: 6) {
            ZStack(alignment: .bottom) {
                CharacterView(isRunning: engine.isRunning, isBreak: engine.phase.isBreak, pixel: 7)
                    .padding(.bottom, 122)
                TimerDisc(engine: engine)
                    .frame(width: 128, height: 128)
                    .shadow(color: .black.opacity(0.6), radius: 10, y: 6)
            }
            Button { showStats.toggle() } label: {
                GoalDots(done: engine.completedToday, goal: engine.dailyGoal)
                    .padding(.vertical, 6)
                    .contentShape(Rectangle())
            }
                .buttonStyle(.plain)
                .popover(isPresented: $showStats, arrowEdge: .bottom) {
                    StatsCard(engine: engine).modelContainer(Persistence.container)
                }
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
            Button { showStats.toggle() } label: { Image(systemName: "chart.bar") }
        }
        .buttonStyle(.plain)
        .font(.system(size: 11, weight: .bold))
        .foregroundStyle(Theme.mist)
    }
}
