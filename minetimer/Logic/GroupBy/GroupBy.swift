enum GroupBy {
    /// Groups items by every key they carry, sections sorted by key. Items with no key go last under `fallback`.
    static func sections<T, K: Hashable & Comparable>(
        _ items: [T], keys: (T) -> [K], title: (K) -> String, fallback: String
    ) -> [PaperSection<T>] {
        var buckets: [K: [T]] = [:]
        var orphans: [T] = []
        for item in items {
            let ks = keys(item)
            if ks.isEmpty { orphans.append(item) }
            for k in ks { buckets[k, default: []].append(item) }
        }
        var out = buckets.keys.sorted().map { PaperSection(title: title($0), items: buckets[$0]!) }
        if !orphans.isEmpty { out.append(PaperSection(title: fallback, items: orphans)) }
        return out
    }
}
