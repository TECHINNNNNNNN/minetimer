import Foundation

// A routine belongs to an era. Items without one belong to the default era.
enum Eras {
    static let defaultName = "daily"

    static func normalize(_ raw: String) -> String? {
        let s = raw.trimmingCharacters(in: .whitespaces).lowercased()
        return s.isEmpty ? nil : s
    }

    static func name(of era: String?) -> String { era ?? defaultName }

    static func list(from eras: [String?]) -> [String] {
        let names = Set(eras.map(name(of:))).union([defaultName])
        return names.sorted { a, b in
            if a == defaultName { return true }
            if b == defaultName { return false }
            return a < b
        }
    }
}
