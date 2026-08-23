enum TopTasks {
    static func ranked(_ titles: [String?], limit: Int) -> [(title: String, count: Int)] {
        var counts: [String: Int] = [:]
        for t in titles { counts[t ?? "(no task)", default: 0] += 1 }
        return counts.sorted { $0.value != $1.value ? $0.value > $1.value : $0.key < $1.key }
            .prefix(limit)
            .map { ($0.key, $0.value) }
    }
}
