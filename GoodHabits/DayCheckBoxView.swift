//
//  DayCheckBoxView.swift
//  GoodHabits
//
//  Created by Dr. Simon Bogutzky on 12.08.21.
//

import SwiftUI

struct DayCheckBoxView: View {
    var palette: Color.Palette
    @ObservedObject var day: Day

    init(palette: Color.Palette, day: Day) {
        self.palette = palette
        self.day = day
    }

    var body: some View {
        if day.isVisible {
            Toggle("", isOn: $day.isDone)
                .toggleStyle(CheckboxStyle(palette: palette))
        } else {
            Toggle("", isOn: $day.isDone)
                .toggleStyle(CheckboxStyle(palette: palette)).hidden()
        }
    }
}

struct CheckboxStyle: ToggleStyle {

    var palette: Color.Palette

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
                    configuration.isOn ? .white : palette.primary200, palette.primary500,
                    palette.primary500
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
        DayCheckBoxView(palette: Color.Palette.blue, day: day)
    }
}
