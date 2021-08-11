//
//  HabitRowView.swift
//  GoodHabits
//
//  Created by Dr. Simon Bogutzky on 11.08.21.
//

import SwiftUI

struct HabitRowView: View {
    @ObservedObject var item: Item
    
    init(item: Item) {
        self.item = item
    }
    
    var body: some View {
        HStack {
            Text(item.name!)
            Toggle("", isOn: $item.isChecked)
        }
    }
}

struct HabitRowView_Previews: PreviewProvider {
    
    static var item: Item {
        let viewContext = PersistenceController.preview.container.viewContext
        let item = Item(context: viewContext)
        item.name = "Do something"
        item.timestamp = Date()
        item.isChecked = true
        return item
    }
    
    static var previews: some View {
        HabitRowView(item: item)
    }
}
