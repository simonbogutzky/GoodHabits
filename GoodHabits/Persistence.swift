//
//  Persistence.swift
//  GoodHabits
//
//  Created by Simon Bogutzky on 04.08.21.
//

import CoreData

public func initializeFirstWeekOfDays(_ viewContext: NSManagedObjectContext, _ item: Item) {    
   
    let previousMonday = item.timestamp!.previous(.monday, considerToday: true)
    let today = item.timestamp
    let lastDay = item.timestamp?.addingTimeInterval(66 * 24 * 60 * 60)
    let lastSunday = lastDay?.next(.sunday)
    
    let days = Int(round(previousMonday.distance(to: lastSunday!) / (24 * 60 * 60)))
    
    for i in 0...days {
        
        let day = Day(context: viewContext)
        day.date = previousMonday.addingTimeInterval(TimeInterval(i * 24 * 60 * 60))
        day.isDone = false
        day.isVisible = true
        
        if previousMonday <= day.date! && day.date! < today! {
            day.isVisible = false
        }
        
        if lastDay! < day.date! && day.date! <= lastSunday! {
            day.isVisible = false
        }
        
        item.addToDays(day)
    }
}

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for i in 0..<10 {
            let item = Item(context: viewContext)
            item.name = "Habits \(i)"
            item.timestamp = Date()
            
            initializeFirstWeekOfDays(viewContext, item)
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "GoodHabits")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
