//
//  GoodHabitsWidgetView.swift
//  GoodHabits
//
//  Created by Simon Bogutzky on 24.11.21.
//

import SwiftUI
import WidgetKit

struct GoodHabitsWidgetData {
    let missingStatements: Int
    var remainingTime = "12:00:00"
    var digits = "24"
    var abbreviation = "Wed"
}

extension GoodHabitsWidgetData {
    static let previewData = GoodHabitsWidgetData(missingStatements: 3)
}

struct GoodHabitsWidgetView: View {
    let colorPalette = Color.Palette(color: Color.paletteColors[0])
    let data: GoodHabitsWidgetData

    var body: some View {
        ZStack {
            BackgroundView()
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    WeekDayVStack(weekDay:
                                    WeekDay(digits: data.digits, abbreviation: data.abbreviation, isToday: true)
                    )
                    .padding([.leading, .top], 4)

                    MissingStatementsView(data: data)
                }
                .background(colorPalette.neutral100)
                .cornerRadius(10)

                Spacer()
                RemainingTimeView(data: data)
            }
            .padding()
        }
        .environmentObject(colorPalette)
    }
}

struct GoodHabitsWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GoodHabitsWidgetView(data: .previewData)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            GoodHabitsWidgetView(data: .previewData)
                .preferredColorScheme(.dark)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
        }
    }
}

private struct MissingStatementsView: View {
    @EnvironmentObject private var colorPalette: Color.Palette
    let data: GoodHabitsWidgetData

    var body: some View {
        HStack {
            Spacer()
            VStack {
            ZStack {
                Image(systemName: "circle")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(colorPalette.secondary300)
                Text("\(data.missingStatements)")
                    .font(.title)
                    .bold()
                    .foregroundColor(colorPalette.secondary500)
            }
                Circle()
                    .fill()
                    .foregroundColor(colorPalette.secondary500)
                    .frame(width: 4, height: 4)
                    .offset(y: -4)
            }
            Spacer()
        }
        .offset(y: -15)
    }
}

private struct RemainingTimeView: View {
    @EnvironmentObject private var colorPalette: Color.Palette
    let data: GoodHabitsWidgetData

    var body: some View {
        HStack {

            Image(systemName: "moon.stars.fill")
                .resizable()
                .frame(width: 12, height: 12)
                .padding(.leading, 8)

            Text(data.remainingTime)
                .font(.system(size: 12, weight: .light))
                .padding(0)

            Spacer()
        }
        .foregroundColor(colorPalette.primary600)
        .padding([.leading, .bottom], 4)
    }
}
