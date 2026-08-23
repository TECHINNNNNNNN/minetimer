import SwiftUI

// The readout: big condensed numerals on the black, a red hairline that burns down.
struct TimerDisc: View {
    var engine: TimerEngine

    var body: some View {
        VStack(spacing: 6) {
            if let next = engine.suggestedTask {
                suggestion(next)
            } else {
                clock
            }
            progress
        }
        .contentShape(Rectangle())
        .onTapGesture { if engine.suggestedTask == nil { engine.toggle() } }
    }

    private var clock: some View {
        VStack(spacing: 4) {
            Text(engine.isRunning ? engine.clock : "\(engine.minutesLeft):00")
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
            Text(engine.activeTask?.title ?? " ")
                .font(Theme.mono(8))
                .foregroundStyle(Theme.creamDim)
                .lineLimit(1)
        }
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
