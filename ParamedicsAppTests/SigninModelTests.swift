//
//  ParamedicsAppTests.swift
//  ParamedicsAppTests
//
//  Created by Ty Nguyen on 2021-10-04.
//

import XCTest
@testable import ParamedicsApp

class SigninModelTests: XCTestCase {
    var model: SignInModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        model = SignInModel(email: "paramedics@guelph.ca", password: "admin0$6")
    }

    override func tearDownWithError() throws {
        model = nil
        try super.tearDownWithError()
    }
    
    func testEmailValidation() throws {
        // Arrange
        model.email = "admin@guelph.ca"
        
        // Act
        let isValidEmail = model.isValidEmail
        
        // Assert
        XCTAssertTrue(isValidEmail, "Email is not valid")
    }
    
    func testEmailInvalidation() throws {
        // Arrange
        model.email = "admin@guelph."
        
        // Act
        let isValidEmail = model.isValidEmail
        
        // Assert
        XCTAssertFalse(isValidEmail, "Email is valid")
    }
    
    func testPasswordValidation() throws {
        // Arrange
        model.password = "Admin123!"
        
        // Act
        let isValidPassword = model.isValidPassword
        
        // Assert
        XCTAssertTrue(isValidPassword, "Password is not a valid one")
    }
    
    func testPasswordInvalidation() throws {
        // Arrange
        model.password = "Admin"
        
        // Act
        let isValidPassword = model.isValidPassword
        
        // Assert
        XCTAssertFalse(isValidPassword, "Password is valid one")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
