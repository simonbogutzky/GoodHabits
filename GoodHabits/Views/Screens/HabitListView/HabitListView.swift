//
//  HabitListView.swift
//  GoodHabits
//
//  Created by Dr. Simon Bogutzky on 04.08.21.
//

import SwiftUI
import CoreData

struct HabitListView: View {

    @EnvironmentObject private var colorPalette: Color.Palette
    @ObservedObject private var viewModel: HabitListViewModel

    init(viewModel: HabitListViewModel = HabitListViewModel(
        viewContext: PersistenceController.shared.container.viewContext)) {
            self.viewModel = viewModel
            UITableView.appearance().sectionFooterHeight = 0
            UITableView.appearance().backgroundColor = .clear
        }

    var body: some View {
        ZStack {
            BackgroundView()
            ZStack {
                VStack(alignment: .center) {
                    TitleView(title: "Week")
                    WeekButtons(viewModel: viewModel)
                    WeekDayView(viewModel: viewModel)

                    List {
                        ForEach(viewModel.habits) { habit in
                            Section {
                                HabitListCell(
                                    viewModel: HabitListCell.HabitListCellViewModel(
                                        habit: habit,
                                        date: viewModel.date))
                                    .listRowBackground(colorPalette.neutral100)
                            }
                        }
                        .onDelete(perform: viewModel.deleteItems)
                    }
                    .background(colorPalette.neutral100.opacity(0.5))
                    .cornerRadius(10)
                }

                VStack {
                    Spacer()
                    BottomMenu(viewModel: viewModel)
                }

                if viewModel.addHabitModalViewIsPresented {
                    FullScreenBlackTransparencyView()

                    AddHabitModalView(viewModel: viewModel)
                }
            }
        }
        .ignoresSafeArea()
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification),
                   perform: { _ in

            viewModel.saveViewContext()
        })
        .onAppear {
            viewModel.fetchHabits()
        }
    }
}

private struct BackgroundView: View {

    @EnvironmentObject private var colorPalette: Color.Palette

    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [colorPalette.primary400, colorPalette.primary100]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing)
            .ignoresSafeArea()
    }
}

private struct TitleView: View {

    @EnvironmentObject private var colorPalette: Color.Palette

    var title: String

    var body: some View {
        HStack {
            Text(title)
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(colorPalette.neutral700)

            Spacer()
        }
        .padding(EdgeInsets(top: 44, leading: 20, bottom: 0, trailing: 20))
    }
}

private struct WeekButtons: View {

    @EnvironmentObject private var colorPalette: Color.Palette
    @ObservedObject var viewModel: HabitListViewModel

    var body: some View {
        HStack(spacing: 12) {
            Button {
                viewModel.previousWeek()
            } label: {
                RectangleImageButtonView(systemImageName: "chevron.left",
                                         foregroundColor: colorPalette.primary600,
                                         backgroundColor: colorPalette.primary200)
            }

            Button {
                viewModel.previousWeek()
            } label: {
                RectangleTextButtonView(text: viewModel.previousWeekNumberString,
                                        foregroundColor: colorPalette.primary600,
                                        backgroundColor: colorPalette.primary200)
            }

            RectangleTextButtonView(text: viewModel.weekNumberString,
                                    foregroundColor: colorPalette.primary600,
                                    backgroundColor: colorPalette.primary100)

            Button {
                viewModel.nextWeek()
            } label: {
                RectangleTextButtonView(text: viewModel.nextWeekNumberString,
                                        foregroundColor: colorPalette.primary600,
                                        backgroundColor: colorPalette.primary200)
            }

            Button {
                viewModel.nextWeek()
            } label: {
                RectangleImageButtonView(systemImageName: "chevron.right",
                                         foregroundColor: colorPalette.primary600,
                                         backgroundColor: colorPalette.primary200)
            }
        }
        .padding(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20))
    }
}

private struct RectangleImageButtonView: View {

    var systemImageName: String
    var foregroundColor: Color = .white
    var backgroundColor: Color = .blue

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(backgroundColor)
                .frame(width: 54, height: 54)
                .cornerRadius(10)

