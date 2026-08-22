enum TaskSort {
    static func sorted<T>(_ items: [T], priority: (T) -> Int, order: (T) -> Int) -> [T] {
        items.sorted {
            let (pa, pb) = (pinRank(priority($0)), pinRank(priority($1)))
            return pa != pb ? pa > pb : order($0) < order($1)
        }
    }

    private static func pinRank(_ priority: Int) -> Int {
        priority >= 2 ? priority : 0
    }
}
