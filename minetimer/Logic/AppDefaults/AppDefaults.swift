import Foundation

enum AppDefaults {
    static func register() {
        UserDefaults.standard.register(defaults: [
            SettingsKey.workMinutes: 25,
            SettingsKey.shortBreakMinutes: 5,
            SettingsKey.longBreakMinutes: 15,
            SettingsKey.longBreakEvery: 4,
            SettingsKey.dailyGoal: 8,
            SettingsKey.autoStartBreaks: true,
            SettingsKey.autoStartWork: false,
            SettingsKey.soundsEnabled: true,
            SettingsKey.typewriterSound: true,
            SettingsKey.tickSound: false,
            SettingsKey.notificationsEnabled: true,
            SettingsKey.musicVolume: 0.6,
            SettingsKey.showTimerWidget: true,
            SettingsKey.showTypewriterWidget: true,
            SettingsKey.windowMode: WindowMode.desktop.rawValue,
        ])
    }
}
