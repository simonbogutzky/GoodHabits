//
//  DateTests.swift
//  GoodHabitsTests
//
//  Created by Dr. Simon Bogutzky on 27.09.21.
//

import XCTest
@testable import GoodHabits

class DateTests: XCTestCase {

    func testMidnight() throws {

        // Arrange
        let expectationComponents = DateComponents(
            calendar: Calendar.current,
            timeZone: TimeZone(abbreviation: "GMT"),
            year: 2020,
            month: 1,
            day: 1)
        let expectation = expectationComponents.date

        // Act
        let currentComponents = DateComponents(
            calendar: Calendar.current,
            timeZone: TimeZone(abbreviation: "GMT"),
            year: 2020,
            month: 1,
            day: 1,
            hour: 11,
            minute: 15)
        let midnight = currentComponents.date!.gmtMidnight()

        // Assert
        XCTAssertEqual(expectation, midnight)
    }
}
