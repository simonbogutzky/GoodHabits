//
//  HabitRowView.swift
//  GoodHabits
//
//  Created by Dr. Simon Bogutzky on 11.08.21.
//

import SwiftUI

struct HabitRowView: View {
    var palette: Color.Palette
    @ObservedObject var habit: Habit
    var date: Date

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(habit.statement ?? "")
                .bold()
                .foregroundColor(palette.neutral700)
            ZStack {
                HStack {
                    ForEach(Array(habit.days as? Set<Day> ?? [])
                                .filter({ day in

                        let calendar = Calendar.current
                        let dayDateComponents = calendar.dateComponents([.weekOfYear], from: day.date!)
                        let dateDateComponents = calendar.dateComponents([.weekOfYear], from: date)
                        return dateDateComponents == dayDateComponents
                    })
                                .sorted(by: { first, second in
                        first.date! < second.date!
                    }), id: \.self) { day in
                        DayCheckBoxView(palette: palette, day: day)
                    }
                }
                Spacer()
                    .frame(height: 22.0)
            }
        }
    }
}

struct HabitRowView_Previews: PreviewProvider {
    static var habit: Habit {
        let viewContext = PersistenceController.preview.container.viewContext
        let calendar = Calendar.current
        let components = DateComponents(
            calendar: calendar,
            timeZone: TimeZone(abbreviation: "GMT"),
            year: 2021,
            month: 9,
            day: 30,
            hour: 16,
            minute: 15
        )
        let item = Habit(context: viewContext, statement: "Do something", created: components.date!)
        return item
    }

    @State static var date = Date().midnight()

    static var previews: some View {
        Group {
            HabitRowView(palette: Color.Palette.blue, habit: habit, date: date)
        }
    }
}
