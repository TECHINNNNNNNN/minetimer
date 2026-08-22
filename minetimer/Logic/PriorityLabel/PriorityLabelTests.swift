import Testing
@testable import minetimer

struct PriorityLabelTests {
    @Test func marks() {
        #expect(PriorityLabel.mark(0) == "")
        #expect(PriorityLabel.mark(3) == "!!!")
        #expect(PriorityLabel.mark(9) == "!!!")
    }

    @Test func names() {
        #expect(PriorityLabel.name(0) == "none")
        #expect(PriorityLabel.name(2) == "!! medium")
    }
}
