//
//  GoodHabitsApp.swift
//  GoodHabits
//
//  Created by Dr. Simon Bogutzky on 04.08.21.
//

import SwiftUI

@main
struct GoodHabitsApp: App {

    let colorPalette = Color.Palette(color: .blue)

    var body: some Scene {
        WindowGroup {
            HabitListView()
                .environmentObject(colorPalette)
        }
    }
}
