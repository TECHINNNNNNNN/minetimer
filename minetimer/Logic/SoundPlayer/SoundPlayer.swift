import AVFoundation

final class SoundPlayer {
    static let shared = SoundPlayer()

    private let engine = AVAudioEngine()
    private let node = AVAudioPlayerNode()
    private let format = AVAudioFormat(standardFormatWithSampleRate: SoundSynth.sampleRate, channels: 1)!
    private var cache: [SoundEffect: AVAudioPCMBuffer] = [:]

    private init() {
        engine.attach(node)
        engine.connect(node, to: engine.mainMixerNode, format: format)
        engine.mainMixerNode.outputVolume = 0.8
        try? engine.start()
        node.play()
    }

    func play(_ fx: SoundEffect) {
        let d = UserDefaults.standard
        guard d.bool(forKey: SettingsKey.soundsEnabled) else { return }
        if fx.isTypewriter, !d.bool(forKey: SettingsKey.typewriterSound) { return }
        if !engine.isRunning {
            try? engine.start()
            node.play()
        }
        node.scheduleBuffer(buffer(for: fx), completionHandler: nil)
    }

    func playKey() { play(.key(variant: Int.random(in: 0..<4))) }

    private func buffer(for fx: SoundEffect) -> AVAudioPCMBuffer {
        if let b = cache[fx] { return b }
        let samples = SoundSynth.samples(for: fx)
        let buf = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: AVAudioFrameCount(samples.count))!
        buf.frameLength = AVAudioFrameCount(samples.count)
        samples.withUnsafeBufferPointer { src in
            buf.floatChannelData![0].update(from: src.baseAddress!, count: samples.count)
        }
        cache[fx] = buf
        return buf
    }
}
