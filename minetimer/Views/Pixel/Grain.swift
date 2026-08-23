import SwiftUI
import AppKit

// Film grain, generated once and tiled. Gives every surface the same worn texture.
struct Grain: View {
    var opacity: Double = 0.07

    private static let tile: Image = {
        let size = 128
        var rng = SeededRandom(seed: 7)
        var bytes = [UInt8](repeating: 0, count: size * size)
        for i in bytes.indices { bytes[i] = UInt8(128 + Int(rng.nextUnit() * 100)) }
        let provider = CGDataProvider(data: Data(bytes) as CFData)!
        let cg = CGImage(width: size, height: size, bitsPerComponent: 8, bitsPerPixel: 8,
                         bytesPerRow: size, space: CGColorSpaceCreateDeviceGray(),
                         bitmapInfo: CGBitmapInfo(rawValue: 0), provider: provider,
                         decode: nil, shouldInterpolate: false, intent: .defaultIntent)!
        return Image(nsImage: NSImage(cgImage: cg, size: NSSize(width: size, height: size)))
    }()

    var body: some View {
        Self.tile
            .resizable(resizingMode: .tile)
            .opacity(opacity)
            .blendMode(.overlay)
            .allowsHitTesting(false)
    }
}
