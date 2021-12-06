//
//  DayCheckBoxView.swift
//  GoodHabits
//
//  Created by Dr. Simon Bogutzky on 12.08.21.
//

import SwiftUI

protocol HasToggle {
    func onChange(of: Bool)
}

struct DayCheckBoxView: View {

    @ObservedObject var day: Day
    var hasToggle: HasToggle

    var body: some View {
        if day.isVisible {
            Toggle("", isOn: $day.isDone)
                .onChange(of: day.isDone) { isDone in
                    hasToggle.onChange(of: isDone)
                }
                .toggleStyle(CheckboxStyle(isToday: day.date! == Date().midnight()))
        } else {
            Toggle("", isOn: $day.isDone)
                .toggleStyle(CheckboxStyle()).hidden()
        }
    }
}

private struct CheckboxStyle: ToggleStyle {

    @EnvironmentObject private var colorPalette: Color.Palette
    var isToday = false

    func makeBody(configuration: Self.Configuration) -> some View {

        return HStack {

            configuration.label

            Spacer()

            VStack {
                Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                    .symbolRenderingMode(.palette)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 22, height: 22)
                    .foregroundStyle(
                        configuration.isOn ? colorPalette.neutral100 :
                            isToday ? colorPalette.secondary300 : colorPalette.primary300,
                        isToday ? colorPalette.secondary500 :colorPalette.primary500,
                        isToday ? colorPalette.secondary500 :colorPalette.primary500
                    )
                    .font(.system(size: 20, weight: .regular))
                    .onTapGesture {
                        configuration.isOn.toggle()
                        if configuration.isOn {
                            HapticManager.playSuccess()
                        }
                    }
                    .padding(.bottom, -4)
                Circle()
                    .fill()
                    .foregroundColor(!isToday ? .clear : colorPalette.secondary500)
                    .frame(width: 4, height: 4)
            }

            Spacer()
        }
    }
}

struct DayCheckBoxView_Previews: PreviewProvider {
    static let components = DateComponents(
        calendar: Calendar.current,
        timeZone: TimeZone(abbreviation: "GMT"),
        year: 2021,
        month: 9,
        day: 26,
        hour: 16,
        minute: 15
    )

    static var habit: Habit {
        let viewContext = PersistenceController.preview.container.viewContext
        let habit = Habit(context: viewContext, statement: "Do something", created: components.date!)
        return habit
    }

    static var day: Day {
        let days = Array(habit.days as? Set<Day> ?? []).filter { $0.isVisible }.sorted { $0.date! < $1.date! }
        return days[0]
    }

    @State static var date = components.date!.midnight()

    static var previews: some View {
        DayCheckBoxView(
            day: day,
            hasToggle: HabitListCell.HabitListCellViewModel(habit: habit, date: date))
            .environmentObject(Color.Palette(color: .blue))
    }
}
