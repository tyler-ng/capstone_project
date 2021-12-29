//
//  GuelpWellingtonParamedicsAppUITests.swift
//  GuelpWellingtonParamedicsAppUITests
//
//  Created by Ty Nguyen on 2021-10-04.
//

import XCTest

class SignInScreenUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app.launchArguments = []
    }

    func testSignInButtonDisplays() {
        XCTAssertTrue(app.buttons["Sign In"].exists)
    }
    
    func testCannotSignInAlert() {
        app.buttons["Sign In"].tap()
        
        let alertDialog = app.alerts
        
        XCTAssertEqual(alertDialog.element.label, "Cannot Sign In")
        
        alertDialog.buttons["OK"].tap()
    }
    
    func testInvalidEmailAndPasswordMessageDisplay() {
        let emailTF = app.textFields["Enter your email"]
        emailTF.tap()
        emailTF.typeText("admin@guelph.")
        app.keyboards.buttons["return"].tap()
        
        let passwordTF = app.secureTextFields["Enter your password"]
        passwordTF.tap()
        passwordTF.typeText("Admin")
        app.keyboards.buttons["return"].tap()
        
        app.buttons["Sign In"].tap()
        let unvalidEmailLabel = app.staticTexts.element(matching: .any, identifier: "invalidEmailLabel").label

        XCTAssertEqual(unvalidEmailLabel, "* Invalid email")
    }
    
    func testSucceedSignIn() {
        let emailTF = app.textFields["Enter your email"]
        XCTAssertTrue(emailTF.exists)
        emailTF.tap()
        emailTF.typeText("admin@guelph.ca")
        app.keyboards.buttons["return"].tap()
        
        let passwordTF = app.secureTextFields["Enter your password"]
        XCTAssertTrue(passwordTF.exists)
        passwordTF.tap()
        passwordTF.typeText("Admin!234")
        app.keyboards.buttons["return"].tap()
        
        app.buttons["Sign In"].tap()
        
        let assessmentFolderNavbar = app.navigationBars["Folders"]
        
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: assessmentFolderNavbar, handler: nil)
        
        waitForExpectations(timeout: 3, handler: nil)
    }
}
