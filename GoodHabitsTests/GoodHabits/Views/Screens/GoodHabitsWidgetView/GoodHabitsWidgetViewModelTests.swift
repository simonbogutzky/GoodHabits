//
//  GoodHabitsWidgetViewModelTests.swift
//  GoodHabitsTests
//
//  Created by Simon Bogutzky on 01.12.21.
//

import XCTest
import CoreData
@testable import GoodHabits

class GoodHabitsWidgetViewModelTests: XCTestCase {

    var persistenceController: PersistenceController!
    var calendar: Calendar!
    var sut: GoodHabitsWidgetView.GoodHabitsWidgetViewModel!

    override func setUpWithError() throws {
        persistenceController = PersistenceController(inMemory: true)
        calendar = Calendar.current
        sut = GoodHabitsWidgetView.GoodHabitsWidgetViewModel(viewContext: persistenceController.container.viewContext)
    }

    func testFetchMissingStatementsOfTodayIs4() throws {

        // Arrange
        let viewContext = persistenceController.container.viewContext
        let yesterday = Date().addingTimeInterval(-1 * 60 * 60 * 24)

        _ = Habit(context: viewContext, statement: "Do something", created: yesterday)
        _ = Habit(context: viewContext, statement: "Do something the second time", created: yesterday)
        do {
            try viewContext.save()
        } catch {
            print("❌ save error")
        }

        // Act
        sut.fetchMissingStatementsOfToday()

        // Assert
        XCTAssertEqual(sut.missingStatements, 4)
    }

}
