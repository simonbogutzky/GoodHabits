//
//  HabitListCellViewModel.swift
//  GoodHabits
//
//  Created by Dr. Simon Bogutzky on 26.10.21.
//

import SwiftUI

extension HabitListCell {
    final class HabitListCellViewModel {

        private var habit: Habit
        private var date: Date

        var days: [Day] {
            Array(habit.days as? Set<Day> ?? [])
                        .filter({ day in

                let calendar = Calendar.current
                let dayDateComponents = calendar.dateComponents([.weekOfYear], from: day.date!)
                let dateDateComponents = calendar.dateComponents([.weekOfYear], from: date)
                return dateDateComponents == dayDateComponents
            })
                        .sorted(by: { first, second in
                first.date! < second.date!
            })
        }

        var statement: String {
            habit.statement ?? ""
        }

        init(habit: Habit, date: Date) {
            self.habit = habit
            self.date = date
        }
    }
}
