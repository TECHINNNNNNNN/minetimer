import SwiftUI
import SwiftData
import UniformTypeIdentifiers

struct TypewriterView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \TodoItem.order) private var items: [TodoItem]
    @State private var engine = TimerEngine.shared
    @State private var draft = ""
    @State private var pressedKey: Character?
    @State private var mode: PaperMode = .today
    @State private var showDone = true
    @State private var lastAdded: TodoItem?
    @FocusState private var focused: Bool

    private var query: String? { SearchFilter.query(from: draft) }

    private var visible: [TodoItem] {
        guard let q = query else { return items }
        return items.filter { SearchFilter.matches(title: $0.title, tags: $0.tags, project: $0.project, query: q) }
    }

    private var open: [TodoItem] {
        TaskSort.sorted(visible.filter { !$0.isDone }, priority: \.priority, order: \.order)
    }

    private var todayTree: [(item: TodoItem, depth: Int)] {
        let today = open.filter { TodayFilter.isToday(dueDate: $0.dueDate, now: .now, calendar: .current) }
        return TreeOrder.flatten(today, id: \.id, parent: \.parentID)
    }

    private func depth(of item: TodoItem) -> Int {
        mode == .today ? todayTree.first { $0.item.id == item.id }?.depth ?? 0 : 0
    }

    private var doneToday: [TodoItem] {
        visible.filter { $0.isDone && DoneVisibility.isOnPaper(completedAt: $0.completedAt, now: .now, calendar: .current) }
    }

    private var sections: [PaperSection<TodoItem>] {
        switch mode {
        case .today:
            return [PaperSection(title: nil, items: todayTree.map(\.item))]
        case .upcoming:
            let later = open.filter { !TodayFilter.isToday(dueDate: $0.dueDate, now: .now, calendar: .current) }
            return DateGroups.sections(later, date: \.dueDate, calendar: .current, ascending: true) { DueLabel.text(for: $0) }
        case .projects:
            return GroupBy.sections(open, keys: { $0.project.map { [$0] } ?? [] }, title: { "+" + $0 }, fallback: "no project")
        case .tags:
            return GroupBy.sections(open, keys: \.tags, title: { "#" + $0 }, fallback: "no tag")
        case .history:
            let finished = visible.filter(\.isDone)
            return DateGroups.sections(finished, date: \.completedAt, calendar: .current, ascending: false) {
                $0.formatted(.dateTime.weekday(.abbreviated).day().month(.abbreviated))
            }
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            PaperView(mode: mode, sections: sections,
                      done: mode == .today && showDone ? doneToday : [],
                      query: query, engine: engine, depth: depth(of:), onReorder: reorder)
                .frame(width: 360)
            bodyShell
        }
        .background { shortcuts }
    }

    private var shortcuts: some View {
        Group {
            Button("") { focused = true }.keyboardShortcut("n", modifiers: .command)
            Button("") { if let t = engine.activeTask { t.isDone.toggle(); t.completedAt = t.isDone ? .now : nil; engine.activeTask = nil } }
                .keyboardShortcut(.return, modifiers: .command)
            Button("") { if let t = engine.activeTask { engine.activeTask = nil; context.delete(t) } }
                .keyboardShortcut(.delete, modifiers: .command)
            Button("") { step(-1) }.keyboardShortcut(.upArrow, modifiers: .command)
            Button("") { step(1) }.keyboardShortcut(.downArrow, modifiers: .command)
            Button("") { draft = "/"; focused = true }.keyboardShortcut("f", modifiers: .command)
        }
        .opacity(0)
        .frame(width: 0, height: 0)
    }

    private func step(_ delta: Int) {
        let list = sections.flatMap(\.items)
        guard !list.isEmpty else { return }
        let i = list.firstIndex { $0.id == engine.activeTask?.id } ?? (delta > 0 ? -1 : list.count)
        engine.activeTask = list[max(0, min(list.count - 1, i + delta))]
    }

    private var bodyShell: some View {
        VStack(spacing: 10) {
            Rectangle().fill(Color(hex: 0x1A1615)).frame(height: 28)
                .overlay(alignment: .top) {
                    Capsule().fill(Color(hex: 0x3A3432)).frame(width: 300, height: 6).padding(.top, 8)
                }
            statusBar
            inputField
            KeyboardView(pressed: pressedKey)
            Capsule().fill(Theme.paper).frame(width: 140, height: 18)
        }
        .padding(.bottom, 14)
        .frame(width: 420)
        .background(Theme.lacquer)
        .overlay(RoundedRectangle(cornerRadius: 3).stroke(Color(hex: 0x120F0D), lineWidth: 2))
        .onChange(of: draft) { old, new in keyTyped(old: old, new: new) }
        .onPasteCommand(of: [.plainText]) { paste($0) }
        .onDrop(of: [.fileURL, .plainText], isTargeted: nil) { drop($0) }
    }

    private var statusBar: some View {
        HStack {
            Button { focused = true } label: { Text("+").bold() }
            Spacer()
            Text("\(doneToday.count)/\(doneToday.count + open.count) done")
            Spacer()
            Menu {
                ForEach(PaperMode.allCases, id: \.self) { m in
                    Button { mode = m } label: {
                        Text(m == mode ? "● \(m.label)" : "   \(m.label)")
                    }
                }
                Divider()
                Toggle("Show done", isOn: $showDone)
            } label: { Text("≡") }
            .menuStyle(.button)
            .menuIndicator(.hidden)
            .fixedSize()
            Button { MusicPlayer.shared.toggle() } label: {
                Text(MusicPlayer.shared.isPlaying ? "♫" : "♪")
            }
        }
        .buttonStyle(.plain)
        .font(Theme.mono(11))
        .foregroundStyle(Theme.paperInk)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Theme.paper)
        .padding(.horizontal, 20)
    }

    private var inputField: some View {
        TextField("type your plan...  #tag !! @tmr +project ~2 *daily  > subtask  /search", text: $draft)
            .textFieldStyle(.plain)
            .font(Theme.mono(12))
            .foregroundStyle(Theme.paperInk)
            .focused($focused)
            .onSubmit(addTask)
            .padding(10)
            .background(Theme.paper)
            .padding(.horizontal, 20)
    }

    private func keyTyped(old: String, new: String) {
        if new.contains("\n") {
            add(lines: ChecklistLine.lines(from: new))
            draft = ""
            return
        }
        guard new.count > old.count, let c = new.last else { return }
        pressedKey = Character(c.uppercased())
        c == " " ? SoundPlayer.shared.play(.space) : SoundPlayer.shared.playKey()
        Task {
            try? await Task.sleep(for: .milliseconds(90))
            pressedKey = nil
        }
    }

    private func addTask() {
        if query == nil { add(lines: [draft]) }
        draft = ""
    }

    private func add(lines: [String]) {
        var order = (items.map(\.order).max() ?? 0) + 1
        var parent: TodoItem? = lastAdded ?? engine.activeTask
        for line in lines {
            let parsed = TaskParser.parse(line)
            guard !parsed.title.isEmpty else { continue }
            let item = TodoItem(parsed, order: order, parentID: parsed.isChild ? parent?.id : nil)
            context.insert(item)
            if !parsed.isChild { parent = item }
            order += 1
        }
        lastAdded = parent
        SoundPlayer.shared.play(.enter)
    }

    private func reorder(moving: UUID, onto target: UUID) {
        let ids = Reorder.move(items.map(\.id), moving: moving, onto: target)
        let byID = Dictionary(uniqueKeysWithValues: items.map { ($0.id, $0) })
        for (i, id) in ids.enumerated() { byID[id]?.order = i }
    }

    private func paste(_ providers: [NSItemProvider]) {
        for p in providers {
            p.loadDataRepresentation(forTypeIdentifier: UTType.plainText.identifier) { data, _ in
                guard let data, let text = String(data: data, encoding: .utf8) else { return }
                Task { @MainActor in add(lines: ChecklistLine.lines(from: text)) }
            }
        }
    }

    private func drop(_ providers: [NSItemProvider]) -> Bool {
        for p in providers {
            if p.hasItemConformingToTypeIdentifier(UTType.fileURL.identifier) {
                p.loadDataRepresentation(forTypeIdentifier: UTType.fileURL.identifier) { data, _ in
                    guard let data, let url = URL(dataRepresentation: data, relativeTo: nil),
                          let text = try? String(contentsOf: url, encoding: .utf8) else { return }
                    Task { @MainActor in add(lines: ChecklistLine.lines(from: text)) }
                }
            } else {
                paste([p])
            }
        }
        return !providers.isEmpty
    }
}
