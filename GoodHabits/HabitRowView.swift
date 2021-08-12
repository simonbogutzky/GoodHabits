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
        VStack(alignment: .leading, spacing: 8) {
            Text(item.name ?? "").bold().foregroundColor(Color(.systemGray))
            HStack {
                ForEach(Array(item.days as? Set<Day> ?? []), id: \.self) { day in
                    DayCheckBoxView(day: day)
                }
            }
        }
    }
}

struct HabitRowView_Previews: PreviewProvider {
    
    static var item: Item {
        let viewContext = PersistenceController.preview.container.viewContext
        let item = Item(context: viewContext)
        item.name = "Do something"
        item.timestamp = Date()
        
        initializeFirstWeekOfDays(viewContext, item)
        
        return item
    }
    
    static var previews: some View {
        Group {
            HabitRowView(item: item)
        }
    }
}
