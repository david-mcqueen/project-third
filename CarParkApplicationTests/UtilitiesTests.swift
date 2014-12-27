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

    //MARK:- PhoneNumber validation Tests
    
    func testValidPhoneNumber(){
        XCTAssertTrue(validatePhoneNumber("01234567891"), "Phone Validation");
    }
    
    
    func testInvalidPhoneNumber(){
        XCTAssertFalse(validatePhoneNumber(""), "Phone Validation - Empty");
        XCTAssertFalse(validatePhoneNumber("0"), "Phone Validation - Short");
        XCTAssertFalse(validatePhoneNumber("012345678901"), "Phone Validation - Long");
        XCTAssertFalse(validatePhoneNumber("012345678901zdfhjv"), "Phone Validation - Letters");
        XCTAssertFalse(validatePhoneNumber("isydfgh"), "Phone Validation - Letters");
        XCTAssertFalse(validatePhoneNumber("%&*^$&&%"), "Phone Validation - Symbols");
    }
    
    //MARK:- GUID validation tests
    
    func testValidGUID(){
        XCTAssertTrue(validateGUID("192317b4-8dd4-11e4-aa9b-001e8c3af66d"), "GUID Validation")
        XCTAssertTrue(validateGUID("6e4aafa7-8171-496e-9e9e-5f960dd842af"), "GUID Validation")
        XCTAssertTrue(validateGUID("c425b02d-eca5-4971-b9fe-278b718770df"), "GUID Validation")
        XCTAssertTrue(validateGUID("2ac80dbd-0034-4905-8874-86b0248e124e"), "GUID Validation")
        XCTAssertTrue(validateGUID("c116af05-e41a-4616-8efc-0e8d130cc21f"), "GUID Validation")
        XCTAssertTrue(validateGUID("e57c4581-ac95-47ae-b23d-ee5002a40b80"), "GUID Validation")
        XCTAssertTrue(validateGUID("2d41cbb3-24fb-43a9-a902-bde71e85fdd7"), "GUID Validation")
        XCTAssertTrue(validateGUID("950e5bb2-53a7-40d7-8913-5f010ab5ea49"), "GUID Validation")
        XCTAssertTrue(validateGUID("743a5b74-4eb8-4965-80bc-5a25dfe7bf32"), "GUID Validation")
    }
    
    func testInvalidGUID(){
        XCTAssertFalse(validateGUID("192317b48dd411e4aa9b001e8c3af66d"), "GUID Validation - Hyphens")
        XCTAssertFalse(validateGUID("192317b4-8dd4-11e4-aa9b-001e8c3af66"), "GUID Validation - Length Short")
        XCTAssertFalse(validateGUID("192317b-8dd4-11e4-aa9b-001e8c3af66d"), "GUID Validation - Length Short")
        XCTAssertFalse(validateGUID("192317b4-8dd4-11e4aa9b-001e8c3af66d"), "GUID Validation - Missing middle hyphen")
        XCTAssertFalse(validateGUID("192317b4--8dd4--11e4--aa9b--001e8c3af66d"), "GUID Validation - Double hyphens")
        XCTAssertFalse(validateGUID("192317b4-8dd4-11e4-aa9b-001e8c3af66d-"), "GUID Validation - End hyphen")
        XCTAssertFalse(validateGUID("-192317b4-8dd4-11e4-aa9b-001e8c3af66d"), "GUID Validation - Start hyphen")
        XCTAssertFalse(validateGUID("192317b4"), "GUID Validation - Short")
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
