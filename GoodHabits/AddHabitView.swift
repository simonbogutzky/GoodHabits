//
//  AddHabitView.swift
//  GoodHabits
//
//  Created by Dr. Simon Bogutzky on 05.08.21.
//

import SwiftUI

struct AddHabitView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @State var name: String = ""

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Informations")) {
                        TextField("Name", text: $name)
                    }
                }
                
            }.navigationBarTitle(Text("Habit"))
            .toolbar{
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        hideKeyboard()
                    } label: {
                        Image(systemName: "keyboard.chevron.compact.down")
                    }
                    
                    Button {
                        addHabit()
                    } label: {
                        Text("Add")
                    }
                }
            }
        }
    }
    
    private func addHabit() {
        let newItem = Item(context: viewContext)
        newItem.name = name
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct AddHabitView_Previews: PreviewProvider {
    static var previews: some View {
        AddHabitView()
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
