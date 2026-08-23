import Testing
@testable import minetimer

struct SearchFilterTests {
    @Test func onlySlashIsAQuery() {
        #expect(SearchFilter.query(from: "/Milk ") == "milk")
        #expect(SearchFilter.query(from: "milk") == nil)
    }

    @Test func matchesTitleTagsProject() {
        #expect(SearchFilter.matches(title: "Buy milk", tags: [], project: nil, query: "milk") == true)
        #expect(SearchFilter.matches(title: "fix", tags: ["auth"], project: nil, query: "auth") == true)
        #expect(SearchFilter.matches(title: "fix", tags: [], project: "Web", query: "web") == true)
        #expect(SearchFilter.matches(title: "fix", tags: [], project: nil, query: "milk") == false)
    }

    @Test func everyWordMustMatch() {
        #expect(SearchFilter.matches(title: "fix login", tags: ["auth"], project: nil, query: "login auth") == true)
        #expect(SearchFilter.matches(title: "fix login", tags: [], project: nil, query: "login auth") == false)
    }
}
