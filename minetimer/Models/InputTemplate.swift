struct InputTemplate: Identifiable {
    let title: String
    let text: String
    var id: String { title }
}
