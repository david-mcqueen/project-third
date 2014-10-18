//
//  CarParkApplicationTests.swift
//  CarParkApplicationTests
//
//  Created by DavidMcQueen on 05/10/2014.
//  Copyright (c) 2014 DavidMcQueen. All rights reserved.
//

import UIKit
import XCTest

class CarParkApplicationTests: XCTestCase {
    
    
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
    
    func testUserValidation(){
        var testUser = UserRegistration(firstName: "David", surname: "McQueen", email: "t@t.com", password: "abcd");
        testUser.validate();
        XCTAssert(testUser.validationSuccess, "Validation Passed");
    }
    

    
    
}
