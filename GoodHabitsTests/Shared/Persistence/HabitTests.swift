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
        let request: NSFetchRequest<Habit> = Habit.fetchRequest()
        let initialCount = try viewContext.count(for: request)
            XCTAssertEqual(initialCount, 0)

        // Act
        _ = Habit(context: viewContext)

        // Assert
        let finalCount = try viewContext.count(for: request)
        XCTAssertEqual(finalCount, 1)
    }

    func testAddHabitHabitNameIsDoSomething() throws {

        // Arrange
        let viewContext = persistenceController.container.viewContext

        // Act
        let sut = Habit(context: viewContext, statement: "Do something")

        // Assert
        let habitStatement = sut.statement
        XCTAssertEqual("Do something", habitStatement)
    }

    func testAddHabitHabitTimestampIs20210927T161500() throws {

        // Arrange
        let viewContext = persistenceController.container.viewContext
        let components = DateComponents(
            calendar: calendar,
            timeZone: TimeZone(abbreviation: "GMT"),
            year: 2021,
            month: 9,
            day: 28,
            hour: 16,
            minute: 15
        )

        // Act
        let sut = Habit(context: viewContext, statement: "Do something", created: components.date!)

        // Assert
        let habitCreated = sut.created
        XCTAssertEqual(components.date, habitCreated)
    }

    func testAddHabitVisibleDaysCountIs66() throws {

        // Arrange
        let viewContext = persistenceController.container.viewContext
        let components = DateComponents(
            calendar: calendar,
            timeZone: TimeZone(abbreviation: "GMT"),
            year: 2021,
            month: 9,
            day: 28,
            hour: 16,
            minute: 15
        )

        // Act
        let sut = Habit(context: viewContext, statement: "Do something", created: components.date!)

        // Assert
        XCTAssertEqual(66, sut.days?.count)
    }

    func testAddHabitFirstVisibleDayIs20210928T000000() throws {

        // Arrange
        let viewContext = persistenceController.container.viewContext
        let components = DateComponents(
            calendar: calendar,
            timeZone: TimeZone(abbreviation: "GMT"),
            year: 2021,
            month: 9,
            day: 28,
            hour: 16,
            minute: 15
        )

        // Act
        let sut = Habit(context: viewContext, statement: "Do something", created: components.date!)

        // Assert
        let expectedComponents = DateComponents(
            calendar: calendar,
            timeZone: TimeZone(abbreviation: "GMT"),
            year: 2021,
            month: 9,
            day: 28
        )
        let firstDayDate = Array(sut.days as? Set<Day> ?? [])
            .sorted(by: { first, second in
                first.date! < second.date!
            })
            .first?.date
        XCTAssertEqual(expectedComponents.date, firstDayDate)
    }

    func testAddHabitLastVisibleDayIs20211202T000000() throws {

        // Arrange
        let viewContext = persistenceController.container.viewContext
        let components = DateComponents(
            calendar: calendar,
            timeZone: TimeZone(abbreviation: "GMT"),
            year: 2021,
            month: 9,
            day: 28,
            hour: 16,
            minute: 15
        )

        // Act
        let sut = Habit(context: viewContext, statement: "Do something", created: components.date!)

        // Assert
        let expectedComponents = DateComponents(
            calendar: calendar,
            timeZone: TimeZone(abbreviation: "GMT"),
            year: 2021,
            month: 12,
            day: 02
        )
        let lastDayDate = Array(sut.days as? Set<Day> ?? [])
            .sorted(by: { first, second in
                first.date! < second.date!
            })
            .last?.date
        XCTAssertEqual(expectedComponents.date, lastDayDate)
    }
}
