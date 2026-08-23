import SwiftUI

// The back cover: a tracklist.
struct PaperView: View {
    let mode: PaperMode
    let sections: [PaperSection<TodoItem>]
    let done: [TodoItem]
    let query: String?
    let played: String
    var routine: [TodoItem] = []
    var routineState = RoutineState()
    var onRoutineToggle: (TodoItem) -> Void = { _ in }
    var engine: TimerEngine
    var depth: (TodoItem) -> Int
    var onReorder: (UUID, UUID) -> Void

    private var isEmpty: Bool { sections.allSatisfy(\.items.isEmpty) && done.isEmpty }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        if mode == .today, !routine.isEmpty {
                            sectionTitle("routine")
                            ForEach(routine) { item in
                                TaskRow(item: item, depth: 0, engine: engine,
                                        routineDone: routineState.doneToday.contains(item.id),
                                        streak: routineState.streaks[item.id] ?? 0,
                                        onRoutineToggle: { onRoutineToggle(item) })
                                    .id(item.id)
                            }
                            if !isEmpty { sectionTitle("tracks") }
                        }
                        if isEmpty { emptyText }
                        ForEach(Array(sections.enumerated()), id: \.offset) { _, section in
                            if let title = section.title { sectionTitle(title) }
                            ForEach(Array(section.items.enumerated()), id: \.element.id) { i, item in
                                row(item, number: i + 1)
                            }
                        }
                        ForEach(Array(done.enumerated()), id: \.element.id) { i, item in
                            row(item, number: i + 1)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                }
                .frame(height: 236)
                .onChange(of: sections.flatMap { $0.items.map(\.id) }) { old, new in
                    guard new.count > old.count, let added = new.last(where: { !old.contains($0) }) else { return }
                    withAnimation { proxy.scrollTo(added, anchor: .bottom) }
                }
            }
        }
        .background { ZStack { Theme.paper; Grain(opacity: 0.05) } }
    }

    private func row(_ item: TodoItem, number: Int) -> some View {
        TaskRow(item: item, number: number, depth: depth(item), engine: engine)
            .id(item.id)
            .draggable(item.id.uuidString)
            .dropDestination(for: String.self) { dropped, _ in
                guard let s = dropped.first, let moving = UUID(uuidString: s) else { return false }
                onReorder(moving, item.id)
                return true
            }
    }

    private var emptyText: some View {
        Text(query != nil ? "nothing matches." : mode == .today ? "no tracks yet. type one below." : "nothing here.")
            .font(Theme.mono(11))
            .foregroundStyle(Theme.mist)
            .padding(.vertical, 12)
    }

    private func sectionTitle(_ title: String) -> some View {
        Text(title.uppercased())
            .font(Theme.mono(8, weight: .semibold))
            .tracking(2)
            .foregroundStyle(Theme.lacquer)
            .padding(.top, 12)
            .padding(.bottom, 4)
    }

    private var header: some View {
        HStack(alignment: .bottom) {
            Text(headerTitle)
                .font(Theme.display(34))
                .foregroundStyle(Theme.paperInk)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
            VStack(alignment: .trailing, spacing: 3) {
                if let query, !query.isEmpty {
                    Text("/\(query)").font(Theme.mono(9)).foregroundStyle(Theme.lacquer)
                }
                Text(played.uppercased())
                    .font(Theme.mono(8, weight: .medium))
                    .tracking(2)
                    .foregroundStyle(Theme.mist)
            }
            .padding(.bottom, 5)
        }
        .padding(.horizontal, 20)
        .padding(.top, 18)
        .padding(.bottom, 10)
        .overlay(alignment: .bottom) { Rectangle().fill(Theme.paperInk).frame(height: 2).padding(.horizontal, 20) }
        .padding(.bottom, 4)
    }

    private var headerTitle: String {
        if mode == .today {
            let d = Date.now
            return d.formatted(.dateTime.weekday(.wide)) + "\n" + d.formatted(.dateTime.day().month(.abbreviated))
        }
        return mode.label
    }
}
