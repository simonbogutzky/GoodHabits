//
//  ContentView.swift
//  GoodHabits
//
//  Created by Dr. Simon Bogutzky on 04.08.21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.preferredColorPalette) private var palette

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    @State private var addHabitsViewIsPresented = false
    @State private var date = Date().midnight()

    init() {
        UITableView.appearance().sectionFooterHeight = 0
        UITableView.appearance().backgroundColor = .clear
    }

    var body: some View {

        NavigationView {
            ZStack {
                BackgroundView()
                List {
                    ForEach(items) { item in
                        Section {
                            HabitRowView(item: item, current: date)
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
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

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
            offsets.map { items[$0] }.forEach(viewContext.delete)

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
    @Environment(\.preferredColorPalette) private var palette

    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [palette.primary400, palette.primary100]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing)
            .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
