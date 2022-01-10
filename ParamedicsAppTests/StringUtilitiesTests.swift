//
//  Test_StringUtilities.swift
//  ParamedicsAppTests
//
//  Created by Ty Nguyen on 2021-12-04.
//

import XCTest
@testable import ParamedicsApp

class StringUtilitiesTests: XCTestCase {
    
    var phoneNumberText: String!

    override func setUpWithError() throws {
        try super.setUpWithError()
        phoneNumberText = "519-321-0325"
    }

    override func tearDownWithError() throws {
        phoneNumberText = nil
        try super.tearDownWithError()
    }

    func testPhoneNumberValidation() throws {
        // Arrange
        phoneNumberText = "519-323-3526"
        
        // Act
        let isValidPhoneNumber = phoneNumberText.isPhoneNumber
        
        // Assert
        XCTAssertTrue(isValidPhoneNumber, "Phone number is not valid one")
    }
    
    func testPhoneNumberInvalidation() throws {
        // Arrange
        phoneNumberText = "519-323-"
        
        // Act
        let isValidPhoneNumber = phoneNumberText.isPhoneNumber
        
        // Assert
        XCTAssertFalse(isValidPhoneNumber, "Phone number is valid one")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
