//
//  HabitListCell.swift
//  GoodHabits
//
//  Created by Dr. Simon Bogutzky on 11.08.21.
//

import SwiftUI

struct HabitListCell: View {
    @EnvironmentObject private var colorPalette: Color.Palette
    var viewModel: HabitListCellViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.statement)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(colorPalette.neutral700)
            ZStack {
                HStack {
                    ForEach(viewModel.days, id: \.self) { day in
                        DayCheckBoxView(day: day)
                    }
                }
                Spacer()
                    .frame(height: 22.0)
            }
        }
        .background(colorPalette.neutral100)
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
            HabitListCell(viewModel: HabitListCell.HabitListCellViewModel(habit: habit, date: date))
                .environmentObject(Color.Palette(color: .blue))
        }
    }
}
