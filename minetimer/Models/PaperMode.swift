enum PaperMode: String, CaseIterable {
    case today, upcoming, projects, tags, history

    var label: String {
        switch self {
        case .today: return "Today"
        case .upcoming: return "Upcoming"
        case .projects: return "Projects"
        case .tags: return "Tags"
        case .history: return "History"
        }
    }
}
