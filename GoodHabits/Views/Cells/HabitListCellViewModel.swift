//
//  HabitListCellViewModel.swift
//  GoodHabits
//
//  Created by Dr. Simon Bogutzky on 26.10.21.
//

import SwiftUI

extension HabitListCell {
    final class HabitListCellViewModel: ObservableObject {

        private var habit: Habit
        private var date: Date

        @Published var days: [Day] = []
        @Published var dayRemainingString = ""

        var statement: String {
            habit.statement ?? ""
        }

        init (habit: Habit, date: Date) {
            self.habit = habit
            self.date = date

            self.days = Array(habit.days as? Set<Day> ?? [])
                .filter({ day in
                    let calendar = Calendar.current
                    let dayDateComponents = calendar.dateComponents([.weekOfYear, .year],
                                                                    from: getFirstDayOfThisWeek(currentDate:
                                                                                                    day.date!))
                    let dateDateComponents = calendar.dateComponents([.weekOfYear, .year], from: date)
                    return dateDateComponents == dayDateComponents
                })
                .sorted(by: { first, second in
                    first.date! < second.date!
                })
            dayDidUpdated()
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

        func getDaysRemaining() -> Int {
            return Array(habit.days as? Set<Day> ?? []).filter { $0.isVisible && !$0.isDone }.count
        }

        func dayDidUpdated() {
            let daysRemaining = getDaysRemaining()
            if daysRemaining == 1 {
                dayRemainingString = String(
                    format: NSLocalizedString("%@ day left", comment: ""), "\(String(format: "%02d", daysRemaining))")
            }
            dayRemainingString = String(
                format: NSLocalizedString("%@ days left", comment: ""), "\(String(format: "%02d", daysRemaining))")
        }
    }
}
