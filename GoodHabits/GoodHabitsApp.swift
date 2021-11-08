//
//  GoodHabitsApp.swift
//  GoodHabits
//
//  Created by Dr. Simon Bogutzky on 04.08.21.
//

import SwiftUI

@main
struct GoodHabitsApp: App {

    let colorPalette: Color.Palette

    init() {
        let colorPaletteIndex = UserDefaults.standard.integer(forKey: DefaultsKey.paletteColorIndex)
        colorPalette = Color.Palette(color: Color.paletteColors[colorPaletteIndex])
    }

    var body: some Scene {
        WindowGroup {
            HabitListView()
                .environmentObject(colorPalette)
        }
    }
}
