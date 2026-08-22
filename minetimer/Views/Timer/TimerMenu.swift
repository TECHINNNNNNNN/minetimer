import SwiftUI

struct TimerMenu: View {
    var engine: TimerEngine

    var body: some View {
        Button(engine.isRunning ? "Pause" : "Start") { engine.toggle() }
        Button("Restart") { engine.restart() }
        Button("Skip") { engine.skip() }
        Divider()
        ForEach(Phase.allCases, id: \.self) { p in
            Button(p.label.capitalized) { engine.jump(to: p) }
        }
        Divider()
        Button("Clear task") { engine.activeTask = nil }
        SettingsLink { Text("Settings…") }
    }
}
