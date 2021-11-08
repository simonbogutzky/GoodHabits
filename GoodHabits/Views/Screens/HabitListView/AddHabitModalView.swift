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
                Text("Add habit")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(colorPalette.primary700)
                    .padding(.horizontal)

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
            }
            .padding()
            .frame(width: 320, height: 220)
            .background(colorPalette.neutral100)
            .cornerRadius(16)
            .overlay(alignment: .topTrailing) {
                Button {
                    withAnimation {
                        viewModel.addHabitModalViewIsPresented = false
                    }
                } label: {
                    XDismissButtonView(systemImageName: "chevron.compact.down")
                }
            }

            Circle()
                .frame(width: 96, height: 96)
                .foregroundColor(colorPalette.neutral100)
                .offset(y: 100)

            Button {
                withAnimation {
                    viewModel.saveHabitWithStatement(statement)
                }
            } label: {
                CircleButtonView(systemImageName: "plus")
            }
            .offset(y: 100)
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
