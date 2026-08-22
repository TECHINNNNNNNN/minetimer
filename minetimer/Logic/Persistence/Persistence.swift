import Foundation
import SwiftData

enum Persistence {
    static let container: ModelContainer = {
        let schema = Schema([TodoItem.self, FocusSession.self])
        let dir = URL.applicationSupportDirectory.appending(path: "minetimer", directoryHint: .isDirectory)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        let config = ModelConfiguration(schema: schema, url: dir.appending(path: "minetimer.store"))
        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Could not open database: \(error)")
        }
    }()
}
