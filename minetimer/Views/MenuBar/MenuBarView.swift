import SwiftUI

struct MenuBarView: View {
    @State private var engine = TimerEngine.shared
    @AppStorage(SettingsKey.showTimerWidget) private var showTimer = true
    @AppStorage(SettingsKey.showTypewriterWidget) private var showTypewriter = true

    var body: some View {
        Text("\(engine.phase.label) · \(engine.completedToday)/\(engine.dailyGoal) today")
        if let t = engine.activeTask { Text("→ \(t.title)") }
        Divider()
        TimerMenu(engine: engine)
        Divider()
        Toggle("Timer widget", isOn: $showTimer)
        Toggle("Typewriter widget", isOn: $showTypewriter)
        Divider()
        Button("Quit minetimer") { NSApp.terminate(nil) }
            .keyboardShortcut("q")
    }
}
