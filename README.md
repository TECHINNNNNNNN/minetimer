# minetimer

A Pomodoro timer and to-do list for macOS that floats over everything you're doing.

- **Yak timer** — a pixel Thai temple guardian watches you work. Click his belly to start.
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
