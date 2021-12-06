//
//  HabitListCell.swift
//  GoodHabits
//
//  Created by Dr. Simon Bogutzky on 11.08.21.
//

import SwiftUI

struct HabitListCell: View {
    @EnvironmentObject private var colorPalette: Color.Palette
    @ObservedObject var viewModel: HabitListCellViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(viewModel.statement)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(colorPalette.neutral700)
                .padding(.bottom, 4)

            ZStack {
                HStack {
                    ForEach(viewModel.days, id: \.self) { day in
                        if day != nil {
                            DayCheckBoxView(day: day!, hasToggle: viewModel)
                        } else {
                            Placeholder()
                        }
                    }
                    .frame(height: 32)
                }
            }
            HStack {
                Spacer()
                Text(viewModel.dayRemainingString)
                    .font(.caption)
                    .monospacedDigit()
                    .foregroundColor(colorPalette.neutral700)
            }
            .padding(.horizontal)
        }
        .background(colorPalette.neutral100)
    }
}

private struct Placeholder: View {
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Image(systemName: "circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 22, height: 22)
                    .foregroundColor(.clear)
                    .padding(.bottom, -4)
                Circle()
                    .fill()
                    .foregroundColor(.clear)
                    .frame(width: 4, height: 4)
            }
            Spacer()
        }
    }
}

struct HabitRowView_Previews: PreviewProvider {
    static let components = DateComponents(
        calendar: Calendar.current,
        timeZone: TimeZone(abbreviation: "GMT"),
        year: 2021,
        month: 9,
        day: 27,
        hour: 16,
        minute: 15
    )

    static var habit: Habit {
        let viewContext = PersistenceController.preview.container.viewContext
        let habit = Habit(context: viewContext, statement: "Do something", created: components.date!)
        let days = Array(habit.days as? Set<Day> ?? []).sorted { $0.date! < $1.date! }
        days[0].isDone = true
        return habit
    }

    @State static var date = components.date!.midnight()

    static var previews: some View {
        Group {
            HabitListCell(viewModel: HabitListCell.HabitListCellViewModel(habit: habit, date: date))
                .environmentObject(Color.Palette(color: .blue))
        }
    }
}
