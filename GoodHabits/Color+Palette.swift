//
//  Color+Palette.swift
//  GoodHabits
//
//  Created by Dr. Simon Bogutzky on 07.10.21.
//

import SwiftUI

extension Color {

    struct Palette {
        let name: String

        var neutral100: Color {
            Color(fromPalette: self.name, semanticName: "neutral-100")
        }

        var neutral200: Color {
            Color(fromPalette: self.name, semanticName: "neutral-200")
        }

        var neutral300: Color {
            Color(fromPalette: self.name, semanticName: "neutral-300")
        }

        var neutral400: Color {
            Color(fromPalette: self.name, semanticName: "neutral-400")
        }

        var neutral500: Color {
            Color(fromPalette: self.name, semanticName: "neutral-500")
        }

        var neutral600: Color {
            Color(fromPalette: self.name, semanticName: "neutral-600")
        }

        var neutral700: Color {
            Color(fromPalette: self.name, semanticName: "neutral-700")
        }

        var primary100: Color {
            Color(fromPalette: self.name, semanticName: "primary-100")
        }

        var primary200: Color {
            Color(fromPalette: self.name, semanticName: "primary-200")
        }

        var primary300: Color {
            Color(fromPalette: self.name, semanticName: "primary-300")
        }

        var primary400: Color {
            Color(fromPalette: self.name, semanticName: "primary-400")
        }

        var primary500: Color {
            Color(fromPalette: self.name, semanticName: "primary-500")
        }

        var primary600: Color {
            Color(fromPalette: self.name, semanticName: "primary-600")
        }

        var primary700: Color {
            Color(fromPalette: self.name, semanticName: "primary-700")
        }
    }
}

private extension Color {

    init(fromPalette palette: String, semanticName: String) {
#if os(macOS)
        self.init(NSColor(named: "\(palette)/\(semanticName)")!)
#else
        self.init(UIColor(named: "\(palette)/\(semanticName)")!)
#endif
    }
}

extension Color.Palette {
    static let blue = Color.Palette(name: "Blue")
    static let green = Color.Palette(name: "Green")
    static let red = Color.Palette(name: "Red")
    static let yellow = Color.Palette(name: "Yellow")
}
