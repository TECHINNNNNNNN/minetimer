import AppKit
import SwiftUI

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var timerPanel: NSPanel?
    private var typewriterPanel: NSPanel?
    private var quickAdd: QuickAddPanel?
    private var hotKey: HotKey?

    func applicationDidFinishLaunching(_ notification: Notification) {
        Notifier.requestPermission()
        _ = SoundPlayer.shared

        guard let screen = NSScreen.main?.visibleFrame else { return }
        timerPanel = FloatingPanel(name: "timer",
                                   origin: CGPoint(x: screen.maxX - 260, y: screen.minY + 60)) {
            TimerWidgetView()
        }
        typewriterPanel = FloatingPanel(name: "typewriter",
                                        origin: CGPoint(x: screen.midX - 210, y: screen.minY + 40)) {
            TypewriterView()
        }
        quickAdd = QuickAddPanel()
        LaunchAtLogin.set(UserDefaults.standard.bool(forKey: SettingsKey.launchAtLogin))
        registerHotKey()
        sync()
        for key in [SettingsKey.showTimerWidget, SettingsKey.showTypewriterWidget, SettingsKey.windowMode,
                    SettingsKey.quickAddHotKey] {
            UserDefaults.standard.addObserver(self, forKeyPath: key, context: nil)
        }
    }

    func toggleQuickAdd() { quickAdd?.toggle() }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?,
                               change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        keyPath == SettingsKey.quickAddHotKey ? registerHotKey() : sync()
    }

    private func registerHotKey() {
        hotKey = nil
        let raw = UserDefaults.standard.string(forKey: SettingsKey.quickAddHotKey) ?? ""
        let choice = HotKeyChoice(rawValue: raw) ?? .ctrlOptN
        guard let code = choice.keyCode else { return }
        hotKey = HotKey(keyCode: code, modifiers: choice.modifiers) { [weak self] in self?.toggleQuickAdd() }
    }

    private func sync() {
        let d = UserDefaults.standard
        let mode = WindowMode(rawValue: d.string(forKey: SettingsKey.windowMode) ?? "") ?? .desktop
        timerPanel?.level = mode.level
        typewriterPanel?.level = mode.level
        show(timerPanel, d.bool(forKey: SettingsKey.showTimerWidget))
        show(typewriterPanel, d.bool(forKey: SettingsKey.showTypewriterWidget))
    }

    private func show(_ panel: NSPanel?, _ visible: Bool) {
        visible ? panel?.orderFrontRegardless() : panel?.orderOut(nil)
    }
}
