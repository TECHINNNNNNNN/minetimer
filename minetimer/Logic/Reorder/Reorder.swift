enum Reorder {
    /// Moves `moving` to the slot of `target`, shifting the rest. Returns the new order.
    static func move<T: Equatable>(_ items: [T], moving: T, onto target: T) -> [T] {
        guard moving != target, let from = items.firstIndex(of: moving), let to = items.firstIndex(of: target) else { return items }
        var out = items
        out.remove(at: from)
        out.insert(moving, at: to)
        return out
    }
}
