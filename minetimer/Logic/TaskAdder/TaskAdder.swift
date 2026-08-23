import Foundation
import SwiftData

// One place that turns typed lines into stored tasks. Indented / "> " lines become subtasks of the line before.
@MainActor
enum TaskAdder {
    @discardableResult
    static func add(lines: [String], context: ModelContext, parent initialParent: TodoItem? = nil) -> [TodoItem] {
        let existing = (try? context.fetch(FetchDescriptor<TodoItem>())) ?? []
        var order = (existing.map(\.order).max() ?? 0) + 1
        var parent = initialParent
        var added: [TodoItem] = []
        for line in lines {
            let parsed = TaskParser.parse(line)
            guard !parsed.title.isEmpty else { continue }
            let item = TodoItem(parsed, order: order, parentID: parsed.isChild ? parent?.id : nil)
            if item.isRoutine, item.era == nil {
                let current = UserDefaults.standard.string(forKey: SettingsKey.currentEra) ?? Eras.defaultName
                item.era = current == Eras.defaultName ? nil : current
            }
            context.insert(item)
            added.append(item)
            if !parsed.isChild { parent = item }
            order += 1
        }
        try? context.save()
        return added
    }
}
