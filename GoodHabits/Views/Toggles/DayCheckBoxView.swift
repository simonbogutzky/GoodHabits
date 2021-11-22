//
//  DayCheckBoxView.swift
//  GoodHabits
//
//  Created by Dr. Simon Bogutzky on 12.08.21.
//

import SwiftUI

struct DayCheckBoxView: View {

    @ObservedObject var day: Day

    init(day: Day) {
        self.day = day
    }

    var body: some View {
        if day.isVisible {
            Toggle("", isOn: $day.isDone)
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

    static var day: Day {
        let viewContext = PersistenceController.preview.container.viewContext
        let day = Day(context: viewContext)
        day.date = Date().midnight()
        day.isDone = false
        day.isVisible = true
        return day
    }

    static var previews: some View {
        DayCheckBoxView(day: day)
            .environmentObject(Color.Palette(color: .blue))
    }
}
