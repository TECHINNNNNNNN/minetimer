import SwiftUI

struct PaperView: View {
    let mode: PaperMode
    let sections: [PaperSection<TodoItem>]
    let done: [TodoItem]
    let query: String?
    var engine: TimerEngine
    var depth: (TodoItem) -> Int
    var onReorder: (UUID, UUID) -> Void

    private var isEmpty: Bool { sections.allSatisfy(\.items.isEmpty) && done.isEmpty }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 2) {
                        if isEmpty { emptyText }
                        ForEach(Array(sections.enumerated()), id: \.offset) { _, section in
                            if let title = section.title { sectionTitle(title) }
                            ForEach(section.items) { row($0) }
                        }
                        if !done.isEmpty {
                            Divider().padding(.vertical, 4)
                            ForEach(done) { row($0) }
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.bottom, 12)
                }
                .frame(height: 230)
                .onChange(of: sections.flatMap { $0.items.map(\.id) }) { old, new in
                    guard new.count > old.count, let added = new.last(where: { !old.contains($0) }) else { return }
                    withAnimation { proxy.scrollTo(added, anchor: .bottom) }
                }
            }
        }
        .background { ZStack { Theme.paper; Grain() } }
        .overlay(Rectangle().stroke(Theme.paperLine, lineWidth: 1))
        .padding(.bottom, -1)
    }

    private func row(_ item: TodoItem) -> some View {
        TaskRow(item: item, depth: depth(item), engine: engine)
            .id(item.id)
            .draggable(item.id.uuidString)
            .dropDestination(for: String.self) { dropped, _ in
                guard let s = dropped.first, let moving = UUID(uuidString: s) else { return false }
                onReorder(moving, item.id)
                return true
            }
    }

    private var emptyText: some View {
        Text(query != nil ? "nothing matches." : mode == .today ? "nothing yet. type below." : "nothing here.")
            .font(Theme.mono(11))
            .foregroundStyle(Theme.paperInk.opacity(0.4))
            .padding(.vertical, 8)
    }

    private func sectionTitle(_ title: String) -> some View {
        Text(title.uppercased())
            .font(Theme.mono(8, weight: .semibold))
            .tracking(1.5)
            .foregroundStyle(Theme.mist)
            .padding(.top, 10)
            .padding(.bottom, 2)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(headerTitle)
                    .font(Theme.mono(9, weight: .semibold))
                    .tracking(2)
                    .foregroundStyle(Theme.paperInk)
                Spacer()
                if let query, !query.isEmpty {
                    Text("/\(query)").font(Theme.mono(9)).foregroundStyle(Theme.lacquer)
                }
            }
            Rectangle().fill(Theme.paperLine).frame(height: 1)
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
        .padding(.bottom, 6)
    }

    private var headerTitle: String {
        mode == .today
            ? Date.now.formatted(.dateTime.weekday(.wide).day().month(.wide)).uppercased()
            : mode.label.uppercased()
    }
}
