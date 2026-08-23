import Testing
@testable import minetimer

struct TemplatesTests {
    @Test func templatesEndWhereTypingStarts() {
        #expect(Templates.all.dropLast().allSatisfy { $0.text.hasSuffix(" ") })
        #expect(Templates.all.last?.text == "/")
    }

    @Test func routineTemplateParsesAsRoutine() {
        let p = TaskParser.parse(Templates.all[5].text + "meditate")
        #expect(p.title == "meditate")
        #expect(p.isRoutine == true)
        #expect(p.estimate == 1)
    }
}
