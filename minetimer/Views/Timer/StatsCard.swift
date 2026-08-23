import SwiftUI
import SwiftData

struct StatsCard: View {
    var engine: TimerEngine
    @Query(sort: \FocusSession.start) private var sessions: [FocusSession]

    private var week: [FocusSession] {
        let from = Calendar.current.date(byAdding: .day, value: -6, to: Calendar.current.startOfDay(for: .now))!
        return sessions.filter { $0.start >= from }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                stat("\(days.last?.count ?? 0)", "/ \(engine.dailyGoal) today")
                Spacer()
                stat("\(Streak.days(sessions: sessions.map(\.start), now: .now, calendar: .current))", "day streak")
            }
            bars
            HStack {
                stat("\(week.count)", "this week")
                Spacer()
                stat(FocusTotal.text(seconds: week.reduce(0) { $0 + $1.duration }), "focused")
            }
            topTasks
        }
        .padding(14)
        .frame(width: 230)
        .background { ZStack { Theme.ink; Grain() } }
        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Theme.bronze, lineWidth: 2))
    }

    private func stat(_ big: String, _ small: String) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 4) {
            Text(big).font(Theme.mono(20, weight: .bold)).foregroundStyle(Theme.paper)
            Text(small).font(Theme.mono(8)).foregroundStyle(Theme.mist)
        }
    }

    private var days: [(day: Date, count: Int)] {
        DayCounts.lastDays(7, sessions: sessions.map(\.start), now: .now, calendar: .current)
    }

    private var bars: some View {
        let top = max(engine.dailyGoal, days.map(\.count).max() ?? 1, 1)
        return HStack(alignment: .bottom, spacing: 6) {
            ForEach(days, id: \.day) { d in
                VStack(spacing: 3) {
                    Text(d.count > 0 ? "\(d.count)" : " ")
                        .font(Theme.mono(7)).foregroundStyle(Theme.mist)
                    Rectangle()
                        .fill(d.count >= engine.dailyGoal && engine.dailyGoal > 0 ? Theme.gold : Theme.goldDk)
                        .frame(height: max(2, 40 * CGFloat(d.count) / CGFloat(top)))
                    Text(d.day.formatted(.dateTime.weekday(.narrow)))
                        .font(Theme.mono(7, weight: .bold)).foregroundStyle(Theme.mist)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }

    @ViewBuilder private var topTasks: some View {
        let ranked = TopTasks.ranked(week.map(\.taskTitle), limit: 4)
        if !ranked.isEmpty {
            VStack(alignment: .leading, spacing: 3) {
                ForEach(ranked, id: \.title) { r in
                    HStack {
                        Text(r.title).font(Theme.mono(9)).foregroundStyle(Theme.paper).lineLimit(1)
                        Spacer()
                        Text(String(repeating: "●", count: min(r.count, 10)))
                            .font(Theme.mono(8)).foregroundStyle(Theme.gold)
                    }
                }
            }
            .padding(.top, 2)
        }
    }
}
