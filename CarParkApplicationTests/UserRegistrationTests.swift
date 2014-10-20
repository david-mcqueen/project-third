//
//  UserRegistrationTests.swift
//  CarParkApplication
//
//  Created by DavidMcQueen on 18/10/2014.
//  Copyright (c) 2014 DavidMcQueen. All rights reserved.
//

import UIKit
import XCTest

class UserRegistrationTests: XCTestCase {

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
    
    func testUserPassValidation(){
        var testUser = UserRegistration(firstName: "David", surname: "McQueen", email: "t@t.com", password: "aPassword1%");
        testUser.validate();
        XCTAssertTrue(testUser.validationSuccess.password, "Validation Passed - Password");
        XCTAssertTrue(testUser.validationSuccess.email, "Validation Passed - Email");

    }
    
    func testUserFailValidation(){
        var testUser = UserRegistration(firstName: "David", surname: "McQueen", email: "tt.com", password: "abcd");
        testUser.validate();
        XCTAssertFalse(testUser.validationSuccess.password, "Validation Failed - Password");
        XCTAssertFalse(testUser.validationSuccess.email, "Validation Failed - Email");
    }
    
    func testMatchingEmailPassword(){
        var testUser = UserRegistration(firstName: "David", surname: "McQueen", email: "tesT@gmail.co.uk", confirmEmail: "Test@GMAIL.CO.UK", password: "abcd12%", confirmPassword: "abcd12%");
        
        XCTAssertTrue(testUser.matchingEmail(), "Matching Email");
        XCTAssertTrue(testUser.matchingPassword(), "Matching Password");
    }
    
    func testNonMatchingEmailPassword(){
        var testUser = UserRegistration(firstName: "David", surname: "McQueen", email: "t@gmail.com", confirmEmail: "t@gmail.co.uk", password: "abcd12%", confirmPassword: "ABCD12%");
        
        XCTAssertFalse(testUser.matchingEmail(), "Non-Matching Email");
        XCTAssertFalse(testUser.matchingPassword(), "Non-Matching Password");
    }
}
