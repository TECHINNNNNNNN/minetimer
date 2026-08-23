# minetimer

A Pomodoro timer and to-do list for macOS that floats over everything you're doing.

- **Kongming timer** — a pixel Zhuge Liang (孔明) in a long coat watches you work. Click the war drum to start.
- **Typewriter** — type a task, hit enter, hear the keys. `#tag`, `!!` priority, `@tmr` due date, `+project`.
- Daily goal, long breaks, auto-start, notifications, local music folder player.
- Menu bar control, everything local, no accounts.

## Build

Needs Xcode 16+ and [xcodegen](https://github.com/yonaskolb/XcodeGen) (`brew install xcodegen`).

```
make run     # build and launch
make test    # unit tests
make release # zip for sharing
```

MIT.
