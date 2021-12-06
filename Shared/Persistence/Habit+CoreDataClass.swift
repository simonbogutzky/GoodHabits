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

        let midnight = created.midnight()
        let dayCount = 66

        for index in 0..<dayCount {
            let day = Day(context: context)
            day.date = midnight.addingTimeInterval(Double(index) * 60.0 * 60.0 * 24.0)
            self.addToDays(day)
        }
    }
}
