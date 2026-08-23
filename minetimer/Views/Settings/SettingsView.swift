import SwiftUI

struct SettingsView: View {
    @AppStorage(SettingsKey.workMinutes) private var work = 25
    @AppStorage(SettingsKey.shortBreakMinutes) private var short = 5
    @AppStorage(SettingsKey.longBreakMinutes) private var long = 15
    @AppStorage(SettingsKey.longBreakEvery) private var every = 4
    @AppStorage(SettingsKey.dailyGoal) private var goal = 8
    @AppStorage(SettingsKey.autoStartBreaks) private var autoBreaks = true
    @AppStorage(SettingsKey.autoStartWork) private var autoWork = false
    @AppStorage(SettingsKey.soundsEnabled) private var sounds = true
    @AppStorage(SettingsKey.typewriterSound) private var typewriter = true
    @AppStorage(SettingsKey.tickSound) private var tick = false
    @AppStorage(SettingsKey.notificationsEnabled) private var notifications = true
    @AppStorage(SettingsKey.showTimerWidget) private var showTimer = true
    @AppStorage(SettingsKey.showTypewriterWidget) private var showTypewriter = true
    @AppStorage(SettingsKey.windowMode) private var windowMode = WindowMode.desktop.rawValue
    @AppStorage(SettingsKey.quickAddHotKey) private var hotKey = HotKeyChoice.ctrlOptN.rawValue
    @State private var music = MusicPlayer.shared

    var body: some View {
        Form {
            Section("Timer") {
                Stepper("Focus: \(work) min", value: $work, in: 1...120)
                Stepper("Short break: \(short) min", value: $short, in: 1...60)
                Stepper("Long break: \(long) min", value: $long, in: 1...90)
                Stepper("Long break every \(every) sessions", value: $every, in: 1...10)
                Stepper("Daily goal: \(goal) sessions", value: $goal, in: 1...60)
                Toggle("Auto-start breaks", isOn: $autoBreaks)
                Toggle("Auto-start focus after break", isOn: $autoWork)
            }
            Section("Sound") {
                Toggle("Sounds", isOn: $sounds)
                Toggle("Typewriter keys", isOn: $typewriter).disabled(!sounds)
                Toggle("Ticking while focused", isOn: $tick).disabled(!sounds)
                Toggle("Notifications", isOn: $notifications)
            }
            Section("Music") {
                HStack {
                    Text(music.folderName.map { "\($0) · \(music.tracks.count) tracks" } ?? "No folder chosen")
                    Spacer()
                    Button("Choose folder…") { music.chooseFolder() }
                }
                Slider(value: $music.volume, in: 0...1) { Text("Volume") }
                HStack {
                    Button(music.isPlaying ? "Pause" : "Play") { music.toggle() }.disabled(music.tracks.isEmpty)
                    Button("Next") { music.next() }.disabled(music.tracks.isEmpty)
                    Text(music.currentTitle).foregroundStyle(.secondary).lineLimit(1)
                }
            }
            Section("Quick add") {
                Picker("Shortcut from anywhere", selection: $hotKey) {
                    ForEach(HotKeyChoice.allCases, id: \.rawValue) { Text($0.label).tag($0.rawValue) }
                }
            }
            Section("Widgets") {
                Toggle("Show timer", isOn: $showTimer)
                Toggle("Show typewriter", isOn: $showTypewriter)
                Picker("Where they live", selection: $windowMode) {
                    ForEach(WindowMode.allCases, id: \.rawValue) { Text($0.label).tag($0.rawValue) }
                }
            }
        }
        .formStyle(.grouped)
        .frame(width: 420)
        .onChange(of: [work, short, long]) { TimerEngine.shared.refreshDurations() }
    }
}
