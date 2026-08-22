import Foundation
import UserNotifications

enum Notifier {
    static func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }

    static func phaseEnded(_ finished: Phase, next: Phase, completedToday: Int, goal: Int, taskTitle: String?) {
        guard UserDefaults.standard.bool(forKey: SettingsKey.notificationsEnabled) else { return }
        let c = UNMutableNotificationContent()
        if finished == .work {
            c.title = "Focus done · \(completedToday)/\(goal) today"
            c.body = next == .longBreak ? "Long break earned. Go stretch." : "Short break."
        } else {
            c.title = "Break's over"
            c.body = taskTitle.map { "Back to: \($0)" } ?? "Back to work."
        }
        UNUserNotificationCenter.current().add(
            UNNotificationRequest(identifier: UUID().uuidString, content: c, trigger: nil))
    }
}
