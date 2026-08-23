import AppKit
import SwiftUI

final class QuickAddPanel: NSPanel {
    static let didShow = Notification.Name("quickAddDidShow")
    private var previousApp: NSRunningApplication?

    init() {
        super.init(contentRect: NSRect(x: 0, y: 0, width: 460, height: 40),
                   styleMask: [.borderless, .nonactivatingPanel, .fullSizeContentView],
                   backing: .buffered, defer: false)
        isFloatingPanel = true
        level = .statusBar
        collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .transient, .ignoresCycle]
        isMovableByWindowBackground = true
        isReleasedWhenClosed = false
        hidesOnDeactivate = false
        isOpaque = false
        backgroundColor = .clear
        hasShadow = true
        let host = NSHostingView(rootView: QuickAddView { [weak self] in self?.dismiss() }
            .modelContainer(Persistence.container))
        host.sizingOptions = [.intrinsicContentSize]
        contentView = host
        host.layoutSubtreeIfNeeded()
        setContentSize(host.fittingSize)
    }

    override var canBecomeKey: Bool { true }

    func toggle() {
        if isVisible { dismiss(); return }
        previousApp = NSWorkspace.shared.frontmostApplication
        if let screen = NSScreen.main?.visibleFrame {
            setFrameOrigin(CGPoint(x: screen.midX - frame.width / 2, y: screen.midY + 120))
        }
        NSApp.activate(ignoringOtherApps: true)
        makeKeyAndOrderFront(nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            NotificationCenter.default.post(name: Self.didShow, object: nil)
        }
    }

    func dismiss() {
        close()
        previousApp?.activate()
        previousApp = nil
    }

    override func resignKey() {
        super.resignKey()
        close()
    }
}
