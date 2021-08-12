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
            ForEach(Array(item.days as? Set<Day> ?? []), id: \.self) { day in
                DayCheckBoxView(day: day)
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
        
        let monday = Date.today().previous(.monday, considerToday: true)
        
        for i in 0...6 {
            let day = Day(context: viewContext)
            day.date = monday.addingTimeInterval(TimeInterval(60 * 60 * 24 * i))
            day.isDone = false
            item.addToDays(day)
        }
        
        return item
    }
    
    static var previews: some View {
        Group {
            HabitRowView(item: item)
        }
    }
}
