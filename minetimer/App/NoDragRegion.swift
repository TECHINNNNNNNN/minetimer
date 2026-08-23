import SwiftUI

// Views that need their own drag (the tracklist) report their frame here; the panel won't move when a drag starts inside.
enum NoDragRegion {
    static var rects: [String: CGRect] = [:]
}

struct ReportNoDragRegion: ViewModifier {
    let key: String
    func body(content: Content) -> some View {
        content.background {
            GeometryReader { geo in
                Color.clear
                    .onAppear { NoDragRegion.rects[key] = geo.frame(in: .global) }
                    .onChange(of: geo.frame(in: .global)) { _, f in NoDragRegion.rects[key] = f }
            }
        }
    }
}

extension View {
    func noWindowDrag(_ key: String) -> some View { modifier(ReportNoDragRegion(key: key)) }
}