            Image(systemName: systemImageName)
                .resizable()
                .scaledToFit()
                .foregroundColor(foregroundColor)
                .frame(width: 20, height: 20)
        }
    }
}

private struct RectangleTextButtonView: View {

    var text: String
    var foregroundColor: Color = .white
    var backgroundColor: Color = .blue

    var body: some View {
        Text(text)
            .font(.system(size: 22, weight: .bold))
            .frame(width: 54, height: 54)
            .foregroundColor(foregroundColor)
            .background(backgroundColor)
            .cornerRadius(10)
    }
}

private struct WeekDayView: View {

    @EnvironmentObject private var colorPalette: Color.Palette
    @ObservedObject var viewModel: HabitListViewModel

    var body: some View {
        HStack(alignment: .center, spacing: 20.0) {
            ForEach(viewModel.dayTuples, id: \.dayNumber) { dayTuple in
                WeekDayVStack(dayNumber: dayTuple.dayNumber, weekDayAbbreviation: dayTuple.weekDayAbbreviation)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical)
        .background(colorPalette.neutral100)
        .cornerRadius(10)
        .padding(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20))
    }
}

private struct WeekDayVStack: View {

    @EnvironmentObject private var colorPalette: Color.Palette

    var dayNumber: Int
    var weekDayAbbreviation: String

    var body: some View {
        VStack {
            Text("\(dayNumber, specifier: "%02d")")
                .font(.system(size: 20, weight: .semibold, design: .monospaced))
                .foregroundColor(colorPalette.neutral700)
            Text(weekDayAbbreviation)
                .font(.system(size: 12, weight: .light))
                .foregroundColor(colorPalette.neutral700)
        }
    }
}

private struct BottomMenu: View {

    @EnvironmentObject private var colorPalette: Color.Palette
    @ObservedObject var viewModel: HabitListViewModel

    var body: some View {
        VStack {
            Spacer()
            ZStack {
                Circle()
                    .frame(width: 96, height: 96)
                    .foregroundColor(colorPalette.neutral100)
                    .offset(y: -32)

                Rectangle()
                    .frame(height: 96)
                    .foregroundColor(colorPalette.neutral100)
                    .cornerRadius(10)

                Button {
                    withAnimation {
                        viewModel.addHabitModalViewIsPresented = true
                    }
                } label: {
                    CircleButtonView()
                }
                .offset(y: -32)
            }
        }
    }
}

private struct CircleButtonView: View {

    @EnvironmentObject private var colorPalette: Color.Palette

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [colorPalette.primary600, colorPalette.primary300]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing)
                .frame(width: 64, height: 64)
                .clipShape(Circle())

            Image(systemName: "plus")
                .resizable()
                .scaledToFit()
                .foregroundColor(colorPalette.neutral100)
                .frame(width: 20, height: 20)
        }
    }
}

private struct FullScreenBlackTransparencyView: View {

    var body: some View {
        Color(.black)
            .ignoresSafeArea()
            .opacity(0.33)
            .transition(AnyTransition.opacity.animation(.easeOut(duration: 0.35)))
            .zIndex(1)
            .accessibilityHidden(true)
    }
}

struct HabitListView_Previews: PreviewProvider {
    static var previews: some View {

        HabitListView(viewModel: HabitListViewModel(
            viewContext: PersistenceController.preview.container.viewContext))
            .environmentObject(Color.Palette(color: .blue))
        /*
         HabitListView(viewModel: HabitListViewModel(
         viewContext: PersistenceController.preview.container.viewContext))
         .environmentObject(Color.Palette(color: .green))
         
         HabitListView(viewModel: HabitListViewModel(
         viewContext: PersistenceController.preview.container.viewContext))
         .environmentObject(Color.Palette(color: .red))
         
         HabitListView(viewModel: HabitListViewModel(
         viewContext: PersistenceController.preview.container.viewContext))
         .environmentObject(Color.Palette(color: .yellow))
         */
    }
}
