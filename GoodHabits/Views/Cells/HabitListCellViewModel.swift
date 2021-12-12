//
//  HabitListCellViewModel.swift
//  GoodHabits
//
//  Created by Dr. Simon Bogutzky on 26.10.21.
//

import SwiftUI

extension HabitListCell {
    final class HabitListCellViewModel: HasToggle, ObservableObject {

        private var habit: Habit

        var days: [Day?] = [Day?](repeating: nil, count: 7)
        var statement: String {
            habit.statement ?? ""
        }

        @Published var dayRemainingString = ""

        init (habit: Habit, date: Date) {
            self.habit = habit
            self.createDays(for: date)
            self.updateDayRemainingString()
        }

        func onChange(of: Bool) {
            updateDayRemainingString()
        }

        private func createDays(for date: Date) {
            var days = [Day?](repeating: nil, count: 7)

            let firstDayOfThisWeekMidnight = getFirstDayOfThisWeek(date: date).midnight()
            let habitDays = Array(habit.days as? Set<Day> ?? [])

            for index in 0..<7 {
                let current = firstDayOfThisWeekMidnight.addingTimeInterval(TimeInterval(index * 86400))
                for habitDay in habitDays where habitDay.date == current {
                    days[index] = habitDay
                }
            }

            self.days = days
        }

        private func getFirstDayOfThisWeek(date: Date) -> Date {
            let firstWeekDay = Calendar.current.firstWeekday

            switch firstWeekDay {
            case 2:
                return date.previous(.monday, considerToday: true)
            case 3:
                return date.previous(.tuesday, considerToday: true)
            case 4:
                return date.previous(.wednesday, considerToday: true)
            case 5:
                return date.previous(.thursday, considerToday: true)
            case 6:
                return date.previous(.friday, considerToday: true)
            case 0:
                return date.previous(.saturday, considerToday: true)
            case 1:
                return date.previous(.sunday, considerToday: true)
            default:
                return date
            }
        }

        private func getDaysRemaining() -> Int {
            return Array(habit.days as? Set<Day> ?? []).filter { !$0.isExcluded && !$0.isDone }.count
        }

        private func updateDayRemainingString() {
            let daysRemaining = getDaysRemaining()
            if daysRemaining < 1 {
                dayRemainingString = NSLocalizedString("Done!", comment: "")
            } else
            if daysRemaining == 1 {
                dayRemainingString = String(
                    format: NSLocalizedString("%@ day left", comment: ""), "\(String(format: "%02d", daysRemaining))")
            } else {
                dayRemainingString = String(
                    format: NSLocalizedString("%@ days left", comment: ""), "\(String(format: "%02d", daysRemaining))")
            }
        }
    }
}
