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

    private let startDate = Date().addingTimeInterval(TimeInterval(-4 * 86400))
    private var persistenceController: PersistenceController!
    private var viewContext: NSManagedObjectContext!
    private var habit: Habit!

    override func setUpWithError() throws {
        persistenceController = PersistenceController(inMemory: true)
        viewContext = persistenceController.container.viewContext
        habit = Habit(context: viewContext, statement: "Do something", created: startDate)
    }

    func testDayRemainingStringIs66() throws {

        // Act
        let sut = HabitListCell.HabitListCellViewModel(habit: habit, date: Date(), currentDate: Date())

        // Assert
        XCTAssertEqual(sut.dayRemainingString, String(format: NSLocalizedString("%@ days left", comment: ""), "66"))
    }

    func testDaysRemainingStringIs64() throws {

        // Arrange
        let days = Array(habit.days as? Set<Day> ?? []).sorted { $0.date! < $1.date! }
        days[0].isDone = true
        days[1].isDone = true

        // Act
        let sut = HabitListCell.HabitListCellViewModel(habit: habit, date: Date(), currentDate: Date())

        // Assert
        XCTAssertEqual(sut.dayRemainingString, String(format: NSLocalizedString("%@ days left", comment: ""), "64"))
    }
}
