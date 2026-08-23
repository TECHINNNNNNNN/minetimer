import Foundation

enum DateGroups {
    /// Sections by calendar day. `ascending: false` puts the newest day first.
    static func sections<T>(_ items: [T], date: (T) -> Date?, calendar: Calendar, ascending: Bool,
                            title: (Date) -> String) -> [PaperSection<T>] {
        var buckets: [Date: [T]] = [:]
        for item in items {
            guard let d = date(item) else { continue }
            buckets[calendar.startOfDay(for: d), default: []].append(item)
        }
        let days = buckets.keys.sorted(by: ascending ? (<) : (>))
        return days.map { PaperSection(title: title($0), items: buckets[$0]!) }
    }
}
