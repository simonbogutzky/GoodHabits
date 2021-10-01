//
//  HabitTests.swift
//  GoodHabitsTests
//
//  Created by Dr. Simon Bogutzky on 28.09.21.
//

import XCTest
import CoreData
@testable import GoodHabits

class HabitTests: XCTestCase {

    var persistenceController: PersistenceController!
    var calendar: Calendar!
    
    override func setUpWithError() throws {
        persistenceController = PersistenceController(inMemory: true)
        calendar = Calendar.current
    }
    
    func testAddHabit() throws {
        
        // Arrange
        let viewContext = persistenceController.container.viewContext
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let initialCount = try viewContext.count(for: request)
            XCTAssertEqual(initialCount, 0)
        
        // Act
        _ = Item(context: viewContext)
        
        // Assert
        let finalCount = try viewContext.count(for: request)
        XCTAssertEqual(finalCount, 1)
    }
    
    func testAddHabitHabitNameIsDoSomething() throws {
        
        // Arrange
        let viewContext = persistenceController.container.viewContext
        
        // Act
        let sut = Item(context: viewContext, name: "Do something")
        
        // Assert
        let habitName = sut.name
        XCTAssertEqual("Do something", habitName)
    }
    
    func testAddHabitHabitTimestampIs20210927T161500() throws {
        
        // Arrange
        let viewContext = persistenceController.container.viewContext
        let components = DateComponents(calendar: calendar, timeZone: TimeZone(abbreviation: "GMT"), year: 2021, month: 9, day: 28, hour: 16, minute: 15)
        
        // Act
        let sut = Item(context: viewContext, name: "Do something", timestamp: components.date!)
        
        // Assert
        let habitTimestamp = sut.timestamp
        XCTAssertEqual(components.date, habitTimestamp)
    }
    
    func testAddHabitVisibleDaysCountIs66() throws {
        
        // Arrange
        let viewContext = persistenceController.container.viewContext
        let components = DateComponents(calendar: calendar, timeZone: TimeZone(abbreviation: "GMT"), year: 2021, month: 9, day: 28, hour: 16, minute: 15)
        
        // Act
        let sut = Item(context: viewContext, name: "Do something", timestamp: components.date!)
        
        // Assert
        let dayCount = Array(sut.days as? Set<Day> ?? []).filter({day in day.isVisible}).sorted(by: { first, second in
            first.date! < second.date!
        }).count
        XCTAssertEqual(66, dayCount)
    }
    
    func testAddHabitFirstVisibleDayIs20210928T000000() throws {
        
        // Arrange
        let viewContext = persistenceController.container.viewContext
        let components = DateComponents(calendar: calendar, timeZone: TimeZone(abbreviation: "GMT"), year: 2021, month: 9, day: 28, hour: 16, minute: 15)
        
        // Act
        let sut = Item(context: viewContext, name: "Do something", timestamp: components.date!)
        
        // Assert
        let expectedComponents = DateComponents(calendar: calendar, timeZone: TimeZone(abbreviation: "GMT"), year: 2021, month: 9, day: 28)
        let firstDayDate = Array(sut.days as? Set<Day> ?? []).filter({day in day.isVisible}).sorted(by: { first, second in
            first.date! < second.date!
        }).first?.date
        XCTAssertEqual(expectedComponents.date, firstDayDate)
    }
    
    func testAddHabitLastVisibleDayIs20211202T000000() throws {
        
        // Arrange
        let viewContext = persistenceController.container.viewContext
        let components = DateComponents(calendar: calendar, timeZone: TimeZone(abbreviation: "GMT"), year: 2021, month: 9, day: 28, hour: 16, minute: 15)
        
        // Act
        let sut = Item(context: viewContext, name: "Do something", timestamp: components.date!)
        
        // Assert
        let expectedComponents = DateComponents(calendar: calendar, timeZone: TimeZone(abbreviation: "GMT"), year: 2021, month: 12, day: 02)
        let lastDayDate = Array(sut.days as? Set<Day> ?? []).filter({day in day.isVisible}).sorted(by: { first, second in
            first.date! < second.date!
        }).last?.date
        XCTAssertEqual(expectedComponents.date, lastDayDate)
    }
    
    func testAddHabitFirstDayIs20210927T000000() throws {
        
        // Arrange
        let viewContext = persistenceController.container.viewContext
        let components = DateComponents(calendar: calendar, timeZone: TimeZone(abbreviation: "GMT"), year: 2021, month: 9, day: 28, hour: 16, minute: 15)
        
        // Act
        let sut = Item(context: viewContext, name: "Do something", timestamp: components.date!)
        
        // Assert
        let expectedComponents = DateComponents(calendar: calendar, timeZone: TimeZone(abbreviation: "GMT"), year: 2021, month: 09, day: 27)
        let firstDayDate = Array(sut.days as? Set<Day> ?? []).sorted(by: { first, second in
            first.date! < second.date!
        }).first?.date
        XCTAssertEqual(expectedComponents.date, firstDayDate)
    }
    
    func testAddHabitLastDayIs20211205T000000() throws {
        
        // Arrange
        let viewContext = persistenceController.container.viewContext
        let components = DateComponents(calendar: calendar, timeZone: TimeZone(abbreviation: "GMT"), year: 2021, month: 9, day: 28, hour: 16, minute: 15)
        
        // Act
        let sut = Item(context: viewContext, name: "Do something", timestamp: components.date!)
        
        // Assert
        let expectedComponents = DateComponents(calendar: calendar, timeZone: TimeZone(abbreviation: "GMT"), year: 2021, month: 12, day: 05)
        let lastDayDate = Array(sut.days as? Set<Day> ?? []).sorted(by: { first, second in
            first.date! < second.date!
        }).last?.date
        XCTAssertEqual(expectedComponents.date, lastDayDate)
    }
    
    
    func testAddHabitAllDayCountIs70() throws {
        
        // Arrange
        let viewContext = persistenceController.container.viewContext
        let components = DateComponents(calendar: calendar, timeZone: TimeZone(abbreviation: "GMT"), year: 2021, month: 9, day: 28, hour: 16, minute: 15)
        
        // Act
        let sut = Item(context: viewContext, name: "Do something", timestamp: components.date!)
        
        // Assert
        let dayCount = Array(sut.days as? Set<Day> ?? []).sorted(by: { first, second in
            first.date! < second.date!
        }).count
        XCTAssertEqual(70, dayCount)
    }
}
