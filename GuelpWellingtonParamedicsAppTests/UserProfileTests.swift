//
//  Test_UserProfile.swift
//  GuelpWellingtonParamedicsAppTests
//
//  Created by Ty Nguyen on 2021-12-05.
//

import XCTest
@testable import GuelpWellingtonParamedicsApp

class UserProfileTests: XCTestCase {
    
    var userProfile: UserProfile!

    override func setUpWithError() throws {
        try super.setUpWithError()
        userProfile = UserProfile(id: "1", firstName: "ThanhTy", lastName: "Nguyen", email: "tyngutha@gmail.com", phoneNumber: "226 334 9020", role: "admin")
    }

    override func tearDownWithError() throws {
        userProfile = nil
        try super.tearDownWithError()
    }

    func testFullNameValidation() throws {
        // Arrange
        // Act
        let fullName = userProfile.fullName()
        
        // Assert
        let expectation = "ThanhTy Nguyen"
        XCTAssertEqual(fullName, expectation)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
