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
        .background {
            ZStack {
                Theme.paper
                Grain(opacity: 0.05)
            }
        }
        .overlay(Rectangle().stroke(Theme.edge, lineWidth: 2))
        .overlay(alignment: .top) { topRod }
        .padding(.top, 8)
    }

    // The scroll's top rod.
    private var topRod: some View {
        HStack(spacing: 0) {
            Circle().fill(Theme.gold).frame(width: 14, height: 14)
            Rectangle()
                .fill(LinearGradient(colors: [Theme.bronzeLt, Theme.bronze, Theme.edge], startPoint: .top, endPoint: .bottom))
                .frame(height: 12)
            Circle().fill(Theme.gold).frame(width: 14, height: 14)
        }
        .padding(.horizontal, -8)
        .offset(y: -7)
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
            .font(Theme.mono(9, weight: .bold))
            .foregroundStyle(Theme.lacquer.opacity(0.8))
            .padding(.top, 8)
            .padding(.bottom, 2)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("··· \(headerTitle)")
                    .font(Theme.mono(11, weight: .bold))
                    .foregroundStyle(Theme.lacquer)
                Spacer()
                if let query, !query.isEmpty {
                    Text("/\(query)").font(Theme.mono(9)).foregroundStyle(Theme.jadeDk)
                }
            }
            Text(String(repeating: "·", count: 70))
                .font(Theme.mono(8))
                .foregroundStyle(Theme.lacquer.opacity(0.5))
                .lineLimit(1)
        }
        .padding(.horizontal, 16)
        .padding(.top, 18)
        .padding(.bottom, 8)
    }

    private var headerTitle: String {
        mode == .today
            ? Date.now.formatted(.dateTime.weekday(.wide).day().month(.wide)).uppercased()
            : mode.label.uppercased()
    }
}
