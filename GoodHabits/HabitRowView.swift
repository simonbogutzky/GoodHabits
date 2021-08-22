//
//  HabitRowView.swift
//  GoodHabits
//
//  Created by Dr. Simon Bogutzky on 11.08.21.
//

import SwiftUI

struct HabitRowView: View {
    @ObservedObject var item: Item
    @Binding var current: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(item.name ?? "").bold().foregroundColor(Color(.systemGray))
            ZStack {
                HStack {
                    ForEach(Array(item.days as? Set<Day> ?? [])
                                .filter({ day in day.date! > current.previous(.monday, considerToday: true)  && day.date! < current.next(.monday) })
                                .sorted(by: { first, second in
                                    first.date! < second.date!
                                }), id: \.self) { day in
                        
                        DayCheckBoxView(day: day)
                    }
                }
                Spacer()
                    .frame(height: 22.0)
            }
        }
    }
}

struct HabitRowView_Previews: PreviewProvider {
    static var item: Item {
        let viewContext = PersistenceController.preview.container.viewContext
        let item = Item(context: viewContext)
        item.name = "Do something"
        item.timestamp = Date().addingTimeInterval(-1 * 24 * 60 * 60)
        
        // TODO: Move to init method
        initializeFirstWeekOfDays(viewContext, item)
        
        return item
    }
    
    @State static var current = Date()
    
    static var previews: some View {
        Group {
            HabitRowView(item: item, current: $current)
        }
    }
}

