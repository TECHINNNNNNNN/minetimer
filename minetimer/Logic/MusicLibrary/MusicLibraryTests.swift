import Foundation
import Testing
@testable import minetimer

struct MusicLibraryTests {
    @Test func findsOnlyAudioSortedNaturally() throws {
        let dir = FileManager.default.temporaryDirectory.appending(path: "MusicLibraryTests-\(UUID())")
        try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        FileManager.default.createFile(atPath: dir.appending(path: "10 - b.mp3").path, contents: Data())
        FileManager.default.createFile(atPath: dir.appending(path: "2 - a.M4A").path, contents: Data())
        FileManager.default.createFile(atPath: dir.appending(path: "cover.jpg").path, contents: Data())

        let names = MusicLibrary.scan(dir).map(\.lastPathComponent)

        #expect(names == ["2 - a.M4A", "10 - b.mp3"])
        try? FileManager.default.removeItem(at: dir)
    }
}
