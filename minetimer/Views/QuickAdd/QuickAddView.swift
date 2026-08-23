import SwiftUI
import SwiftData

struct QuickAddView: View {
    var onDone: () -> Void
    @Environment(\.modelContext) private var context
    @State private var draft = ""
    @FocusState private var focused: Bool

    var body: some View {
        HStack(spacing: 10) {
            Text("ยักษ์").font(Theme.mono(13, weight: .bold)).foregroundStyle(Theme.lacquer)
            TextField("new task...  #tag !! @tmr +project ~2", text: $draft)
                .textFieldStyle(.plain)
                .font(Theme.mono(13))
                .foregroundStyle(Theme.paperInk)
                .focused($focused)
                .onSubmit(submit)
                .onExitCommand { draft = ""; onDone() }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .frame(width: 460)
        .background(Theme.paper)
        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color(hex: 0x120F0D), lineWidth: 2))
        .onReceive(NotificationCenter.default.publisher(for: QuickAddPanel.didShow)) { _ in
            draft = ""
            focused = true
        }
        .onChange(of: draft) { old, new in
            if new.contains(where: \.isNewline) { submit(); return }
            if new.count > old.count { SoundPlayer.shared.playKey() }
        }
    }

    private func submit() {
        let line = draft.filter { !$0.isNewline }.trimmingCharacters(in: .whitespaces)
        if !line.isEmpty {
            TaskAdder.add(lines: [line], context: context)
            SoundPlayer.shared.play(.enter)
        }
        draft = ""
        onDone()
    }
}
