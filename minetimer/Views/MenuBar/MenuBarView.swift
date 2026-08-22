import SwiftUI

struct MenuBarView: View {
    @State private var engine = TimerEngine.shared
    @AppStorage(SettingsKey.showTimerWidget) private var showTimer = true
    @AppStorage(SettingsKey.showTypewriterWidget) private var showTypewriter = true
    @AppStorage(SettingsKey.windowMode) private var windowMode = WindowMode.desktop.rawValue

    var body: some View {
        Text("\(engine.phase.label) · \(engine.completedToday)/\(engine.dailyGoal) today")
        if let t = engine.activeTask { Text("→ \(t.title)") }
        Divider()
        TimerMenu(engine: engine)
        Divider()
        Toggle("Timer widget", isOn: $showTimer)
        Toggle("Typewriter widget", isOn: $showTypewriter)
        Picker("Widgets live", selection: $windowMode) {
            ForEach(WindowMode.allCases, id: \.rawValue) { Text($0.label).tag($0.rawValue) }
        }
        Divider()
        Button("Quit minetimer") { NSApp.terminate(nil) }
            .keyboardShortcut("q")
    }
}
