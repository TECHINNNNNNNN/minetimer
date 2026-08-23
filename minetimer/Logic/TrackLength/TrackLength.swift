import Foundation

// An estimate in pomodoros shown like a track length: 2 × 25 min → "0:50".
enum TrackLength {
    static func text(estimate: Int, workMinutes: Int) -> String? {
        guard estimate > 0 else { return nil }
        let minutes = estimate * workMinutes
        return "\(minutes / 60):" + String(format: "%02d", minutes % 60)
    }
}
