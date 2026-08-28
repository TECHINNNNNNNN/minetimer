import AVFoundation
import AppKit

final class SoundPlayer {
    static let shared = SoundPlayer()

    private var engine = AVAudioEngine()
    private var node = AVAudioPlayerNode()
    private let format = AVAudioFormat(standardFormatWithSampleRate: SoundSynth.sampleRate, channels: 1)!
    private var cache: [SoundEffect: AVAudioPCMBuffer] = [:]

    private init() {
        wire()
        // macOS tears the audio graph down on sleep or when the output device changes. Rebuild it.
        NotificationCenter.default.addObserver(forName: .AVAudioEngineConfigurationChange, object: nil, queue: .main) { [weak self] _ in
            self?.rebuild()
        }
        NSWorkspace.shared.notificationCenter.addObserver(forName: NSWorkspace.didWakeNotification, object: nil, queue: .main) { [weak self] _ in
            self?.rebuild()
        }
    }

    func play(_ fx: SoundEffect) {
        let d = UserDefaults.standard
        guard d.bool(forKey: SettingsKey.soundsEnabled) else { return }
        if fx.isTypewriter, !d.bool(forKey: SettingsKey.typewriterSound) { return }
        if !engine.isRunning { rebuild() }
        guard engine.isRunning else { return }
        node.scheduleBuffer(buffer(for: fx), completionHandler: nil)
    }

    func playKey() { play(.key(variant: Int.random(in: 0..<4))) }

    private func wire() {
        engine.attach(node)
        engine.connect(node, to: engine.mainMixerNode, format: format)
        engine.mainMixerNode.outputVolume = 0.8
        do {
            try engine.start()
            node.play()
        } catch {
            NSLog("sound engine failed to start: \(error)")
        }
    }

    private func rebuild() {
        engine.stop()
        engine.detach(node)
        engine = AVAudioEngine()
        node = AVAudioPlayerNode()
        wire()
    }

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
