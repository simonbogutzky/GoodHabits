//
//  AddHabitView.swift
//  GoodHabits
//
//  Created by Dr. Simon Bogutzky on 05.08.21.
//

import SwiftUI

struct AddHabitView: View {
    @ObservedObject var viewModel: HabitListViewModel
    @Environment(\.dismiss) var dismiss
    @State var statement: String = ""

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Informations")) {
                        TextField("Statement", text: $statement)
                    }
                }

            }
            .navigationBarTitle(Text("Habit"))
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    AddHabitViewToolbarButtons(
                        viewModel: viewModel,
                        statement: statement,
                        dismiss: dismiss)
                }
            }
        }
    }
}

private struct AddHabitViewToolbarButtons: View {
    @ObservedObject var viewModel: HabitListViewModel
    @EnvironmentObject private var colorPalette: Color.Palette

    var statement: String

    var dismiss: DismissAction

    var body: some View {
        Group {
            Button {
                hideKeyboard()
            } label: {
                Image(systemName: "keyboard.chevron.compact.down")
            }

            Button {
                viewModel.addItemWithStatement(statement)
                dismiss()
            } label: {
                Text("Add")
            }
        }
        .foregroundColor(colorPalette.primary700)
    }
}

struct AddHabitView_Previews: PreviewProvider {
    static var previews: some View {
        AddHabitView(viewModel: HabitListViewModel(viewContext: PersistenceController.shared.container.viewContext))
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
