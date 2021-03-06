//
//  Habit+CoreDataClass.swift
//  GoodHabits
//
//  Created by Dr. Simon Bogutzky on 29.09.21.
//
//

import Foundation
import CoreData

@objc(Habit)
public class Habit: NSManagedObject {
    public required convenience init(context: NSManagedObjectContext, statement: String, created: Date = Date()) {
        self.init(context: context)
        self.statement = statement
        self.created = created

        appendDays(days: 66, from: created.gmtMidnight())
    }

    func appendDays(days: Int, from date: Date) {
        for index in 0..<days {
            let day = Day(context: self.managedObjectContext!)
            day.date = date.addingTimeInterval(TimeInterval(index * 86400))
            self.addToDays(day)
        }
    }

    func checkIfDone(exclude lastDays: Int, until date: Date = Date().gmtMidnight()) -> Bool {
        let habitDays = Array(self.days as? Set<Day> ?? []).filter { !$0.isExcluded }.sorted { $0.date! < $1.date! }

        var endIndex = habitDays.firstIndex { $0.date == date }
        guard endIndex != nil else { return true }

        endIndex = endIndex! - lastDays
        guard endIndex! >= 0 else { return true }

        print("Is Done check:")
        for index in 0...endIndex! {
            print("\(habitDays[index].date!) : \(habitDays[index].isDone)")
            guard habitDays[index].isDone else {
                return false
            }
        }

        return true
    }

    func excludeDays(until date: Date = Date().gmtMidnight()) -> Int {
        let habitDays = Array(self.days as? Set<Day> ?? []).filter { !$0.isExcluded }.sorted { $0.date! < $1.date! }

        guard let firstIndex = habitDays.firstIndex(where: { $0.date == date}) else { return 0 }

        let endIndex = firstIndex - 1
        guard endIndex >= 0 else { return 0 }

        print("Excluded days:")
        for index in 0...endIndex {
            print("\(habitDays[index].date!) : \(habitDays[index].isExcluded)")
            habitDays[index].isExcluded = true
        }

        return endIndex + 1
    }
}
