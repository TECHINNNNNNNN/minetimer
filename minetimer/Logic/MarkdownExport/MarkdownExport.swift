import Foundation

// "- [ ] title #tag +project !! @2026-09-01 ~2 *daily", subtasks indented. Readable by the importer.
enum MarkdownExport {
    static func text(_ records: [TaskRecord], calendar: Calendar) -> String {
        let tree = TreeOrder.flatten(records, id: \.id, parent: \.parentID)
        let lines = tree.map { entry -> String in
            let r = entry.item
            let line = TaskLine.format(title: r.title, priority: r.priority, dueDate: r.dueDate, tags: r.tags,
                                       project: r.project, estimate: r.estimate,
                                       repeatRule: r.repeatRule.flatMap(RepeatRule.init(raw:)), calendar: calendar)
            let indent = String(repeating: "  ", count: entry.depth)
            return "\(indent)- [\(r.isDone ? "x" : " ")] \(line)"
        }
        return lines.joined(separator: "\n") + (lines.isEmpty ? "" : "\n")
    }
}
