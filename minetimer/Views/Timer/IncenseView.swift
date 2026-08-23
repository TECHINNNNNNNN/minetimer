import SwiftUI

// A cream burner on three legs. The stick shortens as time burns; smoke rises only while running.
struct IncenseView: View {
    let progress: Double
    let isRunning: Bool
    var width: CGFloat = 150

    var body: some View {
        ZStack(alignment: .bottom) {
            smoke
            burner
        }
        .frame(width: width, height: width * 1.25)
    }

    private var burner: some View {
        Canvas { ctx, size in
            let w = size.width, h = size.height
            let cx = w / 2
            let bowlTop = h * 0.46, bowlBottom = h * 0.86
            let rim = w * 0.36

            // legs
            for dx: CGFloat in [-0.24, 0, 0.24] {
                var leg = Path()
                leg.move(to: CGPoint(x: cx + dx * w, y: bowlBottom - 4))
                leg.addLine(to: CGPoint(x: cx + dx * w * 1.25, y: h))
                ctx.stroke(leg, with: .color(Theme.paper), style: StrokeStyle(lineWidth: 6, lineCap: .round))
            }
            // bowl
            var bowl = Path()
            bowl.move(to: CGPoint(x: cx - rim, y: bowlTop + 10))
            bowl.addCurve(to: CGPoint(x: cx + rim, y: bowlTop + 10),
                          control1: CGPoint(x: cx - rim, y: bowlBottom + 8),
                          control2: CGPoint(x: cx + rim, y: bowlBottom + 8))
            bowl.closeSubpath()
            ctx.fill(bowl, with: .color(Theme.paper))
            ctx.fill(Path(CGRect(x: cx - rim - 4, y: bowlTop + 2, width: rim * 2 + 8, height: 8)), with: .color(Theme.ink))
            for dx: CGFloat in [-0.18, 0, 0.18] {
                let y = bowlTop + 24 + (dx == 0 ? 5 : 0)
                ctx.fill(Path(ellipseIn: CGRect(x: cx + dx * w - 3, y: y, width: 6, height: 6)), with: .color(Theme.ink))
            }
            // stick burns down
            let full = bowlTop - 8
            let len = full * (1 - progress)
            var stick = Path()
            stick.move(to: CGPoint(x: cx, y: bowlTop + 2))
            stick.addLine(to: CGPoint(x: cx, y: bowlTop + 2 - len))
            ctx.stroke(stick, with: .color(Theme.creamDim), lineWidth: 3)
            if progress < 1 {
                ctx.fill(Path(ellipseIn: CGRect(x: cx - 3.5, y: bowlTop - len - 2, width: 7, height: 7)),
                         with: .color(isRunning ? Theme.lacquer : Theme.creamDim))
            }
        }
    }

    private var smoke: some View {
        let tipY = -(width * 1.25 * 0.46 - 8) * (1 - progress)
        return ZStack {
            ForEach(0..<3, id: \.self) { i in
                SmokePuff(delay: Double(i) * 1.4, active: isRunning)
                    .offset(y: width * 1.25 * 0.46 + tipY - 4)
            }
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
    }
}

struct SmokePuff: View {
    let delay: Double
    let active: Bool
    @State private var t: Double = 0

    var body: some View {
        Circle()
            .fill(Theme.paper.opacity(0.28 * (1 - t)))
            .frame(width: 14, height: 14)
            .scaleEffect(0.6 + t * 1.8)
            .offset(x: t * 22, y: -t * 110)
            .blur(radius: 5)
            .opacity(active ? 1 : 0)
            .task(id: active) {
                guard active else { return }
                try? await Task.sleep(for: .seconds(delay))
                while !Task.isCancelled {
                    t = 0
                    withAnimation(.easeOut(duration: 4.2)) { t = 1 }
                    try? await Task.sleep(for: .seconds(4.2))
                }
            }
    }
}
