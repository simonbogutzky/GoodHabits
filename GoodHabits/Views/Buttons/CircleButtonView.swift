//
//  CircleButtonView.swift
//  GoodHabits
//
//  Created by Simon Bogutzky on 08.11.21.
//

import SwiftUI

struct CircleButtonView: View {

    @EnvironmentObject private var colorPalette: Color.Palette

    var systemImageName: String

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [colorPalette.primary600, colorPalette.primary300]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing)
                .frame(width: 64, height: 64)
                .clipShape(Circle())

            Image(systemName: systemImageName)
                .resizable()
                .scaledToFit()
                .foregroundColor(colorPalette.neutral100)
                .frame(width: 20, height: 20)
        }
    }
}

struct CircleButtonView_Previews: PreviewProvider {
    static var previews: some View {
        CircleButtonView(systemImageName: "plus")
            .environmentObject(Color.Palette(color: .blue))
    }
}
