import SwiftUI
import SwiftData
import UniformTypeIdentifiers

struct TypewriterView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \TodoItem.order) private var items: [TodoItem]
    @State private var engine = TimerEngine.shared
    @State private var draft = ""
    @State private var pressedKey: Character?
    @State private var showDone = true
    @FocusState private var focused: Bool

    private var open: [TodoItem] { items.filter { !$0.isDone } }
    private var done: [TodoItem] { items.filter { $0.isDone } }

    var body: some View {
        VStack(spacing: 0) {
            PaperView(open: open, done: done, showDone: $showDone, engine: engine)
                .frame(width: 360)
            bodyShell
        }
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
            Text("\(done.count)/\(items.count) done")
            Spacer()
            Button { showDone.toggle() } label: { Text("≡") }
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
        TextField("type your plan...  #tag !! @tmr +project ~2", text: $draft)
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
        add(lines: [draft])
        draft = ""
    }

    private func add(lines: [String]) {
        var order = (items.map(\.order).max() ?? 0) + 1
        for line in lines {
            let parsed = TaskParser.parse(line)
            guard !parsed.title.isEmpty else { continue }
            context.insert(TodoItem(parsed, order: order))
            order += 1
        }
        SoundPlayer.shared.play(.enter)
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
