import SwiftUI

struct YakView: View {
    let isRunning: Bool
    let isBreak: Bool
    var pixel: CGFloat = 6

    @State private var blink = false
    @State private var bob = false

    private var face: YakFace {
        if isBreak { return .blink }
        if blink { return .blink }
        return isRunning ? .focus : .open
    }

    var body: some View {
        PixelSprite(rows: YakSprite.frame(face), palette: YakSprite.palette, pixel: pixel)
            .offset(y: bob ? -pixel : 0)
            .animation(.easeInOut(duration: 0.6), value: bob)
            .task(id: isRunning) {
                while !Task.isCancelled {
                    try? await Task.sleep(for: .seconds(isRunning ? 0.7 : 3.5))
                    if isRunning { bob.toggle() } else { await doBlink() }
                }
            }
    }

    private func doBlink() async {
        blink = true
        try? await Task.sleep(for: .milliseconds(120))
        blink = false
    }
}
