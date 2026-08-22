import SwiftUI

@main
struct MinetimerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var delegate
    @State private var engine: TimerEngine

    init() {
        AppDefaults.register()
        engine = TimerEngine.shared
    }

    var body: some Scene {
        MenuBarExtra {
            MenuBarView()
        } label: {
            Text(engine.isRunning ? engine.clock : "ยักษ์")
                .font(Theme.mono(12, weight: .bold))
        }
        Settings {
            SettingsView()
        }
    }
}
