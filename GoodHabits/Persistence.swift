//
//  Persistence.swift
//  GoodHabits
//
//  Created by Dr. Simon Bogutzky on 04.08.21.
//

import CoreData

class PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for index in 0..<10 {
            _ = Item(context: viewContext, name: "Habits \(index)")
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate.
            // You should not use this function in a shipping application,
            // although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    static var managedObjectModel: NSManagedObjectModel = {
        let bundle = Bundle(for: PersistenceController.self)

        guard let url = bundle.url(forResource: "GoodHabits", withExtension: "momd") else {
            fatalError("Failed to locate momd file for GoodHabits")
        }

        guard let model = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Failed to load momd file for GoodHabits")
        }

        return model
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "GoodHabits",
                                          managedObjectModel: Self.managedObjectModel)
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate.
                // You should not use this function in a shipping application,
                // although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible,
                 due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
