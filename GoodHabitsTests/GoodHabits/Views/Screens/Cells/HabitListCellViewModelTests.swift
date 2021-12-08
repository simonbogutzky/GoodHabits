//
//  HabitListCellViewModelTests.swift
//  GoodHabitsTests
//
//  Created by Simon Bogutzky on 02.12.21.
//

import XCTest
import CoreData
@testable import GoodHabits

class HabitListCellViewModelTests: XCTestCase {

    var persistenceController: PersistenceController!
    let yesterday = Date().addingTimeInterval(-2 * 60 * 60 * 24)

    override func setUpWithError() throws {
        persistenceController = PersistenceController(inMemory: true)
    }

    func testGetDaysRemainingIs66() throws {

        // Arrange
        let habit = Habit(
            context: persistenceController.container.viewContext,
            statement: "Do something",
            created: yesterday
        )

        // Act
        let sut = HabitListCell.HabitListCellViewModel(habit: habit, date: Date())

        // Assert
        XCTAssertEqual(sut.dayRemainingString, String(
            format: NSLocalizedString("%@ days left", comment: ""), "66"))
    }

    func testDaysRemainingStringIs64() throws {

        // Arrange
        let habit = Habit(
            context: persistenceController.container.viewContext,
            statement: "Do something",
            created: yesterday
        )
        let days = Array(habit.days as? Set<Day> ?? []).sorted { $0.date! < $1.date! }
        days[0].isDone = true
        days[1].isDone = true

        // Act
        let sut = HabitListCell.HabitListCellViewModel(habit: habit, date: Date())

        // Assert
        XCTAssertEqual(sut.dayRemainingString, String(
            format: NSLocalizedString("%@ days left", comment: ""), "64"))
    }
}
