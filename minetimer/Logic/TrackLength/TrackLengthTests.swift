import Testing
@testable import minetimer

struct TrackLengthTests {
    @Test func twoPomodoros() {
        #expect(TrackLength.text(estimate: 2, workMinutes: 25) == "0:50")
    }

    @Test func overAnHour() {
        #expect(TrackLength.text(estimate: 3, workMinutes: 25) == "1:15")
    }

    @Test func noEstimate() {
        #expect(TrackLength.text(estimate: 0, workMinutes: 25) == nil)
    }
}
