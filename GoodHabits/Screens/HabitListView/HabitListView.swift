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
            VStack(alignment: .center) {
                VStack(alignment: .leading) {
                    Text("Week")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(colorPalette.neutral700)
                        .padding(.top, 20)

                    HStack(spacing: 12) {
                        Button {
                            viewModel.previousWeek()
                        } label: {
                            Image(systemName: "chevron.left")
                                .imageScale(.large)
                                .frame(width: 54, height: 54)
                                .foregroundColor(colorPalette.primary600)
                                .background(colorPalette.primary200)
                                .cornerRadius(10)
                        }

                        Button {

                        } label: {
                            Text("30")
                                .font(.title2)
                                .fontWeight(.bold)
                                .frame(width: 54, height: 54)
                                .foregroundColor(colorPalette.primary600)
                                .background(colorPalette.primary200)
                                .cornerRadius(10)
                        }

                        Button {

                        } label: {
                            Text("31")
                                .font(.title2)
                                .fontWeight(.bold)
                                .frame(width: 54, height: 54)
                                .foregroundColor(colorPalette.primary600)
                                .background(colorPalette.neutral100)
                                .cornerRadius(10)
                        }

                        Button {

                        } label: {
                            Text("32")
                                .font(.title2)
                                .fontWeight(.bold)
                                .frame(width: 54, height: 54)
                                .foregroundColor(colorPalette.primary600)
                                .background(colorPalette.primary200)
                                .cornerRadius(10)
                        }

                        Button {
                            viewModel.nextWeek()
                        } label: {
                            Image(systemName: "chevron.right")
                                .imageScale(.large)
                                .frame(width: 54, height: 54)
                                .foregroundColor(colorPalette.primary600)
                                .background(colorPalette.primary200)
                                .cornerRadius(10)
                        }
                    }.frame(
                        minWidth: 0,
                        maxWidth: .infinity,
                        minHeight: 64.0,
                        maxHeight: 64.0
                    )

                    HStack(alignment: .center, spacing: 20.0) {
                        VStack {
                            Text("02")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(colorPalette.neutral700)
                            Text("Mon")
                                .font(.caption)
                                .fontWeight(.light)
                                .foregroundColor(colorPalette.neutral700)
                        }

                        VStack {
                            Text("03")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(colorPalette.neutral700)
                            Text("Tue")
                                .font(.caption)
                                .fontWeight(.light)
                                .foregroundColor(colorPalette.neutral700)
                        }

                        VStack {
                            Text("04")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(colorPalette.neutral700)
                            Text("Wed")
                                .font(.caption)
                                .fontWeight(.light)
                                .foregroundColor(colorPalette.neutral700)
                        }

                        VStack {
                            Text("05")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(colorPalette.neutral700)
                            Text("Thu")
                                .font(.caption)
                                .fontWeight(.light)
                                .foregroundColor(colorPalette.neutral700)
                        }

                        VStack {
                            Text("06")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(colorPalette.neutral700)
                            Text("Fri")
                                .font(.caption)
                                .fontWeight(.light)
                                .foregroundColor(colorPalette.neutral700)
                        }

                        VStack {
                            Text("07")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(colorPalette.neutral700)
                            Text("Sat")
                                .font(.caption)
                                .fontWeight(.light)
                                .foregroundColor(colorPalette.neutral700)
                        }

                        VStack {
                            Text("08")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(colorPalette.neutral700)
                            Text("Sun")
                                .font(.caption)
                                .fontWeight(.light)
                                .foregroundColor(colorPalette.neutral700)
                        }
                    }
                    .frame(
                        minWidth: 0,
                        maxWidth: .infinity,
                        minHeight: 64.0,
                        maxHeight: 64.0
                    )
                    .background(colorPalette.neutral100)
                    .cornerRadius(10)
                }.padding(20)

                ZStack {
                    List {
                        ForEach(viewModel.habits) { habit in
                            Section {
                                HabitListCell(
                                    viewModel: HabitListCellViewModel(
                                        habit: habit,
                                        date: viewModel.date))
                                    .listRowBackground(colorPalette.neutral100)
                            }
                        }
                        .onDelete(perform: viewModel.deleteItems)
                    }
                    .background(colorPalette.neutral100.opacity(0.5))
                    .cornerRadius(10)
                    VStack {
                        Spacer()
                        ZStack {

                            Circle()
                                .frame(width: 96, height: 96)
                                .foregroundColor(colorPalette.neutral100)
                                .offset(y: -32)

                            colorPalette.neutral100.frame(
                                minWidth: 0,
                                maxWidth: .infinity,
                                minHeight: 96.0,
                                maxHeight: 96.0
                            )
                                .cornerRadius(10)

                            Button {
                                viewModel.addHabitsViewIsPresented = true
                            } label: {
                                    Image(systemName: "plus")
                                        .imageScale(.large)
                                        .frame(width: 64, height: 64)
                                        .foregroundColor(colorPalette.neutral100)
                                        .background(LinearGradient(
                                            gradient: Gradient(colors: [colorPalette.primary600, colorPalette.primary300]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing))
                                        .clipShape(Circle())
                                        .offset(y: -32)
                            }
                        }
                    }
                }
            }
        }
        .ignoresSafeArea()
        .sheet(isPresented: $viewModel.addHabitsViewIsPresented, onDismiss: {
            print("Add habits view is present: \(viewModel.addHabitsViewIsPresented)")
        }, content: {
            AddHabitView(viewModel: viewModel)
        })
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification),
                   perform: { _ in

            viewModel.saveViewContext()
        })
        .onAppear {
            viewModel.fetchHabits()
        }
    }
}

struct BackgroundView: View {
    @EnvironmentObject private var colorPalette: Color.Palette

    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [colorPalette.primary400, colorPalette.primary100]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing)
            .ignoresSafeArea()
    }
}

struct HabitListViewToolbarButtons: View {
    @ObservedObject var viewModel: HabitListViewModel
    @EnvironmentObject private var colorPalette: Color.Palette

    var body: some View {
        Group {
            Button(action: {
                viewModel.addHabitsViewIsPresented = true
            }, label: {
                Label("Add Item", systemImage: "plus")
            })

            Button(action: {
                viewModel.previousWeek()
            }, label: {
                Label("Previous Week", systemImage: "chevron.left")
            })

            Button(action: {
                viewModel.nextWeek()
            }, label: {
                Label("Previous Week", systemImage: "chevron.right")
            })

#if os(iOS)
            EditButton()
#endif

        }
        .foregroundColor(colorPalette.primary700)
    }
}

struct HabitListView_Previews: PreviewProvider {
    static var previews: some View {

        HabitListView(viewModel: HabitListViewModel(
            viewContext: PersistenceController.preview.container.viewContext))
            .environmentObject(Color.Palette(color: .red))

        HabitListView(viewModel: HabitListViewModel(
            viewContext: PersistenceController.preview.container.viewContext))
            .environmentObject(Color.Palette(color: .green))

        HabitListView(viewModel: HabitListViewModel(
            viewContext: PersistenceController.preview.container.viewContext))
            .environmentObject(Color.Palette(color: .blue))

        HabitListView(viewModel: HabitListViewModel(
            viewContext: PersistenceController.preview.container.viewContext))
            .environmentObject(Color.Palette(color: .yellow))
    }
}
