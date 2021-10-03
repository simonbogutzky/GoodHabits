//
//  Item+CoreDataClass.swift
//  GoodHabits
//
//  Created by Dr. Simon Bogutzky on 29.09.21.
//
//

import Foundation
import CoreData

@objc(Item)
public class Item: NSManagedObject {
    public required convenience init(context: NSManagedObjectContext, name: String, timestamp: Date = Date()) {
        self.init(context: context)
        self.name = name
        self.timestamp = timestamp

        let midnight = timestamp.midnight()
        let dayCount = 66

        for index in 0..<dayCount {
            let day = Day(context: context)
            day.isVisible = true
            day.date = midnight.addingTimeInterval(Double(index) * 60.0 * 60.0 * 24.0)
            self.addToDays(day)
        }

        let previousMondayMidnight = midnight.previous(.monday, considerToday: true)
        let leadingDays = Int(previousMondayMidnight.distance(to: midnight) / 60.0 / 60.0 / 24.0)

        for index in 0..<leadingDays {
            let day = Day(context: context)
            day.date = previousMondayMidnight.addingTimeInterval(Double(index) * 60.0 * 60.0 * 24.0)
            self.addToDays(day)
        }

        let lastDayMidnight = midnight.addingTimeInterval(Double(dayCount) * 60.0 * 60.0 * 24.0)
        let lastMondayMidnight = lastDayMidnight.next(.monday, considerToday: true)
        let trailingDays = Int(lastDayMidnight.distance(to: lastMondayMidnight) / 60.0 / 60.0 / 24.0)

        for index in 0..<trailingDays {
            let day = Day(context: context)
            day.date = lastDayMidnight.addingTimeInterval(Double(index) * 60.0 * 60.0 * 24.0)
            self.addToDays(day)
        }
    }
}
