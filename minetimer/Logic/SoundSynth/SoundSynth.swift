import Foundation

// Every sound in the app is generated here, no audio files.
enum SoundSynth {
    static let sampleRate: Double = 44_100

    static func samples(for fx: SoundEffect) -> [Float] {
        switch fx {
        case .key(let v): return click(pitch: 1800 + Double(v) * 150, len: 0.045, noise: 0.9, gain: 0.55, seed: UInt64(v + 1))
        case .space:      return click(pitch: 900, len: 0.06, noise: 0.8, gain: 0.6, seed: 7)
        case .enter:      return mix(click(pitch: 700, len: 0.08, noise: 0.9, gain: 0.7, seed: 9),
                                     bell(freqs: [2093, 3136], len: 0.9, gain: 0.22, delay: 0.05))
        case .start:      return bell(freqs: [523, 784], len: 0.35, gain: 0.25)
        case .pause:      return bell(freqs: [392, 311], len: 0.3, gain: 0.2)
        case .tick:       return click(pitch: 2400, len: 0.02, noise: 0.3, gain: 0.12, seed: 3)
        case .workDone:   return gong()
        case .breakDone:  return mix(bell(freqs: [659, 880], len: 0.5, gain: 0.3),
                                     bell(freqs: [1318], len: 0.9, gain: 0.2, delay: 0.18))
        }
    }

    static func click(pitch: Double, len: Double, noise: Double, gain: Double, seed: UInt64) -> [Float] {
        let n = Int(sampleRate * len)
        var out = [Float](repeating: 0, count: n)
        var rng = SeededRandom(seed: seed)
        var lp = 0.0
        for i in 0..<n {
            let t = Double(i) / sampleRate
            let env = exp(-t * 90)
            lp += (rng.nextUnit() - lp) * 0.35
            let body = sin(2 * .pi * pitch * t) * exp(-t * 60)
            out[i] = Float((lp * noise + body * (1 - noise * 0.5)) * env * gain)
        }
        return out
    }

    static func bell(freqs: [Double], len: Double, gain: Double, delay: Double = 0) -> [Float] {
        let n = Int(sampleRate * (len + delay))
        let d = Int(sampleRate * delay)
        var out = [Float](repeating: 0, count: n)
        for i in d..<n {
            let t = Double(i - d) / sampleRate
            var v = 0.0
            for (k, f) in freqs.enumerated() {
                v += sin(2 * .pi * f * t) * exp(-t * (3 + Double(k) * 2)) / Double(freqs.count)
            }
            out[i] = Float(v * gain)
        }
        return out
    }

    static func gong() -> [Float] {
        let n = Int(sampleRate * 2.6)
        var out = [Float](repeating: 0, count: n)
        let partials: [(freq: Double, amp: Double, decay: Double)] =
            [(196, 1.0, 1.2), (392, 0.5, 1.6), (587, 0.35, 2.2), (880, 0.2, 3.0), (1318, 0.12, 4.0)]
        for i in 0..<n {
            let t = Double(i) / sampleRate
            let wobble: Double = 0.5 * sin(2 * Double.pi * 3 * t)
            var v = 0.0
            for p in partials {
                let phase: Double = 2 * Double.pi * p.freq * t + wobble
                let envelope: Double = p.amp * exp(-t * p.decay)
                v += sin(phase) * envelope
            }
            let attack: Double = min(1, t * 40)
            out[i] = Float(v * 0.22 * attack)
        }
        return out
    }

    static func mix(_ a: [Float], _ b: [Float]) -> [Float] {
        var out = [Float](repeating: 0, count: max(a.count, b.count))
        for (i, v) in a.enumerated() { out[i] += v }
        for (i, v) in b.enumerated() { out[i] += v }
        return out
    }
}
