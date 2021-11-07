//
//  AddHabitModalView.swift
//  GoodHabits
//
//  Created by Dr. Simon Bogutzky on 05.08.21.
//

import SwiftUI

struct AddHabitModalView: View {

    @EnvironmentObject private var colorPalette: Color.Palette
    @ObservedObject var viewModel: HabitListViewModel
    @State var statement: String = ""

    var body: some View {
        ZStack {
            VStack {
                Form {
                    Section(header: Text("New Habit")
                                .foregroundColor(colorPalette.primary700)
                    ) {
                        TextField("Statement", text: $statement)
                    }
                }.background(.clear)
            }
            .padding()
            .frame(width: 320, height: 180)
            .background(LinearGradient(
                gradient: Gradient(colors: [colorPalette.primary200, colorPalette.primary100]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing))
            .cornerRadius(16)
            .overlay(alignment: .topTrailing) {
                Button {
                    withAnimation {
                        viewModel.addHabitModalViewIsPresented = false
                    }
                } label: {
                    XDismissButton()
                }
            }
        }
        .transition(.opacity.combined(with: .move(edge: .bottom)))
        .zIndex(2)
    }
}

struct AddHabitModalView_Previews: PreviewProvider {
    static var previews: some View {
        AddHabitModalView(viewModel:
                            HabitListViewModel(viewContext:
                                                PersistenceController.shared.container.viewContext))
            .environmentObject(Color.Palette(color: .blue))
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
