import Foundation

struct DailyCount {
    var defaults: UserDefaults = .standard
    var now: () -> Date = { .now }

    func key(for date: Date) -> String {
        let f = DateFormatter()
        f.calendar = Calendar(identifier: .gregorian)
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "yyyy-MM-dd"
        return "completed:" + f.string(from: date)
    }

    func load() -> Int { defaults.integer(forKey: key(for: now())) }

    func save(_ count: Int) { defaults.set(count, forKey: key(for: now())) }
}
