//
//  WeekDayVStack.swift
//  GoodHabits
//
//  Created by Simon Bogutzky on 24.11.21.
//

import SwiftUI

struct WeekDayVStack: View {

    @EnvironmentObject private var colorPalette: Color.Palette

    var weekDay: WeekDay

    var body: some View {
        VStack {
            Text(weekDay.digits)
                .font(.system(size: 20, weight: .semibold, design: .monospaced))
                .foregroundColor(!weekDay.isToday ? colorPalette.neutral700 : colorPalette.secondary500)
            Text(weekDay.abbreviation)
                .font(.system(size: 12, weight: .light))
                .foregroundColor(!weekDay.isToday ? colorPalette.neutral700 : colorPalette.secondary500)
                .padding(.bottom, -4)
            Circle()
                .fill()
                .foregroundColor(!weekDay.isToday ? .clear : colorPalette.secondary500)
                .frame(width: 4, height: 4)
        }
    }
}

struct WeekDayVStack_Previews: PreviewProvider {
    static var previews: some View {
        WeekDayVStack(weekDay: WeekDay(digits: "24", abbreviation: "Wed", isToday: true))
            .environmentObject(Color.Palette(color: .blue))
    }
}
