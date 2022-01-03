//
//  HabitListViewModelTests.swift
//  GoodHabitsTests
//
//  Created by Simon Bogutzky on 08.12.21.
//

import XCTest

import CoreData
@testable import GoodHabits

class HabitListViewModelTests: XCTestCase {

    private let startDate = Date().addingTimeInterval(TimeInterval(-3 * 86400))
    private var persistenceController: PersistenceController!
    private var viewContext: NSManagedObjectContext!

    override func setUpWithError() throws {
        persistenceController = PersistenceController(inMemory: true)
        viewContext = persistenceController.container.viewContext
    }

    func testFetchHabitsScenario1() throws {

        // Arrange
        var expectedIsExcluded = Array(repeating: false, count: 69)
        expectedIsExcluded[0] = true
        expectedIsExcluded[1] = true
        expectedIsExcluded[2] = true

        let expectedIsDone = Array(repeating: false, count: 69)

        let sut = HabitListViewModel(viewContext: viewContext)
        let habit = Habit(context: viewContext, statement: "Do something", created: startDate)
        let days = Array(habit.days as? Set<Day> ?? []).sorted { $0.date! < $1.date! }
        days[0].isExcluded = true
        days[1].isExcluded = true
        habit.appendDays(days: 2, from: days.last!.date!)

        // Act
        sut.fetchHabits()

        // Assert
        let habitDays = Array(sut.habits[0].days as? Set<Day> ?? []).sorted { $0.date! < $1.date! }
        let isExcluded = habitDays.map { $0.isExcluded }
        let isDone = habitDays.map { $0.isDone }

        // Assert
        XCTAssertEqual(expectedIsExcluded, isExcluded)
        XCTAssertEqual(expectedIsDone, isDone)
    }

    func testFetchHabitsScenario2() throws {

        // Arrange
        let expectedIsExcluded = Array(repeating: false, count: 66)

        var expectedIsDone = Array(repeating: false, count: 66)
        expectedIsDone[0] = true
        expectedIsDone[1] = true
        expectedIsDone[2] = true

        let sut = HabitListViewModel(viewContext: viewContext)
        let habit = Habit(context: viewContext, statement: "Do something", created: startDate)
        let days = Array(habit.days as? Set<Day> ?? []).sorted { $0.date! < $1.date! }
        days[0].isDone = true
        days[1].isDone = true
        days[2].isDone = true

        // Act
        sut.fetchHabits()

        // Assert
        let habitDays = Array(sut.habits[0].days as? Set<Day> ?? []).sorted { $0.date! < $1.date! }
        let isExcluded = habitDays.map { $0.isExcluded }
        print(isExcluded.count)
        let isDone = habitDays.map { $0.isDone }

        // Assert
        XCTAssertEqual(expectedIsExcluded, isExcluded)
        XCTAssertEqual(expectedIsDone, isDone)
    }

    func testFetchHabitsScenario3() throws {

        // Arrange
        var expectedIsExcluded = Array(repeating: false, count: 69)
        expectedIsExcluded[0] = true
        expectedIsExcluded[1] = true
        expectedIsExcluded[2] = true

        var expectedIsDone = Array(repeating: false, count: 69)
        expectedIsDone[0] = true

        let sut = HabitListViewModel(viewContext: viewContext)
        let habit = Habit(context: viewContext, statement: "Do something", created: startDate)
        let days = Array(habit.days as? Set<Day> ?? []).sorted { $0.date! < $1.date! }
        days[0].isDone = true

        // Act
        sut.fetchHabits()

        // Assert
        let habitDays = Array(sut.habits[0].days as? Set<Day> ?? []).sorted { $0.date! < $1.date! }
        let isExcluded = habitDays.map { $0.isExcluded }
        print(isExcluded.count)
        let isDone = habitDays.map { $0.isDone }

        // Assert
        XCTAssertEqual(expectedIsExcluded, isExcluded)
        XCTAssertEqual(expectedIsDone, isDone)
    }
}
