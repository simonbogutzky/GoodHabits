//
//  ColorPaletteEnvironment.swift
//  GoodHabits
//
//  Created by Dr. Simon Bogutzky on 07.10.21.
//

import SwiftUI

private struct ColorPaletteKey: EnvironmentKey {
    static let defaultValue = Color.Palette.blue
}

extension EnvironmentValues {
    var preferredColorPalette: Color.Palette {
        get {
            return self[ColorPaletteKey.self]
        }
        set {
            self[ColorPaletteKey.self] = newValue
        }
    }
}
