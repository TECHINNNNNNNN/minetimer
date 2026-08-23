import Foundation

// Seven-star lamps: a finished session lights one, an abandoned one gutters out.
enum LampStates {
    static func states(goal: Int, lit: Int, guttered: Int) -> [LampState] {
        let count = max(goal, lit + guttered)
        return (0..<count).map { i in
            if i < lit { return .lit }
            if i < lit + guttered { return .guttered }
            return .unlit
        }
    }
}
