// What the + menu offers. Syntax first, then you type the name after it.
enum Templates {
    static let all: [InputTemplate] = [
        InputTemplate(title: "Track", text: "~1 "),
        InputTemplate(title: "Track due tomorrow", text: "@tmr ~1 "),
        InputTemplate(title: "Urgent track", text: "!!! @today ~1 "),
        InputTemplate(title: "Subtask of the last track", text: "> "),
        InputTemplate(title: "Tagged, in a project", text: "#tag +project ~1 "),
        InputTemplate(title: "Routine item", text: "*routine ~1 "),
        InputTemplate(title: "Routine item in another era", text: "*routine:era ~1 "),
        InputTemplate(title: "Repeats every weekday", text: "*weekdays "),
        InputTemplate(title: "Repeats every Monday", text: "*mon "),
        InputTemplate(title: "Search", text: "/"),
    ]

    static let syntax: [(String, String)] = [
        ("#tag", "tag"),
        ("+name", "project"),
        ("! !! !!!", "priority"),
        ("@today @tmr @mon…@sun @2026-09-01", "due"),
        ("~2", "estimate, in sessions"),
        ("*daily *weekdays *mon", "repeat"),
        ("*routine  *routine:era", "routine"),
        ("> text", "subtask of the last track"),
        ("/text", "search"),
    ]

    static let shortcuts: [(String, String)] = [
        ("⌃⌥N", "quick add from anywhere"),
        ("⌘N", "jump to the field"),
        ("⌘F", "search"),
        ("⌘↑ ⌘↓", "move the playing track"),
        ("⌘↩", "mark it played"),
        ("⌘⌫", "delete it"),
        ("double-click", "edit a track"),
        ("drag", "reorder"),
    ]
}
