import Testing
@testable import minetimer

struct FocusTotalTests {
    @Test func formats() {
        #expect(FocusTotal.text(seconds: 0) == "0m")
        #expect(FocusTotal.text(seconds: 25 * 60) == "25m")
        #expect(FocusTotal.text(seconds: 120 * 60) == "2h")
        #expect(FocusTotal.text(seconds: 200 * 60) == "3h 20m")
    }
}
