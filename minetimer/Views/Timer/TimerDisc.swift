import SwiftUI

struct TimerDisc: View {
    var engine: TimerEngine

    var body: some View {
        ZStack {
            Circle().fill(Theme.ink)
            Circle()
                .stroke(Theme.charcoal, lineWidth: 5)
                .padding(3)
            Circle()
                .trim(from: 0, to: engine.progress)
                .stroke(engine.phase.isBreak ? Theme.jade : Theme.gold,
                        style: StrokeStyle(lineWidth: 5, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .padding(3)
                .animation(.linear(duration: 0.25), value: engine.progress)

            if let next = engine.suggestedTask {
                suggestion(next)
            } else {
                clock
            }
        }
        .contentShape(Circle())
        .onTapGesture { if engine.suggestedTask == nil { engine.toggle() } }
    }

    private var clock: some View {
        VStack(spacing: 1) {
            Text(engine.isRunning ? engine.clock : "\(engine.minutesLeft)")
                .font(Theme.mono(engine.isRunning ? 22 : 30, weight: .bold))
                .foregroundStyle(Theme.paper)
                .contentTransition(.numericText())
            Text(engine.isRunning ? engine.phase.label : "MIN")
                .font(Theme.mono(8, weight: .semibold))
                .foregroundStyle(Theme.mist)
            Text(engine.activeTask?.title ?? "(no task)")
                .font(Theme.mono(8))
                .foregroundStyle(Theme.mist.opacity(0.7))
                .lineLimit(1)
                .padding(.horizontal, 14)
            Text(engine.isRunning ? "⏸ PAUSE" : "▶ START")
                .font(Theme.mono(8, weight: .bold))
                .foregroundStyle(Theme.gold)
                .padding(.top, 2)
        }
    }

    private func suggestion(_ next: TodoItem) -> some View {
        VStack(spacing: 4) {
            Text("NEXT?")
                .font(Theme.mono(8, weight: .semibold))
                .foregroundStyle(Theme.mist)
            Text(next.title)
                .font(Theme.mono(10, weight: .bold))
                .foregroundStyle(Theme.paper)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 14)
            HStack(spacing: 12) {
                Button { engine.acceptSuggestion() } label: {
                    Text("▶ GO").font(Theme.mono(9, weight: .bold)).foregroundStyle(Theme.gold)
                }
                Button { engine.dismissSuggestion() } label: {
                    Text("✕").font(Theme.mono(9, weight: .bold)).foregroundStyle(Theme.mist)
                }
            }
            .buttonStyle(.plain)
            .padding(.top, 2)
        }
    }
}
