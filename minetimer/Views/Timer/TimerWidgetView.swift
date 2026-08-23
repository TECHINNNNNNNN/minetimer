import SwiftUI

// A poster card: portrait on top, readout below.
struct TimerWidgetView: View {
    @State private var engine = TimerEngine.shared
    @State private var hovering = false
    @State private var showStats = false

    var body: some View {
        VStack(spacing: 0) {
            CharacterView(isRunning: engine.isRunning, isBreak: engine.phase.isBreak, pixel: 5)
                .padding(.top, 22)
                .padding(.bottom, 14)
            TimerDisc(engine: engine)
                .padding(.horizontal, 18)
            HStack {
                Button { showStats.toggle() } label: {
                    GoalDots(done: engine.completedToday, goal: engine.dailyGoal)
                        .padding(.vertical, 8)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .popover(isPresented: $showStats, arrowEdge: .bottom) {
                    StatsCard(engine: engine).modelContainer(Persistence.container)
                }
                Spacer()
                controls.opacity(hovering ? 1 : 0)
            }
            .padding(.horizontal, 18)
            .padding(.top, 8)
            .padding(.bottom, 12)
        }
        .frame(width: 210)
        .background { ZStack { Theme.paper; Grain() } }
        .overlay(Rectangle().stroke(Theme.paperLine, lineWidth: 1))
        .padding(10)
        .onHover { hovering = $0 }
        .contextMenu { TimerMenu(engine: engine) }
    }

    private var controls: some View {
        HStack(spacing: 12) {
            Button { engine.restart() } label: { Image(systemName: "arrow.counterclockwise") }
            Button { engine.skip() } label: { Image(systemName: "forward.end") }
            Button { showStats.toggle() } label: { Image(systemName: "chart.bar") }
        }
        .buttonStyle(.plain)
        .font(.system(size: 10, weight: .medium))
        .foregroundStyle(Theme.mist)
    }
}
