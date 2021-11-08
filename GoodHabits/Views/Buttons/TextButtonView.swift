//
//  TextButtonView.swift
//  GoodHabits
//
//  Created by Simon Bogutzky on 08.11.21.
//

import SwiftUI

struct TextButtonView: View {
    @EnvironmentObject private var colorPalette: Color.Palette
    var title: LocalizedStringKey

    var body: some View {
        Text(title)
            .padding(EdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20))
            .background(LinearGradient(
                gradient: Gradient(colors: [colorPalette.primary600, colorPalette.primary300]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing))
            .cornerRadius(16)
            .foregroundColor(colorPalette.neutral100)
    }
}

struct TextButtonView_Previews: PreviewProvider {
    static var previews: some View {
        TextButtonView(title: "Add")
            .preferredColorScheme(.dark)
            .environmentObject(Color.Palette(color: .blue))
    }
}
