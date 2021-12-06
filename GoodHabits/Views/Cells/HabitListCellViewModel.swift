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
        private var date: Date

        var days: [Day] = []

        var statement: String {
            habit.statement ?? ""
        }

        @Published var dayRemainingString = ""

        init (habit: Habit, date: Date) {
            self.habit = habit
            self.date = date
            self.days = Array(habit.days as? Set<Day> ?? [])
                .filter({ day in
                    let lowerBound = getFirstDayOfThisWeek(currentDate: date).midnight()
                    let upperBound = lowerBound.addingTimeInterval(7 * 60 * 60 * 24)
                    return day.date! >= lowerBound && day.date! < upperBound
                })
                .sorted(by: { first, second in
                    first.date! < second.date!
                })
            updateDayRemainingString()
        }

        func getFirstDayOfThisWeek(currentDate: Date) -> Date {
            let firstWeekDay = Calendar.current.firstWeekday

            switch firstWeekDay {
            case 2:
                return currentDate.previous(.monday, considerToday: true)
            case 3:
                return currentDate.previous(.tuesday, considerToday: true)
            case 4:
                return currentDate.previous(.wednesday, considerToday: true)
            case 5:
                return currentDate.previous(.thursday, considerToday: true)
            case 6:
                return currentDate.previous(.friday, considerToday: true)
            case 0:
                return currentDate.previous(.saturday, considerToday: true)
            case 1:
                return currentDate.previous(.sunday, considerToday: true)
            default:
                return currentDate
            }
        }

        func onChange(of: Bool) {
            updateDayRemainingString()
        }

        func getDaysRemaining() -> Int {
            return Array(habit.days as? Set<Day> ?? []).filter { $0.isVisible && !$0.isDone }.count
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
