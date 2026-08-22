import Testing
@testable import minetimer

struct ClockFormatTests {
    @Test func formatsMinutesAndSeconds() {
        #expect(ClockFormat.mmss(1500) == "25:00")
        #expect(ClockFormat.mmss(61) == "01:01")
        #expect(ClockFormat.mmss(0) == "00:00")
    }

    @Test func roundsUpPartialSeconds() {
        #expect(ClockFormat.mmss(59.2) == "01:00")
    }

    @Test func minutesLeftRoundsUp() {
        #expect(ClockFormat.minutesLeft(1500) == 25)
        #expect(ClockFormat.minutesLeft(1441) == 25)
        #expect(ClockFormat.minutesLeft(1) == 1)
        #expect(ClockFormat.minutesLeft(-5) == 0)
    }
}
