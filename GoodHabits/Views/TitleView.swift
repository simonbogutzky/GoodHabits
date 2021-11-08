//
//  TitleView.swift
//  GoodHabits
//
//  Created by Simon Bogutzky on 08.11.21.
//

import SwiftUI

struct TitleView: View {

    @EnvironmentObject private var colorPalette: Color.Palette

    var title: String

    var body: some View {
        HStack {
            Text(title)
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(colorPalette.neutral700)

            Spacer()
        }
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView(title: "Title")
    }
}
