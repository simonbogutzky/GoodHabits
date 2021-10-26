//
//  HabitListView.swift
//  GoodHabits
//
//  Created by Dr. Simon Bogutzky on 04.08.21.
//

import SwiftUI
import CoreData

struct HabitListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var palette = Color.Palette.blue

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Habit.created, ascending: true)],
        animation: .default)
    private var habits: FetchedResults<Habit>
    @State private var addHabitsViewIsPresented = false
    @State private var date = Date().midnight()

    init() {
        UITableView.appearance().sectionFooterHeight = 0
        UITableView.appearance().backgroundColor = .clear
    }

    var body: some View {

        NavigationView {
            ZStack {
                BackgroundView(palette: palette)
                List {
                    ForEach(habits) { habit in
                        Section {
                            HabitListCell(palette: palette, habit: habit, date: date)
                        }
                    }.onDelete(perform: deleteItems)
                }
                .listStyle(InsetGroupedListStyle())
                .navigationTitle(Text("Habits"))
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Group {
                            Button(action: {
                                self.addHabitsViewIsPresented = true
                            }, label: {
                                Label("Add Item", systemImage: "plus")
                            })

                            Button(action: {
                            date = date.addingTimeInterval(-7 * 60 * 60 * 24)
                            }, label: {
                                Label("Previous Week", systemImage: "chevron.left")
                            })

                            Button(action: {
                                date = date.addingTimeInterval(7 * 60 * 60 * 24)
                            }, label: {
                                Label("Previous Week", systemImage: "chevron.right")
                            })

                            Button(action: {
                                let colorPalettes = [Color.Palette.blue,
                                                     Color.Palette.green,
                                                     Color.Palette.red,
                                                     Color.Palette.yellow
                                                     ]
                                let index = Int.random(in: 0 ..< 4)
                                palette = colorPalettes[index]
                            }, label: {
                                Label("Change Colors", systemImage: "paintbrush.fill")
                            })

#if os(iOS)
                            EditButton()
#endif

                        }
                        .foregroundColor(palette.primary700)
                    }
                }
                .sheet(isPresented: $addHabitsViewIsPresented, onDismiss: {
                    print("Add habits view is present: \(self.addHabitsViewIsPresented)")
                }, content: {
                    AddHabitView()
                })
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification),
                       perform: { _ in
                do {
                    try viewContext.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate.
                    // You should not use this function in a shipping application,
                    // although it may be useful during development.
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            })
        }
    }

    private func addItem() {
        withAnimation {
            let newHabit = Habit(context: viewContext)
            newHabit.created = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate.
                // You should not use this function in a shipping application,
                // although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { habits[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate.
                // You should not use this function in a shipping application,
                // although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct BackgroundView: View {
    var palette: Color.Palette

    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [palette.primary400, palette.primary100]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing)
            .ignoresSafeArea()
    }
}

struct HabitListView_Previews: PreviewProvider {
    static var previews: some View {
        HabitListView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
