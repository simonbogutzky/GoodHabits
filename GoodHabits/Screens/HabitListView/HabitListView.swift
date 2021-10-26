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

        NavigationView {
            ZStack {
                BackgroundView()
                List {
                    ForEach(viewModel.habits) { habit in
                        Section {
                            HabitListCell(viewModel: HabitListCellViewModel(habit: habit, date: viewModel.date))
                        }
                    }.onDelete(perform: viewModel.deleteItems)
                }
                .listStyle(InsetGroupedListStyle())
                .navigationTitle(Text("Habits"))
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        HabitListViewToolbarButtons(viewModel: viewModel)
                    }
                }
                .sheet(isPresented: $viewModel.addHabitsViewIsPresented, onDismiss: {
                    print("Add habits view is present: \(viewModel.addHabitsViewIsPresented)")
                }, content: {
                    AddHabitView(viewModel: viewModel)
                })
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification),
                       perform: { _ in

                viewModel.saveViewContext()
            })
            .onAppear {
                viewModel.fetchHabits()
            }
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
