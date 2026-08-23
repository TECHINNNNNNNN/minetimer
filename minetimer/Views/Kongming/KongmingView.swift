import SwiftUI

// Layered vector portrait. Eyes blink rarely and close on breaks; the fan strokes once when a session starts.
struct KongmingView: View {
    let isRunning: Bool
    let isBreak: Bool
    let startCount: Int
    var height: CGFloat = 380

    @State private var blink = false
    @State private var fanAngle: Double = 0

    private var eyesShut: Bool { isBreak || blink }

    var body: some View {
        ZStack {
            layer("kongming-body")
            layer(eyesShut ? "kongming-eyes-shut" : "kongming-eyes-open")
            layer("kongming-fan")
                .rotationEffect(.degrees(fanAngle), anchor: UnitPoint(x: 236.0 / 300.0, y: 262.0 / 360.0))
        }
        .frame(width: height * 300 / 360, height: height)
        .shadow(color: .black.opacity(0.7), radius: 28, y: 26)
        .task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(Double.random(in: 7...12)))
                blink = true
                try? await Task.sleep(for: .milliseconds(110))
                blink = false
            }
        }
        .onChange(of: startCount) { _, _ in stroke() }
    }

    private func layer(_ name: String) -> some View {
        Image(nsImage: Self.image(name))
            .resizable()
            .interpolation(.high)
            .aspectRatio(contentMode: .fit)
    }

    private func stroke() {
        withAnimation(.easeOut(duration: 0.45)) { fanAngle = -14 }
        withAnimation(.easeInOut(duration: 0.9).delay(0.45)) { fanAngle = 0 }
    }

    private static var cache: [String: NSImage] = [:]

    private static func image(_ name: String) -> NSImage {
        if let i = cache[name] { return i }
        let url = Bundle.main.url(forResource: name, withExtension: "svg")!
        let i = NSImage(contentsOf: url)!
        cache[name] = i
        return i
    }
}
