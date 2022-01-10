//
//  Test_EmailUtilities.swift
//  ParamedicsAppTests
//
//  Created by Ty Nguyen on 2021-12-04.
//

import XCTest
@testable import ParamedicsApp

class EmailUtilitiesTests: XCTestCase {
    
    var recipientEmail: String!
    var subject: String!
    var body: String!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        recipientEmail = nil
        subject = nil
        body = nil
        try super.tearDownWithError()
    }

    func testEmailURLValidation() throws {
        // Arrange
        recipientEmail = "amy.benn@guelph.ca"
        subject = "paramedics notification"
        body = "new email content"
        
        // Act
        let emailURL = EmailUtilities.createEmailURL(to: recipientEmail, subject: subject, body: body)!
        
        
        // Assert
        let expectation = "mailto:amy.benn@guelph.ca?subject=paramedics%20notification&body=new%20email%20content"
        let emailURLString = emailURL.absoluteString
        XCTAssertEqual(expectation, emailURLString)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
