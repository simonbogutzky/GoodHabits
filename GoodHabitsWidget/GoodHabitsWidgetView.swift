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
    var tomorrowMidnight = Date().addingTimeInterval(24 * 60 * 60).midnight()
    var digits = Date().formatted(.dateTime.day(.twoDigits))
    var abbreviation = Date().formatted(.dateTime.weekday(.abbreviated))

    var missingStatementsString: String {
        missingStatements > 9 ? "9+" : "\(missingStatements)"
    }
}

extension GoodHabitsWidgetData {
    static let previewData = GoodHabitsWidgetData(missingStatements: 8)
}

struct GoodHabitsWidgetView: View {
    let colorPalette: Color.Palette
    let data: GoodHabitsWidgetData

    var body: some View {
        ZStack {
            BackgroundView()
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    WeekDayVStack(weekDay:
                                    WeekDay(digits: data.digits, abbreviation: data.abbreviation, isToday: true)
                    )
                        .padding([.leading, .top], 8)

                    MissingStatementsView(data: data)
                        .padding(.bottom, -32)
                }
                .background(ContainerRelativeShape().fill(colorPalette.neutral100))

                Spacer()
                RemainingTimeView(data: data)
            }
            .padding(8)
        }
        .environmentObject(colorPalette)
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
                        .frame(width: 56, height: 56)
                        .foregroundColor(colorPalette.secondary300)

                    Text("\(data.missingStatementsString)")
                        .font(.title)
                        .bold()
                        .foregroundColor(colorPalette.secondary500)
                }
                Circle()
                    .fill()
                    .foregroundColor(colorPalette.secondary500)
                    .frame(width: 4, height: 4)
                    .offset(y: -2)
            }
            Spacer()
        }
        .offset(y: -36)
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

            Text(data.tomorrowMidnight, style: .relative)
                .font(.system(size: 12, weight: .light))
                .padding(0)

            Spacer()
        }
        .foregroundColor(colorPalette.primary600)
        .padding([.leading, .bottom], 4)
    }
}

struct GoodHabitsWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GoodHabitsWidgetView(colorPalette: Color.Palette(color: Color.paletteColors[0]), data: .previewData)
                .previewContext(WidgetPreviewContext(family: .systemSmall))

            GoodHabitsWidgetView(colorPalette: Color.Palette(color: Color.paletteColors[0]), data: .previewData)
                .preferredColorScheme(.dark)
                .previewContext(WidgetPreviewContext(family: .systemSmall))

            GoodHabitsWidgetView(colorPalette: Color.Palette(color: Color.paletteColors[0]), data: .previewData)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .redacted(reason: .placeholder)

            GoodHabitsWidgetView(colorPalette: Color.Palette(color: Color.paletteColors[0]), data: .previewData)
                .preferredColorScheme(.dark)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .redacted(reason: .placeholder)

            GoodHabitsWidgetView(colorPalette: Color.Palette(color: Color.paletteColors[0]), data: .previewData)
                .preferredColorScheme(.dark)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .environment(\.sizeCategory, .extraExtraExtraLarge)
        }
    }
}
