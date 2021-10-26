//
//  GoodHabitsApp.swift
//  GoodHabits
//
//  Created by Dr. Simon Bogutzky on 04.08.21.
//

import SwiftUI

@main
struct GoodHabitsApp: App {
    let persistenceController = PersistenceController.shared

    let colorPalette = Color.Palette(color: .blue)

    var body: some Scene {
        WindowGroup {
            HabitListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(colorPalette)
        }
    }
}
