// Typing "/" in the field filters the paper instead of adding a task.
enum SearchFilter {
    static func query(from draft: String) -> String? {
        guard draft.hasPrefix("/") else { return nil }
        return String(draft.dropFirst()).trimmingCharacters(in: .whitespaces).lowercased()
    }

    static func matches(title: String, tags: [String], project: String?, query: String) -> Bool {
        if query.isEmpty { return true }
        let hay = ([title, project ?? ""] + tags).joined(separator: " ").lowercased()
        return query.split(separator: " ").allSatisfy { hay.contains($0) }
    }
}
