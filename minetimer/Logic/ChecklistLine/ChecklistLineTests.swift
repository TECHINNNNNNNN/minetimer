import Testing
@testable import minetimer

struct ChecklistLineTests {
    @Test func plainLinePassesThrough() {
        #expect(ChecklistLine.strip("buy milk").text == "buy milk")
        #expect(ChecklistLine.strip("buy milk").isDone == false)
    }

    @Test func bulletsAndNumbers() {
        #expect(ChecklistLine.strip("- buy milk").text == "buy milk")
        #expect(ChecklistLine.strip("* buy milk").text == "buy milk")
        #expect(ChecklistLine.strip("12. buy milk").text == "buy milk")
    }

    @Test func checkboxes() {
        #expect(ChecklistLine.strip("- [ ] buy milk").text == "buy milk")
        #expect(ChecklistLine.strip("- [ ] buy milk").isDone == false)
        #expect(ChecklistLine.strip("- [x] buy milk").text == "buy milk")
        #expect(ChecklistLine.strip("- [x] buy milk").isDone == true)
        #expect(ChecklistLine.strip("[X] buy milk").isDone == true)
    }

    @Test func linesKeepIndentSkipBlankAndHeadings() {
        #expect(ChecklistLine.lines(from: "# Plan\n\n- a\n  - b  \n") == ["- a", "  - b"])
    }

    @Test func childDetection() {
        #expect(ChecklistLine.isChild("  - b") == true)
        #expect(ChecklistLine.isChild("\tb") == true)
        #expect(ChecklistLine.isChild("> b") == true)
        #expect(ChecklistLine.isChild("- b") == false)
    }
}
