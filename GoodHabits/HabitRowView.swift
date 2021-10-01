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
                                .filter({ day in
                        
                        let calendar = Calendar.current
                        let dayDateComponents = calendar.dateComponents([.weekOfYear], from: day.date!)
                        let currentDateComponents = calendar.dateComponents([.weekOfYear], from: current)
                        return currentDateComponents == dayDateComponents
                    })
                                .sorted(by: { first, second in
                        first.date! < second.date!
                    }), id: \.self) { day in
                        DayCheckBoxView(day: day)
                            .debugPrint("Day date: \(day.date!); isDone: \(day.isDone); isVisible: \(day.isVisible); prevMonday: \(current.previous(.monday, considerToday: true)); nextMonday: \(current.next(.monday))")
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
        let calendar = Calendar.current
        let components = DateComponents(calendar: calendar, timeZone: TimeZone(abbreviation: "GMT"), year: 2021, month: 9, day: 30, hour: 16, minute: 15)
        let item = Item(context: viewContext, name: "Do something", timestamp: components.date!)
        return item
    }
    
    @State static var current = Date().midnight()
    
    static var previews: some View {
        Group {
            HabitRowView(item: item, current: $current)
        }
    }
}

