//
//  UserRegistrationTests.swift
//  CarParkApplication
//
//  Created by DavidMcQueen on 18/10/2014.
//  Copyright (c) 2014 DavidMcQueen. All rights reserved.
//

import UIKit
import XCTest

class ClassTests: XCTestCase {
    
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
    
    //MARK:- UserRegistration
    
    func testMatchingData(){
        
        var testUser = UserRegistration(
                _firstName: "David",
                _surname: "McQueen",
                _email: "tesT@gmail.co.uk",
                _confirmEmail: "Test@GMAIL.CO.UK",
                _password: "abcd12%",
                _confirmPassword: "abcd12%",
                _phoneNumber: "12345678901",
                _confirmPhoneNumber:"12345678901");
        
        XCTAssertTrue(testUser.matchingEmail(), "Matching Email");
        XCTAssertTrue(testUser.matchingPassword(), "Matching Password");
        XCTAssertTrue(testUser.matchingPhoneNumber(), "Matching PhoneNumber");
    }
    
    func testNonMatchingData(){
        
        var testUser = UserRegistration(
                _firstName: "David",
                _surname: "McQueen",
                _email: "t@gmail.com",
                _confirmEmail: "t@gmail.co.uk",
                _password: "abcd12%",
                _confirmPassword: "ABCD12%",
                _phoneNumber: "10987654321",
                _confirmPhoneNumber:"12345678901");
        
        XCTAssertFalse(testUser.matchingEmail(), "Non-Matching Email");
        XCTAssertFalse(testUser.matchingPassword(), "Non-Matching Password");
        XCTAssertFalse(testUser.matchingPhoneNumber(), "Non-Matching PhoneNumber");
    }
    
    //MARK:- UserLogin
    
    func testEmptyUserFields() {
        var testUser = UserLogin(userName: "", password: "");
        
        XCTAssertTrue(testUser.emptyInputPassword(), "Empty Password");
        XCTAssertTrue(testUser.emptyInputUsername(), "Empty Username");
    }
    
    func testFilledUserFields() {
        var testUser = UserLogin(userName: "testUser@gmail.com", password: "Pa$$w0rd");
        
        XCTAssertFalse(testUser.emptyInputPassword(), "Empty Password");
        XCTAssertFalse(testUser.emptyInputUsername(), "Empty Username");
    }
}
