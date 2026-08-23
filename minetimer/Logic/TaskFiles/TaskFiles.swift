import AppKit
import SwiftData
import UniformTypeIdentifiers

// Export / import through the standard save and open panels.
@MainActor
enum TaskFiles {
    static func exportMarkdown() {
        let text = MarkdownExport.text(records(), calendar: .current)
        save(text.data(using: .utf8)!, name: "minetimer.md", type: .plainText)
    }

    static func exportJSON() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        guard let data = try? encoder.encode(records()) else { return }
        save(data, name: "minetimer.json", type: .json)
    }

    static func importFile() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.plainText, .json, UTType(filenameExtension: "md") ?? .plainText]
        NSApp.activate(ignoringOtherApps: true)
        guard panel.runModal() == .OK, let url = panel.url, let data = try? Data(contentsOf: url) else { return }
        let context = ModelContext(Persistence.container)
        if url.pathExtension.lowercased() == "json" {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            guard let records = try? decoder.decode([TaskRecord].self, from: data) else { return }
            let existing = Set(((try? context.fetch(FetchDescriptor<TodoItem>())) ?? []).map(\.id))
            for r in records where !existing.contains(r.id) { context.insert(TodoItem(r)) }
            try? context.save()
        } else if let text = String(data: data, encoding: .utf8) {
            TaskAdder.add(lines: ChecklistLine.lines(from: text), context: context)
        }
    }

    private static func records() -> [TaskRecord] {
        let context = ModelContext(Persistence.container)
        let items = (try? context.fetch(FetchDescriptor<TodoItem>(sortBy: [SortDescriptor(\.order)]))) ?? []
        return items.map(TaskRecord.init)
    }

    private static func save(_ data: Data, name: String, type: UTType) {
        let panel = NSSavePanel()
        panel.nameFieldStringValue = name
        panel.allowedContentTypes = [type]
        NSApp.activate(ignoringOtherApps: true)
        guard panel.runModal() == .OK, let url = panel.url else { return }
        try? data.write(to: url)
    }
}
