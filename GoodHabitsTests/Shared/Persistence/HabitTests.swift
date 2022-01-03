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

    private var persistenceController: PersistenceController!
    private var viewContext: NSManagedObjectContext!
    private var calendar: Calendar!
    private var startDate: Date!

    override func setUpWithError() throws {
        persistenceController = PersistenceController(inMemory: true)
        viewContext = persistenceController.container.viewContext
        calendar = Calendar.current
        startDate = DateComponents(calendar: calendar, timeZone: TimeZone(abbreviation: "GMT"), year: 2021, month: 9, day: 28, hour: 16, minute: 15).date!
    }

    func testAddHabit() throws {

        // Arrange
        let habitFetchRequest: NSFetchRequest<Habit> = Habit.fetchRequest()
        let initialCount = try viewContext.count(for: habitFetchRequest)
        XCTAssertEqual(initialCount, 0)

        // Act
        _ = Habit(context: viewContext)

        // Assert
        let finalCount = try viewContext.count(for: habitFetchRequest)
        XCTAssertEqual(finalCount, 1)
    }

    func testAddHabitHabitStatementIsDoSomething() throws {

        // Act
        let sut = Habit(context: viewContext, statement: "Do something")

        // Assert
        XCTAssertEqual("Do something", sut.statement)
    }

    func testAddHabitHabitCreatedIs20210927T161500() throws {

        // Act
        let sut = Habit(context: viewContext, statement: "Do something", created: startDate)

        // Assert
        XCTAssertEqual(startDate, sut.created)
    }

    func testAddHabitVisibleDaysCountIs66() throws {

        // Act
        let sut = Habit(context: viewContext, statement: "Do something", created: startDate)

        // Assert
        XCTAssertEqual(66, sut.days!.count)
    }

    func testAddHabitFirstDayIs20210928T000000() throws {

        // Arrange
        let expectedFirstDayDate = DateComponents(calendar: calendar, timeZone: TimeZone(abbreviation: "GMT"), year: 2021, month: 9, day: 28).date!

        // Act
        let sut = Habit(context: viewContext, statement: "Do something", created: startDate)

        // Assert
        let firstDayDate = Array(sut.days as? Set<Day> ?? []).sorted { $0.date! < $1.date! }.first?.date
        XCTAssertEqual(expectedFirstDayDate, firstDayDate)
    }

    func testAddHabitLastDayIs20211202T000000() throws {

        // Arrange
        let expectedLastDayDate = DateComponents(calendar: calendar, timeZone: TimeZone(abbreviation: "GMT"), year: 2021, month: 12, day: 02).date!

        // Act
        let sut = Habit(context: viewContext, statement: "Do something", created: startDate)

        // Assert
        let lastDayDate = Array(sut.days as? Set<Day> ?? []).sorted { $0.date! < $1.date! }.last?.date
        XCTAssertEqual(expectedLastDayDate, lastDayDate)
    }

    func testCheckIfDoneExcludeTwoLastDaysAreTrue() {

        // Arrange
        let checkDate = DateComponents(calendar: calendar, timeZone: TimeZone(abbreviation: "GMT"), year: 2021, month: 9, day: 30).date!
        let sut = Habit(context: viewContext, statement: "Do something", created: startDate)
        let days = Array(sut.days as? Set<Day> ?? []).sorted { $0.date! < $1.date! }
        days[0].isDone = true
        days[1].isDone = true

        // Act
        let isDone = sut.checkIfDone(exclude: 2, until: checkDate)

        // Assert
        XCTAssertTrue(isDone)
    }

    func testCheckIfDoneExcludeTwoLastDaysAreFalse() {

        // Arrange
        let checkDate = DateComponents(calendar: calendar, timeZone: TimeZone(abbreviation: "GMT"), year: 2021, month: 9, day: 30).date!
        let sut = Habit(context: viewContext, statement: "Do something", created: startDate)
        let days = Array(sut.days as? Set<Day> ?? []).sorted { $0.date! < $1.date! }
        days[0].isDone = true

        // Act
        let isDone = sut.checkIfDone(exclude: 1, until: checkDate)

        // Assert
        XCTAssertFalse(isDone)
    }

    func testExcludeDaysExcludedCountIs5() {

        // Arrange
        let excludeDate = DateComponents(calendar: calendar, timeZone: TimeZone(abbreviation: "GMT"), year: 2021, month: 10, day: 3).date!
        let sut = Habit(context: viewContext, statement: "Do something", created: startDate)

        // Act
        let excludedCount = sut.excludeDays(until: excludeDate)

        // Assert
        XCTAssertEqual(5, excludedCount)
    }

    func testAppendDaysOverallCountIs68() {

        // Arrange
        let sut = Habit(context: viewContext, statement: "Do something", created: startDate)
        let initialLastDayDate = Array(sut.days as? Set<Day> ?? []).sorted { $0.date! < $1.date! }.last?.date

        // Act
        sut.appendDays(days: 2, from: initialLastDayDate!.addingTimeInterval(TimeInterval(86400)))

        // Assert
        let overallCount = Array(sut.days as? Set<Day> ?? []).count
        XCTAssertEqual(68, overallCount)
    }

    func testAppendDaysLastDayIs20211204T000000() {

        // Arrange
        let sut = Habit(context: viewContext, statement: "Do something", created: startDate)
        let initialLastDayDate = Array(sut.days as? Set<Day> ?? []).sorted { $0.date! < $1.date! }.last?.date
        let expectedLastDayDate = DateComponents(calendar: calendar, timeZone: TimeZone(abbreviation: "GMT"), year: 2021, month: 12, day: 04).date!

        // Act
        sut.appendDays(days: 2, from: initialLastDayDate!.addingTimeInterval(TimeInterval(86400)))

        // Assert
        let lastDayDate = Array(sut.days as? Set<Day> ?? []).sorted { $0.date! < $1.date! }.last?.date
        XCTAssertEqual(expectedLastDayDate, lastDayDate)
    }
}
