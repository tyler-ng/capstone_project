//
//  AssessmentFormUITests.swift
//  ParamedicsAppUITests
//
//  Created by Ty Nguyen on 2021-12-11.
//

import XCTest
@testable import ParamedicsApp

class AssessmentFormsUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("ui-AssessmentFoldersTesting")

        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
    }

    func testValidAssessmentFolders() {
        let navBarTitle = app.navigationBars["Folders"]
        let assessmentFoldersCell = app.tables.staticTexts["Assessment Folder"]
        
        XCTAssert(navBarTitle.exists)
        XCTAssertTrue(assessmentFoldersCell.exists)
    }
    
    func testShowingAssessmentItems() {
        let assessFoldersCell = app.tables.staticTexts["Assessment Folder"]
        assessFoldersCell.tap()
        
        let assessmentItems = app.navigationBars["Assessments"]
        XCTAssert(assessmentItems.exists)
    }
    
    func testShowingClientFallRiskAssessmentForm() {
        let assessFoldersCell = app.tables.staticTexts["Assessment Folder"]
        assessFoldersCell.tap()
        let assessmentItemCell = app.tables.staticTexts["Client Fall Risk Assessment"]
        XCTAssert(assessmentItemCell.exists)
        
        assessmentItemCell.tap()
        XCTAssert(app.navigationBars["Client Fall Risk Assessment"].exists)
    }
}
