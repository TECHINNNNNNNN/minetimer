import SwiftUI

struct TaskRow: View {
    @Bindable var item: TodoItem
    var number: Int = 0
    var depth: Int = 0
    var engine: TimerEngine
    var eras: [String] = []
    var routineDone: Bool? = nil
    var streak: Int = 0
    var onRoutineToggle: () -> Void = {}
    @Environment(\.modelContext) private var context
    @State private var hovering = false
    @State private var editing = false
    @State private var editLine = ""
    @State private var showNotes = false
    @FocusState private var editFocused: Bool

    private var isActive: Bool { engine.activeTask?.id == item.id }
    private var isOverdue: Bool { item.dueDate.map { DueLabel.isOverdue($0) } ?? false }

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(spacing: 0) {
                Color.clear.frame(width: CGFloat(depth) * 18)
                if item.isRoutine { routineRing.padding(.trailing, 12) } else { trackNumber.padding(.trailing, 12) }
                priorityBar
                if editing { editor } else { title }
                Spacer(minLength: 10)
                if item.isRoutine, streak > 0 { streakLabel.padding(.trailing, 10) }
                if !item.isDone && !editing { trailing }
                if hovering && !editing { deleteButton } else { Color.clear.frame(width: 14) }
            }
            if showNotes || !item.notes.isEmpty { notes }
        }
        .padding(.vertical, 7)
        .padding(.horizontal, isActive ? 20 : 0)
        .padding(.trailing, 2)
        .background(isActive ? Theme.paperInk : .clear)
        .padding(.horizontal, isActive ? -20 : 0)
        .overlay(alignment: .bottom) {
            if !isActive { Rectangle().fill(Theme.paperLine).frame(height: 1) }
        }
        .contentShape(Rectangle())
        .onHover { hovering = $0 }
        .onTapGesture(count: 2) { beginEdit() }
        .onTapGesture(count: 1) { engine.activeTask = isActive ? nil : item }
        .contextMenu { menu }
    }

    private var priorityBar: some View {
        Rectangle()
            .fill(item.isDone ? .clear : Theme.priority(item.priority))
            .frame(width: 2, height: 12)
            .padding(.trailing, item.priority > 0 && !item.isDone ? 8 : 0)
            .frame(width: item.priority > 0 && !item.isDone ? 10 : 0)
    }

    // The track number is the checkbox: click it to mark played. Done shows the seal.
    private var trackNumber: some View {
        Button { toggleDone() } label: {
            ZStack {
                if item.isDone {
                    Text("完")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(Theme.paper)
                        .frame(width: 16, height: 16)
                        .background(Theme.lacquer)
                        .rotationEffect(.degrees(-6))
                } else {
                    Text(String(format: "%02d", number))
                        .font(Theme.display(18))
                        .foregroundStyle(isActive ? Theme.lacquer : (item.priority == 3 ? Theme.lacquer : Theme.lacquer.opacity(0.85)))
                }
            }
            .frame(width: 28, height: 20, alignment: .leading)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    // Routine items: a ring that fills for today. Tomorrow it's empty again.
    private var routineRing: some View {
        Button { onRoutineToggle() } label: {
            ZStack {
                Circle().stroke(isActive ? Theme.paper : Theme.lacquer, lineWidth: 1.5)
                if routineDone == true { Circle().fill(Theme.lacquer).padding(3) }
            }
            .frame(width: 14, height: 14)
            .frame(width: 28, height: 20, alignment: .leading)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private var streakLabel: some View {
        HStack(spacing: 3) {
            Ellipse().fill(Theme.lacquer).frame(width: 4, height: 7)
            Text("\(streak)").font(Theme.mono(8, weight: .semibold)).foregroundStyle(isActive ? Theme.paper : Theme.lacquer)
        }
    }

    private var title: some View {
        Text(item.title)
            .strikethrough(item.isDone || routineDone == true)
            .font(Theme.mono(12, weight: .medium))
            .foregroundStyle(titleColor)
            .lineLimit(1)
            .truncationMode(.tail)
    }

    private var editor: some View {
        TextField("", text: $editLine)
            .textFieldStyle(.plain)
            .font(Theme.mono(11))
            .foregroundStyle(Theme.paperInk)
            .focused($editFocused)
            .onSubmit(commitEdit)
            .onExitCommand { editing = false }
            .onChange(of: editFocused) { _, f in if !f { commitEdit() } }
            .padding(.horizontal, 4)
            .background(Theme.paperLine.opacity(0.35))
    }

    private var notes: some View {
        TextField("notes…", text: $item.notes, axis: .vertical)
            .textFieldStyle(.plain)
            .font(Theme.mono(9))
            .foregroundStyle(Theme.paperInk.opacity(0.7))
            .lineLimit(1...6)
            .padding(.leading, CGFloat(depth) * 18 + 31)
            .padding(.trailing, 16)
    }

    private var titleColor: Color {
        if isActive { return Theme.paper }
        if item.isDone || routineDone == true { return Theme.creamDim }
        return Theme.paperInk
    }

    private var metaColor: Color { isActive ? Theme.paper.opacity(0.7) : Theme.mist }

    // feat. credits on the left of the length, like a tracklist.
    private var trailing: some View {
        HStack(spacing: 10) {
            HStack(spacing: 6) {
                if !item.isRoutine, let age = TaskAge.label(created: item.createdAt, now: .now, calendar: .current) {
                    Text(age)
                }
                if item.repeatRule != nil { Text("↻") }
                if let d = item.dueDate {
                    Text("due " + DueLabel.text(for: d))
                        .foregroundStyle(isOverdue ? Theme.lacquer : metaColor)
                        .fontWeight(isOverdue ? .bold : .regular)
                }
                if !item.tags.isEmpty || item.project != nil {
                    Text("feat. " + (item.tags + [item.project].compactMap { $0 }).joined(separator: ", "))
                }
            }
            .font(Theme.mono(8, weight: .medium))
            .tracking(1)
            .textCase(.uppercase)
            .foregroundStyle(metaColor)
            if item.pomodoros > 0 || item.estimate > 0 {
                Text(PomodoroDots.text(done: item.pomodoros, estimate: item.estimate))
                    .font(Theme.mono(8))
                    .foregroundStyle(isActive ? Theme.lacquer : Theme.lacquer.opacity(0.8))
            }
            if let len = TrackLength.text(estimate: item.estimate,
                                          workMinutes: UserDefaults.standard.integer(forKey: SettingsKey.workMinutes)) {
                Text(len)
                    .font(Theme.mono(11))
                    .monospacedDigit()
                    .foregroundStyle(isActive ? Theme.paper : Theme.paperInk.opacity(0.8))
            }
        }
        .lineLimit(1)
        .layoutPriority(1)
    }

    private var deleteButton: some View {
        Button { delete() } label: {
            Text("×").font(Theme.mono(11, weight: .bold))
        }
        .buttonStyle(.plain)
        .foregroundStyle(Theme.lacquer)
        .frame(width: 14)
        .padding(.leading, 4)
    }

    @ViewBuilder private var menu: some View {
        Button(isActive ? "Stop focusing" : "Focus on this") { engine.activeTask = isActive ? nil : item }
        Button("Edit") { beginEdit() }
        Button(item.isRoutine ? "Remove from routine" : "Make routine") { item.isRoutine.toggle() }
        if item.isRoutine, eras.count > 1 {
            Menu("Era") {
                ForEach(eras, id: \.self) { e in
                    Button(e == Eras.name(of: item.era) ? "● \(e)" : "   \(e)") { item.era = e == Eras.defaultName ? nil : e }
                }
            }
        }
        Button(showNotes || !item.notes.isEmpty ? "Hide notes" : "Notes") {
            showNotes.toggle()
            if !showNotes { item.notes = "" }
        }
        Divider()
        Menu("Priority") {
            ForEach(0...3, id: \.self) { p in Button(PriorityLabel.name(p)) { item.priority = p } }
        }
        Menu("Due") {
            ForEach(["today", "tmr", "mon", "tue", "wed", "thu", "fri", "sat", "sun"], id: \.self) { w in
                Button(w) { item.dueDate = DueDateParser.date(from: w, now: .now, calendar: .current) }
            }
            Divider()
            Button("none") { item.dueDate = nil }
        }
        Menu("Repeat") {
            Button("daily") { item.repeatRule = .daily }
            Button("weekdays") { item.repeatRule = .weekdays }
            ForEach(["mon", "tue", "wed", "thu", "fri", "sat", "sun"], id: \.self) { w in
                Button("every \(w)") { item.repeatRule = RepeatParser.rule(from: w) }
            }
            Divider()
            Button("none") { item.repeatRule = nil }
        }
        Menu("Estimate") {
            ForEach(0...8, id: \.self) { n in Button(n == 0 ? "none" : "\(n) 🍅") { item.estimate = n } }
        }
        Divider()
        Button("Delete", role: .destructive) { delete() }
    }

    private func beginEdit() {
        editLine = TaskLine.format(title: item.title, priority: item.priority, dueDate: item.dueDate, tags: item.tags,
                                   project: item.project, estimate: item.estimate, repeatRule: item.repeatRule,
                                   calendar: .current)
        editing = true
        NSApp.windows.first { $0.frame.contains(NSEvent.mouseLocation) }?.makeKey()
        Task {
            try? await Task.sleep(for: .milliseconds(50))
            editFocused = true
        }
    }

    private func commitEdit() {
        guard editing else { return }
        editing = false
        let parsed = TaskParser.parse(editLine)
        if !parsed.title.isEmpty { item.apply(parsed) }
    }

    private func toggleDone() {
        item.isDone.toggle()
        item.completedAt = item.isDone ? .now : nil
        if item.isDone { engine.taskFinished(item) }
        if item.isDone, let rule = item.repeatRule {
            let next = NextOccurrence.date(after: max(item.dueDate ?? .now, .now), rule: rule, calendar: .current)
            context.insert(TodoItem(nextOf: item, dueDate: next))
        }
        SoundPlayer.shared.play(item.isDone ? .enter : .space)
    }

    private func delete() {
        if isActive { engine.activeTask = nil }
        context.delete(item)
    }
}
