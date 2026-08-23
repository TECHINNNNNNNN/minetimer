import Foundation

// Seven lamps, always seven. Each stands for a seventh of the day's goal; its flame grows as that share is earned.
enum LampStates {
    static let count = 7

    static func fills(goal: Int, lit: Int) -> [Double] {
        let share = Double(max(goal, 1)) / Double(count)
        return (0..<count).map { i in
            let earned = Double(lit) - Double(i) * share
            return min(1, max(0, earned / share))
        }
    }
}
