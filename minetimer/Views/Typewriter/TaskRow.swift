import SwiftUI

struct TaskRow: View {
    @Bindable var item: TodoItem
    var engine: TimerEngine
    @Environment(\.modelContext) private var context

    private var isActive: Bool { engine.activeTask?.id == item.id }

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Button { toggleDone() } label: {
                Image(systemName: item.isDone ? "checkmark.square.fill" : "square")
                    .font(.system(size: 12))
            }
            .buttonStyle(.plain)
            .foregroundStyle(item.isDone ? Theme.jadeDk : Theme.paperInk)

            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .strikethrough(item.isDone)
                    .font(Theme.mono(11, weight: isActive ? .bold : .regular))
                    .foregroundStyle(item.isDone ? Theme.paperInk.opacity(0.4) : Theme.paperInk)
                meta
            }
            Spacer(minLength: 0)
            if isActive {
                Text("▶").font(Theme.mono(9)).foregroundStyle(Theme.lacquer)
            }
        }
        .padding(.vertical, 3)
        .padding(.horizontal, 4)
        .background(isActive ? Theme.gold.opacity(0.18) : .clear)
        .contentShape(Rectangle())
        .onTapGesture { engine.activeTask = isActive ? nil : item }
        .contextMenu {
            Button(isActive ? "Stop focusing" : "Focus on this") { engine.activeTask = isActive ? nil : item }
            Menu("Priority") {
                ForEach(0...3, id: \.self) { p in Button(PriorityLabel.name(p)) { item.priority = p } }
            }
            Divider()
            Button("Delete", role: .destructive) { delete() }
        }
    }

    @ViewBuilder private var meta: some View {
        let parts = metaParts
        if !parts.isEmpty {
            HStack(spacing: 6) {
                ForEach(parts, id: \.text) { p in
                    Text(p.text).font(Theme.mono(8)).foregroundStyle(p.color)
                }
            }
        }
    }

    private var metaParts: [(text: String, color: Color)] {
        var out: [(String, Color)] = []
        if item.priority > 0 { out.append((PriorityLabel.mark(item.priority), Theme.lacquer)) }
        if let d = item.dueDate {
            out.append((DueLabel.text(for: d), DueLabel.isOverdue(d) ? Theme.ember : Theme.paperInk.opacity(0.55)))
        }
        if let p = item.project { out.append(("+" + p, Theme.jadeDk)) }
        out += item.tags.map { ("#" + $0, Theme.paperInk.opacity(0.55)) }
        if item.pomodoros > 0 { out.append((String(repeating: "●", count: min(item.pomodoros, 8)), Theme.gold)) }
        return out
    }

    private func toggleDone() {
        item.isDone.toggle()
        item.completedAt = item.isDone ? .now : nil
        if item.isDone, isActive { engine.activeTask = nil }
        SoundPlayer.shared.play(item.isDone ? .enter : .space)
    }

    private func delete() {
        if isActive { engine.activeTask = nil }
        context.delete(item)
    }
}
