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
                    TitleView(title: "GoodHabits")
                        .padding(EdgeInsets(top: 44, leading: 20, bottom: 0, trailing: 20))
                    WeekButtons(viewModel: viewModel)
                    WeekDayView(viewModel: viewModel)

                    if viewModel.habits.count < 1 {
                        EmptyHabitsView()
                    } else {
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
                        .padding(.bottom, 96)
                        .background(colorPalette.neutral100.opacity(0.5))
                        .cornerRadius(10)
                    }
                }

                VStack {
                    Spacer()
                    BottomMenu(viewModel: viewModel)
                }
            }
            .disabled(viewModel.addHabitModalViewIsPresented)

            if viewModel.addHabitModalViewIsPresented {
                FullScreenBlackTransparencyView()

                AddHabitModalView(viewModel: viewModel)
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

private struct WeekButtons: View {

    @EnvironmentObject private var colorPalette: Color.Palette
    @ObservedObject var viewModel: HabitListViewModel

    var body: some View {
        HStack(spacing: 12) {

            Button {
                viewModel.today()
            } label: {
                RectangleImageButtonView(systemImageName: "calendar",
                                         foregroundColor: colorPalette.primary600,
                                         backgroundColor: colorPalette.primary200)
            }

            Button {
                viewModel.previousWeek()
            } label: {
                RectangleImageButtonView(systemImageName: "chevron.left",
                                         foregroundColor: colorPalette.primary600,
                                         backgroundColor: colorPalette.primary200)
            }

            RectangleTextButtonView(text: viewModel.weekNumber,
                                    foregroundColor: colorPalette.primary600,
                                    backgroundColor: colorPalette.primary100)

            RectangleTextButtonView(text: "WE",
                                    foregroundColor: colorPalette.primary600,
                                    backgroundColor: colorPalette.primary100)

            Button {
                viewModel.nextWeek()
            } label: {
                RectangleImageButtonView(systemImageName: "chevron.right",
                                         foregroundColor: colorPalette.primary600,
                                         backgroundColor: colorPalette.primary200)
            }
        }
        .disabled(viewModel.habits.count < 1)
        .padding(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20))
    }
}

private struct EmptyHabitsView: View {
    @EnvironmentObject private var colorPalette: Color.Palette

    var body: some View {
        VStack {
            Text("Learn new or correct old behavior patterns. Document them for 66 days and make them to your habit.")
                .multilineTextAlignment(.center)
                .font(.body)
                .padding()
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(colorPalette.neutral100.opacity(0.5))
        .cornerRadius(10)
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
        Text(LocalizedStringKey(text))
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
        VStack {
            HStack(alignment: .center, spacing: 20.0) {
                ForEach(viewModel.getWeekDays(), id: \.digits) { weekDay in
                    WeekDayVStack(weekDay: weekDay)
                }

            }
            Text("\(viewModel.monthAndYear)")
                .font(.system(size: 14, weight: .light))
                .foregroundColor(colorPalette.neutral700)
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
                    CircleButtonView(systemImageName: "chevron.compact.up")
                }
                .offset(y: -32)

                HStack {
                    Spacer()

                    Button {
                        colorPalette.paletteColor = viewModel.getNextPaletteColor()
                    } label: {
                        SmallCircleButtonView(systemImageName: "paintbrush.fill")
                    }
                    .padding()
                }
            }
        }
    }
}

private struct FullScreenBlackTransparencyView: View {

    @EnvironmentObject private var colorPalette: Color.Palette

    var body: some View {
        colorPalette.neutral700
            .ignoresSafeArea()
            .opacity(0.5)
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
