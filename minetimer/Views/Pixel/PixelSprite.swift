import SwiftUI

struct PixelSprite: View {
    let rows: [String]
    let palette: [Character: Color]
    var pixel: CGFloat = 6

    var body: some View {
        Canvas { ctx, _ in
            for (y, row) in rows.enumerated() {
                for (x, ch) in row.enumerated() {
                    guard let c = palette[ch] else { continue }
                    let rect = CGRect(x: CGFloat(x) * pixel, y: CGFloat(y) * pixel, width: pixel + 0.5, height: pixel + 0.5)
                    ctx.fill(Path(rect), with: .color(c))
                }
            }
        }
        .frame(width: CGFloat(rows.first?.count ?? 0) * pixel, height: CGFloat(rows.count) * pixel)
    }
}
