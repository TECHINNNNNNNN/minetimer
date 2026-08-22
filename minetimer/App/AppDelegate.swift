import AppKit
import SwiftUI

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var timerPanel: NSPanel?
    private var typewriterPanel: NSPanel?

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
        sync()
        for key in [SettingsKey.showTimerWidget, SettingsKey.showTypewriterWidget, SettingsKey.windowMode] {
            UserDefaults.standard.addObserver(self, forKeyPath: key, context: nil)
        }
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?,
                               change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        sync()
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
