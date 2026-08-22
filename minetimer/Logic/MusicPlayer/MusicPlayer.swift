import AVFoundation
import AppKit
import Observation

@Observable
@MainActor
final class MusicPlayer: NSObject, AVAudioPlayerDelegate {
    static let shared = MusicPlayer()

    private(set) var tracks: [URL] = []
    private(set) var current: URL?
    private(set) var isPlaying = false
    var volume: Float {
        didSet {
            player?.volume = volume
            UserDefaults.standard.set(volume, forKey: SettingsKey.musicVolume)
        }
    }

    private var player: AVAudioPlayer?
    private var queue: [URL] = []

    private override init() {
        volume = UserDefaults.standard.float(forKey: SettingsKey.musicVolume)
        super.init()
        if let path = UserDefaults.standard.string(forKey: SettingsKey.musicFolder) {
            load(folder: URL(fileURLWithPath: path))
        }
    }

    var folderName: String? {
        UserDefaults.standard.string(forKey: SettingsKey.musicFolder).map { ($0 as NSString).lastPathComponent }
    }

    var currentTitle: String { current?.deletingPathExtension().lastPathComponent ?? "—" }

    func chooseFolder() {
        let p = NSOpenPanel()
        p.canChooseDirectories = true
        p.canChooseFiles = false
        p.prompt = "Use this folder"
        p.message = "Pick a folder of music"
        NSApp.activate(ignoringOtherApps: true)
        guard p.runModal() == .OK, let url = p.url else { return }
        UserDefaults.standard.set(url.path, forKey: SettingsKey.musicFolder)
        load(folder: url)
    }

    func load(folder: URL) {
        tracks = MusicLibrary.scan(folder)
        queue = tracks.shuffled()
    }

    func toggle() { isPlaying ? pause() : play() }

    func play() {
        guard player != nil else { next(); return }
        player?.play()
        isPlaying = true
    }

    func pause() {
        player?.pause()
        isPlaying = false
    }

    func next() {
        guard !tracks.isEmpty else { return }
        if queue.isEmpty { queue = tracks.shuffled() }
        let url = queue.removeFirst()
        guard let p = try? AVAudioPlayer(contentsOf: url) else { next(); return }
        p.delegate = self
        p.volume = volume
        p.play()
        player = p
        current = url
        isPlaying = true
    }

    nonisolated func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        Task { @MainActor in self.next() }
    }
}
