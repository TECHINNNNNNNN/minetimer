import AppKit
import SwiftUI

final class FloatingPanel<Content: View>: NSPanel {
    init(name: String, origin: CGPoint, @ViewBuilder content: () -> Content) {
        super.init(contentRect: NSRect(origin: origin, size: .zero),
                   styleMask: [.borderless, .nonactivatingPanel, .fullSizeContentView],
                   backing: .buffered, defer: false)
        isFloatingPanel = true
        collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary]
        isOpaque = false
        backgroundColor = .clear
        hasShadow = false
        isMovableByWindowBackground = true
        hidesOnDeactivate = false
        becomesKeyOnlyIfNeeded = true
        titleVisibility = .hidden
        titlebarAppearsTransparent = true

        let host = NSHostingView(rootView: content().modelContainer(Persistence.container))
        host.sizingOptions = [.intrinsicContentSize]
        contentView = host
        host.layoutSubtreeIfNeeded()
        setContentSize(host.fittingSize)
        setFrameAutosaveName(name)
        if !setFrameUsingName(name) { setFrameOrigin(origin) }
    }

    // A drag that starts on the tracklist belongs to the rows, not the window.
    override func sendEvent(_ event: NSEvent) {
        if event.type == .leftMouseDown {
            let p = event.locationInWindow
            let top = CGPoint(x: p.x, y: frame.height - p.y)
            isMovableByWindowBackground = !NoDragRegion.rects.values.contains { $0.contains(top) }
        }
        super.sendEvent(event)
    }

    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { false }
}
