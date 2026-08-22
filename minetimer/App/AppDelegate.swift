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
        syncVisibility()
        UserDefaults.standard.addObserver(self, forKeyPath: SettingsKey.showTimerWidget, context: nil)
        UserDefaults.standard.addObserver(self, forKeyPath: SettingsKey.showTypewriterWidget, context: nil)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?,
                               change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        syncVisibility()
    }

    private func syncVisibility() {
        let d = UserDefaults.standard
        show(timerPanel, d.bool(forKey: SettingsKey.showTimerWidget))
        show(typewriterPanel, d.bool(forKey: SettingsKey.showTypewriterWidget))
    }

    private func show(_ panel: NSPanel?, _ visible: Bool) {
        visible ? panel?.orderFrontRegardless() : panel?.orderOut(nil)
    }
}
