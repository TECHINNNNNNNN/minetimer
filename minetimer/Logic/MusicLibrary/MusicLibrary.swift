import Foundation

enum MusicLibrary {
    static let extensions: Set<String> = ["mp3", "m4a", "wav", "flac", "aiff", "aif"]

    static func scan(_ folder: URL, fileManager: FileManager = .default) -> [URL] {
        let e = fileManager.enumerator(at: folder, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])
        var found: [URL] = []
        while let u = e?.nextObject() as? URL {
            if extensions.contains(u.pathExtension.lowercased()) { found.append(u) }
        }
        return found.sorted { $0.lastPathComponent.localizedStandardCompare($1.lastPathComponent) == .orderedAscending }
    }
}
