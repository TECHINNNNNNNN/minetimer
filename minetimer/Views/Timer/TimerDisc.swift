import SwiftUI

// A bronze war drum. The ring burns down like incense.
struct TimerDisc: View {
    var engine: TimerEngine

    var body: some View {
        ZStack {
            Circle().fill(
                RadialGradient(colors: [Theme.bronzeLt, Theme.bronze, Theme.edge],
                               center: .center, startRadius: 30, endRadius: 64))
            studs
            Circle().fill(Theme.ink).padding(11)
            Circle().stroke(Theme.charcoal, lineWidth: 4).padding(13)
            Circle()
                .trim(from: 0, to: engine.progress)
                .stroke(AngularGradient(colors: [Theme.gold, Theme.ember, Theme.gold], center: .center),
                        style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .padding(13)
                .shadow(color: Theme.ember.opacity(0.8), radius: 4)
                .animation(.linear(duration: 0.25), value: engine.progress)

            if let next = engine.suggestedTask {
                suggestion(next)
            } else {
                clock
            }
        }
        .overlay(Circle().stroke(Theme.edge, lineWidth: 2))
        .contentShape(Circle())
        .onTapGesture { if engine.suggestedTask == nil { engine.toggle() } }
    }

    private var studs: some View {
        ForEach(0..<12, id: \.self) { i in
            Circle()
                .fill(Theme.gold.opacity(0.85))
                .frame(width: 4, height: 4)
                .offset(y: -54)
                .rotationEffect(.degrees(Double(i) * 30))
        }
    }

    private var clock: some View {
        VStack(spacing: 1) {
            Text(engine.isRunning ? engine.clock : "\(engine.minutesLeft)")
                .font(Theme.mono(engine.isRunning ? 20 : 28, weight: .bold))
                .foregroundStyle(Theme.paper)
                .contentTransition(.numericText())
            Text(engine.isRunning ? engine.phase.label : "MIN")
                .font(Theme.mono(7, weight: .semibold))
                .foregroundStyle(Theme.gold)
            Text(engine.activeTask?.title ?? "(no task)")
                .font(Theme.mono(7))
                .foregroundStyle(Theme.mist)
                .lineLimit(1)
                .padding(.horizontal, 22)
            Text(engine.isRunning ? "⏸ PAUSE" : "▶ START")
                .font(Theme.mono(7, weight: .bold))
                .foregroundStyle(Theme.paper.opacity(0.8))
                .padding(.top, 2)
        }
    }

    private func suggestion(_ next: TodoItem) -> some View {
        VStack(spacing: 4) {
            Text("NEXT?")
                .font(Theme.mono(7, weight: .semibold))
                .foregroundStyle(Theme.gold)
            Text(next.title)
                .font(Theme.mono(9, weight: .bold))
                .foregroundStyle(Theme.paper)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 22)
            HStack(spacing: 12) {
                Button { engine.acceptSuggestion() } label: {
                    Text("▶ GO").font(Theme.mono(8, weight: .bold)).foregroundStyle(Theme.gold)
                }
                Button { engine.dismissSuggestion() } label: {
                    Text("✕").font(Theme.mono(8, weight: .bold)).foregroundStyle(Theme.mist)
                }
            }
            .buttonStyle(.plain)
            .padding(.top, 2)
        }
    }
}
