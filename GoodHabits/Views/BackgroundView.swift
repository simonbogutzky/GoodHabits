//
//  BackgroundView.swift
//  GoodHabits
//
//  Created by Simon Bogutzky on 24.11.21.
//

import SwiftUI

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

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView()
            .environmentObject(Color.Palette(color: .blue))
    }
}
