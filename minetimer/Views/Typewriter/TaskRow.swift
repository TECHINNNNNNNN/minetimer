import SwiftUI

struct TaskRow: View {
    @Bindable var item: TodoItem
    var engine: TimerEngine
    @Environment(\.modelContext) private var context
    @State private var hovering = false

    private var isActive: Bool { engine.activeTask?.id == item.id }
    private var isOverdue: Bool { item.dueDate.map { DueLabel.isOverdue($0) } ?? false }

    var body: some View {
        HStack(spacing: 0) {
            priorityBar
            checkbox.padding(.trailing, 8)
            title
            Spacer(minLength: 10)
            if !item.isDone { trailing }
            if hovering { deleteButton } else { Color.clear.frame(width: 14) }
        }
        .padding(.vertical, 4)
        .padding(.trailing, 2)
        .background(isActive ? Theme.gold.opacity(0.18) : .clear)
        .contentShape(Rectangle())
        .onHover { hovering = $0 }
        .onTapGesture { engine.activeTask = isActive ? nil : item }
        .contextMenu { menu }
    }

    private var priorityBar: some View {
        Rectangle()
            .fill(item.isDone ? .clear : Theme.priority(item.priority))
            .frame(width: 3, height: 14)
            .padding(.trailing, 8)
    }

    private var checkbox: some View {
        Button { toggleDone() } label: {
            Image(systemName: item.isDone ? "checkmark.square.fill" : "square")
                .font(.system(size: 12))
        }
        .buttonStyle(.plain)
        .foregroundStyle(item.isDone ? Theme.jadeDk : Theme.paperInk)
    }

    private var title: some View {
        Text(item.title)
            .strikethrough(item.isDone)
            .font(Theme.mono(11, weight: isActive ? .bold : .regular))
            .foregroundStyle(titleColor)
            .lineLimit(1)
            .truncationMode(.tail)
    }

    private var titleColor: Color {
        if item.isDone { return Theme.mist }
        if item.priority == 3 { return Theme.lacquer }
        return Theme.paperInk
    }

    private var trailing: some View {
        HStack(spacing: 8) {
            if let age = TaskAge.label(created: item.createdAt, now: .now, calendar: .current) {
                Text(age).foregroundStyle(Theme.mist)
            }
            if item.repeatRule != nil {
                Text("↻").foregroundStyle(Theme.jadeDk)
            }
            if item.pomodoros > 0 || item.estimate > 0 {
                Text(PomodoroDots.text(done: item.pomodoros, estimate: item.estimate))
                    .foregroundStyle(Theme.gold)
            }
            if let d = item.dueDate {
                Text(DueLabel.text(for: d).uppercased())
                    .foregroundStyle(isOverdue ? Theme.ember : Theme.paperInk.opacity(0.7))
                    .fontWeight(isOverdue ? .bold : .regular)
            }
            if let p = item.project {
                Text("+" + p.uppercased()).foregroundStyle(Theme.jadeDk.opacity(0.8))
            }
            ForEach(item.tags, id: \.self) { t in
                Text(t.uppercased()).foregroundStyle(Theme.paperInk.opacity(0.4))
            }
        }
        .font(Theme.mono(8, weight: .medium))
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
        Menu("Priority") {
            ForEach(0...3, id: \.self) { p in Button(PriorityLabel.name(p)) { item.priority = p } }
        }
        Divider()
        Button("Delete", role: .destructive) { delete() }
    }

    private func toggleDone() {
        item.isDone.toggle()
        item.completedAt = item.isDone ? .now : nil
        if item.isDone, isActive { engine.activeTask = nil }
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
