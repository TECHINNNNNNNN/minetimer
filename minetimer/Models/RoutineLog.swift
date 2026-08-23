import Foundation
import SwiftData

// One row per routine item per day it was completed.
@Model
final class RoutineLog {
    var itemID: UUID
    var day: Date

    init(itemID: UUID, day: Date) {
        self.itemID = itemID
        self.day = day
    }
}
