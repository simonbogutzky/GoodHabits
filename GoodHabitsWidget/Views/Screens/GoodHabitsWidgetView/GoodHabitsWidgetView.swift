//
//  GoodHabitsWidgetView.swift
//  GoodHabits
//
//  Created by Simon Bogutzky on 24.11.21.
//

import SwiftUI
import WidgetKit

struct GoodHabitsWidgetView: View {

    @EnvironmentObject private var colorPalette: Color.Palette
    @ObservedObject var viewModel: GoodHabitsWidgetViewModel

    var body: some View {
        ZStack {
            BackgroundView()
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    WeekDayVStack(weekDay:
                                    WeekDay(
                                        digits: viewModel.digits,
                                        abbreviation: viewModel.abbreviation,
                                        isToday: true)
                    )
                        .padding([.leading, .top], 8)

                    MissingStatementsView(viewModel: viewModel)
                        .padding(.bottom, -32)
                }
                .background(ContainerRelativeShape().fill(colorPalette.neutral100))

                Spacer()
                RemainingTimeView(viewModel: viewModel)
            }
            .padding(8)
        }
    }
}

private struct MissingStatementsView: View {

    @EnvironmentObject private var colorPalette: Color.Palette
    @ObservedObject var viewModel: GoodHabitsWidgetView.GoodHabitsWidgetViewModel

    var body: some View {
        HStack {
            Spacer()
            VStack {
                ZStack {
                    Image(systemName: "circle")
                        .resizable()
                        .frame(width: 56, height: 56)
                        .foregroundColor(colorPalette.secondary300)

                    Text("\(viewModel.missingStatementsString)")
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
    @ObservedObject var viewModel: GoodHabitsWidgetView.GoodHabitsWidgetViewModel

    var body: some View {
        HStack {

            Image(systemName: "moon.stars.fill")
                .resizable()
                .frame(width: 12, height: 12)
                .padding(.leading, 8)

            Text(viewModel.tomorrowMidnight, style: .relative)
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
            GoodHabitsWidgetView(viewModel: GoodHabitsWidgetView.GoodHabitsWidgetViewModel.previewViewModel)
                .environmentObject(Color.Palette(color: Color.paletteColors[0]))
                .previewContext(WidgetPreviewContext(family: .systemSmall))

            GoodHabitsWidgetView(viewModel: GoodHabitsWidgetView.GoodHabitsWidgetViewModel.previewViewModel)
                .environmentObject(Color.Palette(color: Color.paletteColors[0]))
                .preferredColorScheme(.dark)
                .previewContext(WidgetPreviewContext(family: .systemSmall))

            GoodHabitsWidgetView(viewModel: GoodHabitsWidgetView.GoodHabitsWidgetViewModel.previewViewModel)
                .environmentObject(Color.Palette(color: Color.paletteColors[0]))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .redacted(reason: .placeholder)

            GoodHabitsWidgetView(viewModel: GoodHabitsWidgetView.GoodHabitsWidgetViewModel.previewViewModel)
                .environmentObject(Color.Palette(color: Color.paletteColors[0]))
                .preferredColorScheme(.dark)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .redacted(reason: .placeholder)

            GoodHabitsWidgetView(viewModel: GoodHabitsWidgetView.GoodHabitsWidgetViewModel.previewViewModel)
                .environmentObject(Color.Palette(color: Color.paletteColors[0]))
                .preferredColorScheme(.dark)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .environment(\.sizeCategory, .extraExtraExtraLarge)
        }
    }
}
