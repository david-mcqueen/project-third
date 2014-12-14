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
    
    
    //MARK:- Email Validation Tests
    
    func testValidEmail(){
        //Test valid emails are returned valid
        XCTAssertTrue(validateEmail("test@gmail.com"), "Email Validation");
        XCTAssertTrue(validateEmail("test@gmail.co.uk"), "Email Validation");
        XCTAssertTrue(validateEmail("test@gmail.com"), "Email Validation");
        XCTAssertTrue(validateEmail("david_mcqueen@gmail.com"), "Email Validation");
        XCTAssertTrue(validateEmail("1234567890@gmail.com"), "Email Validation");
        XCTAssertTrue(validateEmail("test@stu.mmu.au.uk"), "Email Validation");
        XCTAssertTrue(validateEmail("test@gmail.com"), "Email Validation");
    }
    
    func testInvalidEmail(){
        //Test invalid emails are returned invalid
        XCTAssertFalse(validateEmail("testATgmail.com"), "Email Validation - No @");
        XCTAssertFalse(validateEmail("test@gmailcom"), "Email Validation - No .");
        XCTAssertFalse(validateEmail("test_@gmailcom"), "Email Validation - Misplaced _");
        XCTAssertFalse(validateEmail("test@google.com123"), "Email Validation - Ending number");
        XCTAssertFalse(validateEmail("test@gmail.com@"), "Email Validation - Ending @");
        XCTAssertFalse(validateEmail("@test@gmail.com"), "Email Validation - Starting @");
        XCTAssertFalse(validateEmail("test@gmail.com."), "Email Validation - Ending .");
        XCTAssertFalse(validateEmail(".test@gmail.com."), "Email Validation - Starting .");
    }
    
    
    //MARK:- Password Validation Tests
    
    func testValidPassword(){
        //Test valid passwords are returned valid
        XCTAssertTrue(validatePassword("passWord123@"), "Password Validation");
        XCTAssertTrue(validatePassword("passWord123"), "Password Validation");
        XCTAssertTrue(validatePassword("passWo3"), "Password Validation - Min length");
    }
    
    func testInvalidPassword(){
        //Test invalid passwords are returned invalid
        XCTAssertFalse(validatePassword(""), "Password Validation - Empty");
        XCTAssertFalse(validatePassword("pA1@"), "Password Validation - Short");
        XCTAssertFalse(validatePassword("password123@"), "Password Validation - Upper Case");
        XCTAssertFalse(validatePassword("passWord"), "Password Validation - Number");
        XCTAssertFalse(validatePassword("passWord@!"), "Password Validation - Number");
    }

    //MARK:- Encryption & Decryption Tests
    
    func testStringEncryption(){
        //Tests that a string is encrypted correctly
        //Once we decide on an encryption method
        
        //This needs to be changed to XCTAssertEqual()
        XCTAssertNotEqual("Call Function And Encrypt String", "Encrypted string to compare", "String Encryption");
    }
    
    func testStringDecryption(){
        //Tests that a string is decrypted correctly
        //Once we decide on an encryption method
        
        //This needs to be changed to XCTAssertEqual()
        XCTAssertNotEqual("Call Function And Decrypt String", "Decrypted string to compare", "String Decryption");
    }
}
