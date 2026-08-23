import Testing
@testable import minetimer

struct RepeatParserTests {
    @Test func daily() {
        #expect(RepeatParser.rule(from: "daily") == .daily)
        #expect(RepeatParser.rule(from: "day") == .daily)
    }

    @Test func weekdays() {
        #expect(RepeatParser.rule(from: "weekdays") == .weekdays)
    }

    @Test func weekly() {
        #expect(RepeatParser.rule(from: "mon") == .weekly(weekday: 2))
        #expect(RepeatParser.rule(from: "Sunday") == .weekly(weekday: 1))
    }

    @Test func garbage() {
        #expect(RepeatParser.rule(from: "bob") == nil)
    }
}
