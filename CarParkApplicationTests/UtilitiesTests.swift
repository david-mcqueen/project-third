//
//  UtilitiesTests.swift
//  CarParkApplication
//
//  Created by DavidMcQueen on 18/10/2014.
//  Copyright (c) 2014 DavidMcQueen. All rights reserved.
//

import UIKit
import XCTest

class UtilitiesTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testValidEmail(){
        XCTAssertTrue(validateEmail("test@gmail.com"), "Email Validation");
        XCTAssertTrue(validateEmail("test@gmail.co.uk"), "Email Validation");
        XCTAssertTrue(validateEmail("test@gmail.com"), "Email Validation");
        XCTAssertTrue(validateEmail("david_mcqueen@gmail.com"), "Email Validation");
        XCTAssertTrue(validateEmail("1234567890@gmail.com"), "Email Validation");
        XCTAssertTrue(validateEmail("test@stu.mmu.au.uk"), "Email Validation");
        XCTAssertTrue(validateEmail("test@gmail.com"), "Email Validation");
    }
    
    func testInvalidEmail(){
        
        XCTAssertFalse(validateEmail("testATgmail.com"), "Email Validation");
        XCTAssertFalse(validateEmail("test@gmailcom"), "Email Validation");
        XCTAssertFalse(validateEmail("test_@gmailcom"), "Email Validation");
        XCTAssertFalse(validateEmail("test@google.com123"), "Email Validation");
        XCTAssertFalse(validateEmail("test@gmail.com@"), "Email Validation");
        XCTAssertFalse(validateEmail("@test@gmail.com"), "Email Validation");
        XCTAssertFalse(validateEmail("test@gmail.com."), "Email Validation");
    }
    
    

}
