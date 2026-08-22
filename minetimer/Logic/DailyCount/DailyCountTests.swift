import Foundation
import Testing
@testable import minetimer

struct DailyCountTests {
    @Test func keyUsesDate() {
        let d = Calendar(identifier: .gregorian).date(from: DateComponents(year: 2026, month: 8, day: 22))!
        #expect(DailyCount().key(for: d) == "completed:2026-08-22")
    }

    @Test func roundTripsThroughDefaults() {
        let defaults = UserDefaults(suiteName: "DailyCountTests")!
        defaults.removePersistentDomain(forName: "DailyCountTests")
        let counter = DailyCount(defaults: defaults, now: { Date(timeIntervalSince1970: 0) })

        #expect(counter.load() == 0)
        counter.save(5)
        #expect(counter.load() == 5)
    }
}
