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
    @FocusState private var focusedTextField: HabitTextField?

    enum HabitTextField {
        case statement
    }

    var body: some View {
        ZStack {
            VStack {

                TitleView(title: "Add habit")
                    .padding()

                TextField("Statement", text: $statement)
                    .lineLimit(1)
                    .disableAutocorrection(true)
                    .focused($focusedTextField, equals: .statement)
                    .onSubmit {
                        focusedTextField = nil
                    }
                    .submitLabel(.done)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                Button {
                    viewModel.saveHabitWithStatement(statement)
                } label: {
                    TextButtonView(title: "Add")
                }
                .padding(.vertical)
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
                    XDismissButtonView()
                }
            }
        }
        .transition(.opacity.combined(with: .move(edge: .bottom)))
        .zIndex(2)
        .offset(y: -100)
        .alert(item: $viewModel.alertItem, content: { $0.alert })
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
