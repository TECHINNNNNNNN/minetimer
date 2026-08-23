import SwiftUI

// The readout: big condensed numerals on the black, a red hairline that burns down.
struct TimerDisc: View {
    var engine: TimerEngine

    var body: some View {
        VStack(spacing: 6) {
            if let next = engine.suggestedTask {
                suggestion(next)
            } else if let t = engine.askDone {
                doneAsk(t)
            } else {
                clock
            }
            progress
        }
        .contentShape(Rectangle())
        .onTapGesture { if engine.suggestedTask == nil, engine.askDone == nil { engine.toggle() } }
    }

    private var headline: some View {
        HStack(spacing: 8) {
            if let t = engine.activeTask {
                Text(engine.activeTrackNumber.map { String(format: "%02d", $0) } ?? "··")
                    .foregroundStyle(Theme.lacquer)
                Text(t.title.uppercased())
                    .foregroundStyle(Theme.paper)
                    .lineLimit(1)
                if t.pomodoros > 0 || t.estimate > 0 {
                    Text(PomodoroDots.text(done: t.pomodoros, estimate: t.estimate))
                        .font(Theme.mono(9))
                        .foregroundStyle(Theme.lacquer)
                }
            } else {
                Text("—").foregroundStyle(Theme.bronzeLt)
                Text("FREE PLAY").foregroundStyle(Theme.creamDim)
            }
        }
        .font(Theme.display(15))
        .frame(height: 18)
    }

    private var clock: some View {
        VStack(spacing: 4) {
            headline
            Text(engine.clock)
                .font(Theme.display(64))
                .foregroundStyle(Theme.paper)
                .contentTransition(.numericText())
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            HStack(spacing: 8) {
                Text(engine.phase.label.uppercased())
                    .foregroundStyle(engine.isRunning ? Theme.lacquer : Theme.creamDim)
                Text("·").foregroundStyle(Theme.bronzeLt)
                Text(engine.isRunning ? "PAUSE" : "START")
                    .foregroundStyle(Theme.creamDim)
            }
            .font(Theme.mono(8, weight: .semibold))
            .tracking(2)
        }
    }

    private func doneAsk(_ t: TodoItem) -> some View {
        VStack(spacing: 6) {
            Text("FULL · DONE WITH IT?")
                .font(Theme.mono(8, weight: .semibold))
                .tracking(2)
                .foregroundStyle(Theme.lacquer)
            Text(t.title)
                .font(Theme.display(22))
                .foregroundStyle(Theme.paper)
                .lineLimit(2)
                .multilineTextAlignment(.center)
            HStack(spacing: 16) {
                Button { engine.markAskedDone() } label: {
                    Text("YES").font(Theme.mono(9, weight: .bold)).tracking(1).foregroundStyle(Theme.paper)
                }
                Button { engine.keepGoing() } label: {
                    Text("KEEP GOING").font(Theme.mono(9, weight: .bold)).tracking(1).foregroundStyle(Theme.creamDim)
                }
            }
            .buttonStyle(.plain)
        }
        .frame(height: 104)
    }

    private var progress: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Rectangle().fill(Theme.bronze)
                Rectangle()
                    .fill(engine.phase.isBreak ? Theme.paper : Theme.lacquer)
                    .frame(width: geo.size.width * engine.progress)
                    .animation(.linear(duration: 0.25), value: engine.progress)
            }
        }
        .frame(height: 3)
        .padding(.top, 4)
    }

    private func suggestion(_ next: TodoItem) -> some View {
        VStack(spacing: 6) {
            Text("NEXT")
                .font(Theme.mono(8, weight: .semibold))
                .tracking(2)
                .foregroundStyle(Theme.lacquer)
            Text(next.title)
                .font(Theme.display(22))
                .foregroundStyle(Theme.paper)
                .lineLimit(2)
                .multilineTextAlignment(.center)
            HStack(spacing: 16) {
                Button { engine.acceptSuggestion() } label: {
                    Text("GO").font(Theme.mono(9, weight: .bold)).tracking(1).foregroundStyle(Theme.paper)
                }
                Button { engine.dismissSuggestion() } label: {
                    Text("SKIP").font(Theme.mono(9, weight: .bold)).tracking(1).foregroundStyle(Theme.creamDim)
                }
            }
            .buttonStyle(.plain)
        }
        .frame(height: 104)
    }
}
