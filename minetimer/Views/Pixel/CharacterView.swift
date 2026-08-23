import SwiftUI

struct CharacterView: View {
    let isRunning: Bool
    let isBreak: Bool
    var pixel: CGFloat = 6

    @State private var blink = false
    @State private var bob = false

    private var face: SpriteFace {
        if isBreak { return .blink }
        if blink { return .blink }
        return isRunning ? .focus : .open
    }

    var body: some View {
        PixelSprite(rows: KongmingSprite.frame(face), palette: KongmingSprite.palette, pixel: pixel)
            .offset(y: bob ? -pixel / 2 : 0)
            .animation(.easeInOut(duration: 0.8), value: bob)
            .task(id: isRunning) {
                while !Task.isCancelled {
                    try? await Task.sleep(for: .seconds(isRunning ? 0.9 : 3.5))
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
