import SwiftUI
import SwiftData
import UniformTypeIdentifiers

struct TypewriterView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \TodoItem.order) private var allItems: [TodoItem]
    @Query private var logs: [RoutineLog]
    @State private var engine = TimerEngine.shared
    @State private var draft = ""
    @State private var pressedKey: Character?
    @State private var mode: PaperMode = .today
    @State private var showDone = true
    @State private var lastAdded: TodoItem?
    @AppStorage(SettingsKey.currentEra) private var era = Eras.defaultName
    @FocusState private var focused: Bool

    private var query: String? { SearchFilter.query(from: draft) }
    private var items: [TodoItem] { allItems.filter { !$0.isRoutine } }

    private var routine: [TodoItem] {
        let all = allItems.filter { $0.isRoutine && Eras.name(of: $0.era) == era }
        guard let q = query else { return all }
        return all.filter { SearchFilter.matches(title: $0.title, tags: $0.tags, project: $0.project, query: q) }
    }

    private var eras: [String] { Eras.list(from: allItems.filter(\.isRoutine).map(\.era)) }

    private var routineState: RoutineState {
        RoutineToday.state(logs: logs.map { ($0.itemID, $0.day) }, now: .now, calendar: .current)
    }

    private func toggleRoutine(_ item: TodoItem) {
        let today = Calendar.current.startOfDay(for: .now)
        if let log = logs.first(where: { $0.itemID == item.id && Calendar.current.isDate($0.day, inSameDayAs: today) }) {
            context.delete(log)
            SoundPlayer.shared.play(.space)
        } else {
            context.insert(RoutineLog(itemID: item.id, day: today))
            if engine.activeTask?.id == item.id { engine.activeTask = nil }
            SoundPlayer.shared.play(.enter)
        }
        try? context.save()
    }

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
                      query: query, played: "\(doneToday.count) / \(doneToday.count + open.count) played",
                      routine: routine, routineState: routineState, era: era, eras: eras, onRoutineToggle: toggleRoutine,
                      engine: engine, depth: depth(of:), onReorder: reorder)
                .frame(width: 420)
            bodyShell
        }
        .background { shortcuts }
    }

    private var shortcuts: some View {
        Group {
            Button("") { focused = true }.keyboardShortcut("n", modifiers: .command)
            Button("") { if let t = engine.activeTask { t.isDone = true; t.completedAt = .now; engine.taskFinished(t) } }
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
            statusBar
            inputField
            KeyboardView(pressed: pressedKey)
                .padding(.top, 2)
        }
        .padding(.bottom, 18)
        .frame(width: 420)
        .background { ZStack { Theme.paper; Grain(opacity: 0.05) } }
        .onChange(of: draft) { old, new in keyTyped(old: old, new: new) }
        .onPasteCommand(of: [.plainText]) { paste($0) }
        .onDrop(of: [.fileURL, .plainText], isTargeted: nil) { drop($0) }
    }

    private var statusBar: some View {
        HStack {
            Button { focused = true } label: { Text("+").bold() }
            Spacer()
            Text(mode == .today ? "SIDE A" : mode.label.uppercased())
                .font(Theme.mono(8, weight: .medium)).tracking(2)
            Spacer()
            Menu {
                ForEach(PaperMode.allCases, id: \.self) { m in
                    Button { mode = m } label: {
                        Text(m == mode ? "● \(m.label)" : "   \(m.label)")
                    }
                }
                Divider()
                Menu("Era · \(era)") {
                    ForEach(eras, id: \.self) { e in
                        Button { era = e } label: { Text(e == era ? "● \(e)" : "   \(e)") }
                    }
                }
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
        .font(Theme.mono(10))
        .foregroundStyle(Theme.mist)
        .padding(.horizontal, 20)
        .padding(.top, 2)
    }

    private var inputField: some View {
        TextField("", text: $draft)
            .textFieldStyle(.plain)
            .font(Theme.mono(12))
            .foregroundStyle(Theme.paperInk)
            .focused($focused)
            .onSubmit(addTask)
            .overlay(alignment: .leading) {
                if draft.isEmpty {
                    Text("type the next track   #tag  !!  @tmr  ~2")
                        .font(Theme.mono(10))
                        .foregroundStyle(Theme.mist.opacity(0.7))
                        .lineLimit(1)
                        .allowsHitTesting(false)
                }
            }
            .padding(.vertical, 10)
            .padding(.leading, 10)
            .padding(.trailing, 44)
            .overlay(alignment: .trailing) {
                Text("REC").font(Theme.mono(8, weight: .bold)).tracking(2)
                    .foregroundStyle(focused ? Theme.lacquer : Theme.paperLine)
                    .padding(.trailing, 10)
            }
            .overlay(Rectangle().stroke(Theme.paperInk, lineWidth: 2))
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
        let added = TaskAdder.add(lines: lines, context: context, parent: lastAdded ?? engine.activeTask)
        if let top = added.last(where: { $0.parentID == nil }) { lastAdded = top }
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
