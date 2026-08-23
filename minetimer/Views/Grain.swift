import SwiftUI

// Film grain: one small noise tile, repeated.
struct Grain: View {
    var opacity: Double = 0.06

    var body: some View {
        Image(nsImage: Self.tile)
            .resizable(resizingMode: .tile)
            .opacity(opacity)
            .allowsHitTesting(false)
    }

    private static let tile: NSImage = {
        let size = 128
        var rng = SeededRandom(seed: 99)
        var bytes = [UInt8](repeating: 0, count: size * size * 4)
        for i in 0..<(size * size) {
            let v = UInt8(clamping: Int(128 + rng.nextUnit() * 110))
            bytes[i * 4] = v; bytes[i * 4 + 1] = v; bytes[i * 4 + 2] = v; bytes[i * 4 + 3] = 255
        }
        let provider = CGDataProvider(data: Data(bytes) as CFData)!
        let cg = CGImage(width: size, height: size, bitsPerComponent: 8, bitsPerPixel: 32, bytesPerRow: size * 4,
                         space: CGColorSpaceCreateDeviceRGB(),
                         bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue),
                         provider: provider, decode: nil, shouldInterpolate: false, intent: .defaultIntent)!
        return NSImage(cgImage: cg, size: NSSize(width: size, height: size))
    }()
}
