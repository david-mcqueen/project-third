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
    
    func testUserRegistrationClassValidationFunctionsValid(){
        var testUser = UserRegistration(
            _firstName: "David",
            _surname: "McQueen",
            _email: "tesT@gmail.co.uk",
            _confirmEmail: "Test@GMAIL.CO.UK",
            _password: "abcD12%",
            _confirmPassword: "abcd12%",
            _phoneNumber: "12345678901",
            _confirmPhoneNumber:"12345678901");
        
        XCTAssertTrue(testUser.validPasswordPattern(), "Valid Password");
        XCTAssertTrue(testUser.validEmailPattern(), "Valid Email");
        XCTAssertTrue(testUser.validPhonePattern(), "Valid Phone");
        
        testUser.Email = "test@gmail.com";
        XCTAssertTrue(testUser.validEmailPattern(), "Valid Email");
        
        testUser.Email =  "test@gmail.co.uk";
        XCTAssertTrue(testUser.validEmailPattern(), "Valid Email");
        
        testUser.Email = "test@gmail.com";
        XCTAssertTrue(testUser.validEmailPattern(), "Valid Email");
        
        testUser.Email = "david_mcqueen@gmail.com";
        XCTAssertTrue(testUser.validEmailPattern(), "Valid Email");
        
        testUser.Email = "1234567890@gmail.com";
        XCTAssertTrue(testUser.validEmailPattern(), "Valid Email");
        
        testUser.Email = "test@stu.mmu.au.uk";
        XCTAssertTrue(testUser.validEmailPattern(), "Valid Email");
        
        testUser.Email = "test@gmail.com";
        XCTAssertTrue(testUser.validEmailPattern(), "Valid Email");

        testUser.Password = "passWord123@";
        XCTAssertTrue(testUser.validPasswordPattern(), "Valid Password");
        
        testUser.Password = "passWord123";
        XCTAssertTrue(testUser.validPasswordPattern(), "Valid Password");
        
        testUser.Password = "passWo3";
        XCTAssertTrue(testUser.validPasswordPattern(), "Valid Password");
    }
    
    
    func testUserRegistrationClassValidationFunctionsInvalid(){
        var testUser = UserRegistration(
            _firstName: "David",
            _surname: "McQueen",
            _email: "testATgmail.com",
            _confirmEmail: "testATgmail.com",
            _password: "",
            _confirmPassword: "abcd12%",
            _phoneNumber: "",
            _confirmPhoneNumber:"12345678901");
        
        XCTAssertFalse(testUser.validEmailPattern(), "Email Validation - No @");
        XCTAssertFalse(testUser.validPasswordPattern(), "Password Validation - Empty");
        XCTAssertFalse(testUser.validPasswordPattern(), "Phone Validation - Empty");
        
        testUser.Email = "test@gmailcom";
        XCTAssertFalse(testUser.validEmailPattern(), "Email Validation - No .");
        
        testUser.Email = "test_@gmailcom";
        XCTAssertFalse(testUser.validEmailPattern(), "Email Validation - Misplaced _");
        
        testUser.Email = "test@google.com123";
        XCTAssertFalse(testUser.validEmailPattern(), "Email Validation - Ending number");
        
        testUser.Email = "test@gmail.com@";
        XCTAssertFalse(testUser.validEmailPattern(), "Email Validation - Ending @");
        
        testUser.Email = "@test@gmail.com";
        XCTAssertFalse(testUser.validEmailPattern(), "Email Validation - Starting @");
        
        testUser.Email = "test@gmail.com.";
        XCTAssertFalse(testUser.validEmailPattern(), "Email Validation - Ending .");
        
        testUser.Email = ".test@gmail.com.";
        XCTAssertFalse(testUser.validEmailPattern(), "Email Validation - Starting .");
        
        
        testUser.Password = "pA1@";
        XCTAssertFalse(testUser.validPasswordPattern(), "Password Validation - Short");
        
        testUser.Password = "password123@";
        XCTAssertFalse(testUser.validPasswordPattern(), "Password Validation - Upper Case");
        
        testUser.Password = "passWord";
        XCTAssertFalse(testUser.validPasswordPattern(), "Password Validation - Number");
        
        testUser.Password = "passWord@!";
        XCTAssertFalse(testUser.validPasswordPattern(), "Password Validation - Number");
        
        testUser.PhoneNumber = "0";
        XCTAssertFalse(testUser.validPhonePattern(), "Phone Validation - Short");
        
        testUser.PhoneNumber = "012345678901";
        XCTAssertFalse(testUser.validPhonePattern(), "Phone Validation - Long");
        
        testUser.PhoneNumber = "012345678901zdfhjv";
        XCTAssertFalse(testUser.validPhonePattern(), "Phone Validation - Letters");
        
        testUser.PhoneNumber = "isydfgh";
        XCTAssertFalse(testUser.validPhonePattern(), "Phone Validation - Letters");
        
        testUser.PhoneNumber = "%&*^$&&%";
        XCTAssertFalse(testUser.validPhonePattern(), "Phone Validation - Symbols");
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
