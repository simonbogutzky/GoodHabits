//
//  XDismissButtonView.swift
//  GoodHabits
//
//  Created by Simon Bogutzky on 07.11.21.
//

import SwiftUI

struct XDismissButtonView: View {

    @EnvironmentObject private var colorPalette: Color.Palette

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [colorPalette.primary600, colorPalette.primary300]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing)
                .frame(width: 32, height: 32)
                .clipShape(Circle())

            Image(systemName: "xmark")
                .foregroundColor(colorPalette.neutral100)
                .imageScale(.small)
                .frame(width: 44, height: 44)
        }
    }
}

struct XDismissButtonView_Previews: PreviewProvider {
    static var previews: some View {
        XDismissButtonView()
            .environmentObject(Color.Palette(color: .blue))
    }
}
