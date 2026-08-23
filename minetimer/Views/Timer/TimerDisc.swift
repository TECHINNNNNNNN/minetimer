import SwiftUI

// The readout under the portrait: thin numerals, a hairline that burns down.
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
        VStack(spacing: 2) {
            Text(engine.isRunning ? engine.clock : "\(engine.minutesLeft):00")
                .font(Theme.display(40, weight: .thin))
                .tracking(-1)
                .foregroundStyle(Theme.paperInk)
                .contentTransition(.numericText())
            HStack(spacing: 6) {
                Text(engine.phase.label.uppercased())
                    .foregroundStyle(engine.isRunning ? Theme.lacquer : Theme.mist)
                Text("·").foregroundStyle(Theme.paperLine)
                Text(engine.isRunning ? "PAUSE" : "START")
                    .foregroundStyle(Theme.mist)
            }
            .font(Theme.mono(8, weight: .semibold))
            .tracking(1.5)
            Text(engine.activeTask?.title ?? " ")
                .font(Theme.mono(8))
                .foregroundStyle(Theme.mist)
                .lineLimit(1)
                .padding(.top, 2)
        }
    }

    private var progress: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Rectangle().fill(Theme.paperLine)
                Rectangle()
                    .fill(engine.phase.isBreak ? Theme.mist : Theme.lacquer)
                    .frame(width: geo.size.width * engine.progress)
                    .animation(.linear(duration: 0.25), value: engine.progress)
            }
        }
        .frame(height: 2)
        .padding(.top, 6)
    }

    private func suggestion(_ next: TodoItem) -> some View {
        VStack(spacing: 6) {
            Text("NEXT")
                .font(Theme.mono(8, weight: .semibold))
                .tracking(1.5)
                .foregroundStyle(Theme.lacquer)
            Text(next.title)
                .font(Theme.mono(11))
                .foregroundStyle(Theme.paperInk)
                .lineLimit(2)
                .multilineTextAlignment(.center)
            HStack(spacing: 16) {
                Button { engine.acceptSuggestion() } label: {
                    Text("GO").font(Theme.mono(9, weight: .bold)).tracking(1).foregroundStyle(Theme.paperInk)
                }
                Button { engine.dismissSuggestion() } label: {
                    Text("SKIP").font(Theme.mono(9, weight: .bold)).tracking(1).foregroundStyle(Theme.mist)
                }
            }
            .buttonStyle(.plain)
        }
        .frame(height: 74)
    }
}
