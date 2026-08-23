// Puts each subtask right under its parent. Orphans (parent missing) act as top-level.
enum TreeOrder {
    static func flatten<T, ID: Hashable>(_ items: [T], id: (T) -> ID, parent: (T) -> ID?) -> [(item: T, depth: Int)] {
        let ids = Set(items.map(id))
        var children: [ID: [T]] = [:]
        var roots: [T] = []
        for item in items {
            if let p = parent(item), ids.contains(p), p != id(item) {
                children[p, default: []].append(item)
            } else {
                roots.append(item)
            }
        }
        var out: [(T, Int)] = []
        func walk(_ item: T, _ depth: Int) {
            out.append((item, depth))
            for c in children[id(item)] ?? [] { walk(c, depth + 1) }
        }
        for r in roots { walk(r, 0) }
        return out
    }
}
