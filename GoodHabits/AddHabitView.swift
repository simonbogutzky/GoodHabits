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
        _ = Item(context: viewContext, name: name)
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
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
