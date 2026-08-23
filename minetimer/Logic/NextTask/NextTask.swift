// Which task the timer should grab: the first open, top-level one that isn't the one we just left.
enum NextTask {
    static func pick<T>(_ ordered: [T], isOpen: (T) -> Bool, isTopLevel: (T) -> Bool, excluding: (T) -> Bool) -> T? {
        ordered.first { isOpen($0) && isTopLevel($0) && !excluding($0) }
    }
}
