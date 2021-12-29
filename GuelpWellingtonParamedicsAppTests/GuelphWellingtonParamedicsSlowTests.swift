//
//  Test_ParamedicsAppSlow.swift
//  GuelpWellingtonParamedicsAppTests
//
//  Created by Ty Nguyen on 2021-12-05.
//

import XCTest
@testable import GuelpWellingtonParamedicsApp

class GuelphWellingtonParamedicsSlowTests: XCTestCase {
    
    var sut: URLSession!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = URLSession(configuration: .default)
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func testApiCallCompletes() throws {
        try XCTSkipUnless(NetworkMonitor.isReachable(), "Network connectivity needed for this test.")
        
        // given
        let urlString = "http://www.randomnumberapi.com/api/v1.0/random?min=0&max=100&count=1"
        let url = URL(string: urlString)!
        let promise = expectation(description: "Completion handler invoked")
        var statusCode: Int?
        var responseError: Error?
        
        // when
        let dataTask = sut.dataTask(with: url) { _, response, error in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error
            promise.fulfill()
        }
        dataTask.resume()
        wait(for: [promise], timeout: 5)
        
        // then
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
