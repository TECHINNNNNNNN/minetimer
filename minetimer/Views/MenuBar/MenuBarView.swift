import SwiftUI

// The panel that drops from 孔明 in the menu bar.
struct MenuBarView: View {
    @State private var engine = TimerEngine.shared
    @AppStorage(SettingsKey.showTimerWidget) private var showTimer = true
    @AppStorage(SettingsKey.showTypewriterWidget) private var showTypewriter = true
    @AppStorage(SettingsKey.windowMode) private var windowMode = WindowMode.desktop.rawValue
    @AppStorage(SettingsKey.quickAddHotKey) private var hotKey = HotKeyChoice.ctrlOptN.rawValue
    @AppStorage(SettingsKey.currentEra) private var era = Eras.defaultName
    @Environment(\.openSettings) private var openSettings

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header
            hairline
            transport
            hairline
            row("Add task", detail: hotKeyLabel) { (NSApp.delegate as? AppDelegate)?.toggleQuickAdd() }
            row("Settings") { NSApp.activate(ignoringOtherApps: true); openSettings() }
            hairline
            widgets
            hairline
            files
            hairline
            HStack {
                Text("minetimer").font(Theme.mono(8)).foregroundStyle(Theme.mist)
                Spacer()
                Button("QUIT") { NSApp.terminate(nil) }
                    .buttonStyle(.plain)
                    .font(Theme.mono(8, weight: .bold)).tracking(1.5)
                    .foregroundStyle(Theme.mist)
                    .keyboardShortcut("q")
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
        .frame(width: 264)
        .background { ZStack { Theme.paper; Grain(opacity: 0.05) } }
    }

    private var hotKeyLabel: String {
        let c = HotKeyChoice(rawValue: hotKey) ?? .ctrlOptN
        return c == .off ? "" : c.label
    }

    private var header: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(engine.phase.label.uppercased())
                .font(Theme.mono(9, weight: .semibold)).tracking(2)
                .foregroundStyle(engine.isRunning ? Theme.lacquer : Theme.mist)
            Spacer()
            Text("\(engine.completedToday) / \(engine.dailyGoal)")
                .font(Theme.display(18))
                .foregroundStyle(Theme.paperInk)
            Text("TODAY")
                .font(Theme.mono(8, weight: .medium)).tracking(1.5)
                .foregroundStyle(Theme.mist)
        }
        .padding(.horizontal, 16)
        .padding(.top, 14)
        .padding(.bottom, 10)
    }

    private var transport: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text(engine.activeTask?.title.uppercased() ?? "FREE PLAY")
                    .font(Theme.display(14))
                    .foregroundStyle(engine.activeTask == nil ? Theme.mist : Theme.paperInk)
                    .lineLimit(1)
                Text(engine.clock)
                    .font(Theme.display(26))
                    .foregroundStyle(Theme.paperInk)
                    .contentTransition(.numericText())
            }
            Spacer()
            Button { engine.toggle() } label: {
                Text(engine.isRunning ? "⏸" : "▶")
                    .font(.system(size: 15))
                    .frame(width: 34, height: 34)
                    .background(Circle().fill(Theme.paperInk))
                    .foregroundStyle(Theme.paper)
            }
            Button { engine.skip() } label: {
                Image(systemName: "forward.end")
                    .font(.system(size: 11, weight: .semibold))
                    .frame(width: 26, height: 26)
                    .foregroundStyle(Theme.mist)
            }
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }

    private var widgets: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 14) {
                toggleChip("TIMER", on: $showTimer)
                toggleChip("TYPER", on: $showTypewriter)
                Spacer()
            }
            HStack(spacing: 6) {
                ForEach(WindowMode.allCases, id: \.rawValue) { m in
                    Button {
                        windowMode = m.rawValue
                    } label: {
                        Text(m.label.uppercased())
                            .font(Theme.mono(7, weight: .semibold)).tracking(1)
                            .padding(.horizontal, 7).padding(.vertical, 4)
                            .background(windowMode == m.rawValue ? Theme.paperInk : .clear)
                            .foregroundStyle(windowMode == m.rawValue ? Theme.paper : Theme.mist)
                            .overlay(Rectangle().stroke(Theme.paperLine, lineWidth: 1))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }

    private var files: some View {
        HStack(spacing: 0) {
            Text("TASKS FILE")
                .font(Theme.mono(7, weight: .semibold)).tracking(1.5)
                .foregroundStyle(Theme.mist)
            Spacer()
            HStack(spacing: 12) {
                Button("MD↓") { TaskFiles.exportMarkdown() }
                Button("JSON↓") { TaskFiles.exportJSON() }
                Button("IMPORT") { TaskFiles.importFile() }
            }
            .buttonStyle(.plain)
            .font(Theme.mono(8, weight: .bold)).tracking(1)
            .foregroundStyle(Theme.lacquer)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }

    private func row(_ title: String, detail: String = "", action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Text(title.uppercased())
                    .font(Theme.mono(9, weight: .medium)).tracking(1.5)
                    .foregroundStyle(Theme.paperInk)
                Spacer()
                Text(detail).font(Theme.mono(9)).foregroundStyle(Theme.mist)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 9)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private func toggleChip(_ label: String, on: Binding<Bool>) -> some View {
        Button { on.wrappedValue.toggle() } label: {
            HStack(spacing: 5) {
                Rectangle()
                    .fill(on.wrappedValue ? Theme.lacquer : .clear)
                    .frame(width: 8, height: 8)
                    .overlay(Rectangle().stroke(on.wrappedValue ? Theme.lacquer : Theme.mist, lineWidth: 1))
                Text(label).font(Theme.mono(8, weight: .semibold)).tracking(1)
                    .foregroundStyle(Theme.paperInk)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private var hairline: some View {
        Rectangle().fill(Theme.paperLine).frame(height: 1).padding(.horizontal, 12)
    }
}
