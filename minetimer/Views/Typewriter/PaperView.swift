import SwiftUI

struct PaperView: View {
    let open: [TodoItem]
    let done: [TodoItem]
    @Binding var showDone: Bool
    var engine: TimerEngine

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 2) {
                        if open.isEmpty && (done.isEmpty || !showDone) {
                            Text("nothing yet. type below.")
                                .font(Theme.mono(11))
                                .foregroundStyle(Theme.paperInk.opacity(0.4))
                                .padding(.vertical, 8)
                        }
                        ForEach(open) { TaskRow(item: $0, engine: engine).id($0.id) }
                        if showDone, !done.isEmpty {
                            Divider().padding(.vertical, 4)
                            ForEach(done) { TaskRow(item: $0, engine: engine).id($0.id) }
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.bottom, 12)
                }
                .frame(height: 230)
                .onChange(of: open.map(\.id)) { old, new in
                    guard new.count > old.count, let added = new.last(where: { !old.contains($0) }) else { return }
                    withAnimation { proxy.scrollTo(added, anchor: .bottom) }
                }
            }
        }
        .background(Theme.paper)
        .overlay(Rectangle().stroke(Color(hex: 0x120F0D), lineWidth: 2))
        .padding(.bottom, -2)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("··· \(Date.now.formatted(.dateTime.weekday(.wide).day().month(.wide)).uppercased())")
                .font(Theme.mono(11, weight: .bold))
                .foregroundStyle(Theme.lacquer)
            Text(String(repeating: "·", count: 70))
                .font(Theme.mono(8))
                .foregroundStyle(Theme.lacquer.opacity(0.5))
                .lineLimit(1)
        }
        .padding(.horizontal, 16)
        .padding(.top, 14)
        .padding(.bottom, 8)
    }
}
