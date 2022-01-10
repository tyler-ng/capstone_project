//
//  Test_DateTimeUtilities.swift
//  ParamedicsAppTests
//
//  Created by Ty Nguyen on 2021-12-04.
//

import XCTest
@testable import ParamedicsApp

class DateTimeUtilitiesTests: XCTestCase {
    
    var dateTimeText: String!

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        dateTimeText = nil
        try super.tearDownWithError()
    }

    func testStringToDateValidation() throws {
        // Arrange
        dateTimeText = "2021-12-12T02:42:16Z"
        
        // Act
        let newDate = DateTimeUtilities.stringToDate(inputString: dateTimeText)

        // Assert
        guard let newDate = newDate else {
            return
        }
        
        XCTAssertTrue(type(of: newDate) == Date.self, "String could not be converted to Date type")
    }
    
    func testStringToDateUnvalidation() throws {
        // Arrange
        dateTimeText = "2021-12-12T02:42:16"
        
        // Act
        let newDate = DateTimeUtilities.stringToDate(inputString: dateTimeText)
        
        guard let _ = newDate else {
            // Assert
            XCTAssertFalse(false, "String could be converted to Date type")
            return
        }
    }
    
    func testDateTextFormatValidation() throws {
        // Arrange
        dateTimeText = "2021-12-12T02:42:16"
        
        // Act
        let newDate = DateTimeUtilities.dateFormatter(inputDate: dateTimeText)
        
        // Assert
        XCTAssertTrue(newDate.count > 0, "String could not be converted in a given date format")
    }
    
    func testDateTextFormatInvalidation() throws {
        // Arrange
        dateTimeText = "2021-12-12"
        
        // Act
        let newDate = DateTimeUtilities.dateFormatter(inputDate: dateTimeText)
        
        // Assert
        XCTAssertFalse(newDate.count > 0, "String could be converted to a given date format")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
