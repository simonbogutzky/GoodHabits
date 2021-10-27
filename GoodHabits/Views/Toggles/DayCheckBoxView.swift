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
                .toggleStyle(CheckboxStyle())
        } else {
            Toggle("", isOn: $day.isDone)
                .toggleStyle(CheckboxStyle()).hidden()
        }
    }
}

struct CheckboxStyle: ToggleStyle {

    @EnvironmentObject private var colorPalette: Color.Palette

    func makeBody(configuration: Self.Configuration) -> some View {

        return HStack {

            configuration.label

            Spacer()

            Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                .symbolRenderingMode(.palette)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 22, height: 22)
                .foregroundStyle(
                    configuration.isOn ? colorPalette.neutral100 : colorPalette.primary200, colorPalette.primary500,
                    colorPalette.primary500
                )
                .font(.system(size: 20, weight: .regular, design: .default))
                .onTapGesture {
                    configuration.isOn.toggle()
                }

            Spacer()
        }

    }
}

struct DayCheckBoxView_Previews: PreviewProvider {

    static var day: Day {
        let viewContext = PersistenceController.preview.container.viewContext
        let day = Day(context: viewContext)
        day.date = Date()
        day.isDone = false
        day.isVisible = true
        return day
    }

    static var previews: some View {
        DayCheckBoxView(day: day)
            .environmentObject(Color.Palette(color: .blue))
    }
}
