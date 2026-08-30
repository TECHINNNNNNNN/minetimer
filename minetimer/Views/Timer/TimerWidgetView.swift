import SwiftUI

// Kongming floats on the desktop; the incense and readout sit at his shoulder.
struct TimerWidgetView: View {
    @State private var engine = TimerEngine.shared
    @State private var hovering = false
    @State private var showStats = false

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            KongmingView(isRunning: engine.isRunning, isBreak: engine.phase.isBreak, startCount: engine.startCount)
            VStack(spacing: 6) {
                ZStack(alignment: .top) {
                    IncenseView(progress: engine.progress, isRunning: engine.isRunning && !engine.phase.isBreak, width: 130)
                    MottoView(text: "寧靜致遠", trigger: engine.startCount).padding(.top, 6)
                    MottoView(text: "鞠躬盡瘁", trigger: engine.finishCount).padding(.top, 6)
                }
                TimerDisc(engine: engine)
                    .frame(width: 190)
                Button { showStats.toggle() } label: {
                    LampRow(fills: LampStates.fills(goal: engine.dailyGoal, lit: engine.completedToday),
                            lit: engine.completedToday, goal: engine.dailyGoal, out: engine.abandonedToday,
                            hours: "\(FocusTotal.text(seconds: engine.focusedLive)) / \(FocusTotal.text(seconds: engine.goalSeconds))")
                        .padding(.vertical, 6)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .popover(isPresented: $showStats, arrowEdge: .bottom) {
                    StatsCard(engine: engine).modelContainer(Persistence.container)
                }
                controls.opacity(hovering ? 1 : 0)
            }
            .padding(.bottom, 10)
        }
        .padding(16)
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
        .font(.system(size: 10, weight: .medium))
        .foregroundStyle(Theme.creamDim)
    }
}
