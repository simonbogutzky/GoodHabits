//
//  GoodHabitsApp.swift
//  GoodHabits
//
//  Created by Simon Bogutzky on 04.08.21.
//

import SwiftUI

@main
struct GoodHabitsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            HabitListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
