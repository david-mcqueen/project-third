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
    
    //MARK:- Vehicle
    func testDisplayUserVehicle(){
        var vehicle = Vehicle(make: "Renault", model: "Megane", colour: "Grey", registrationNumber: "AB51 ABC", deleted: false);
        
        //Should Pass
        XCTAssertTrue(vehicle.displayVehicle() == "Renault Megane (AB51 ABC)", "Display user vehicle correctly");
        
        
        //Should Fail
        XCTAssertFalse(vehicle.displayVehicle() == "Renault Megane AB51 ABC", "Display user vehicle correctly");
        XCTAssertFalse(vehicle.displayVehicle() == "Renault Megane (AB51ABC)", "Display user vehicle correctly");
        XCTAssertFalse(vehicle.displayVehicle() == "Renault Megane AB51ABC", "Display user vehicle correctly");
        XCTAssertFalse(vehicle.displayVehicle() == "Renault Megane", "Display user vehicle correctly");
        XCTAssertFalse(vehicle.displayVehicle() == "RenaultMeganeAB51ABC", "Display user vehicle correctly");
        XCTAssertFalse(vehicle.displayVehicle() == "Megane (AB51 ABC)", "Display user vehicle correctly");
        XCTAssertFalse(vehicle.displayVehicle() == "Renault (Megane AB51 ABC)", "Display user vehicle correctly");
        XCTAssertFalse(vehicle.displayVehicle() == "(Renault Megane) AB51 ABC", "Display user vehicle correctly");
        XCTAssertFalse(vehicle.displayVehicle() == "", "Display user vehicle correctly");
    }
    
    //MARK:- User Singleton
    
    func testUserSingleton(){
        User.sharedInstance.UserName = "David.mcqueen@gmail.com";
        User.sharedInstance.FirstName = "David";
        User.sharedInstance.Surname = "McQueen";
        User.sharedInstance.CurrentBalance = 19.74;
        
        
        var deletedVehicle = Vehicle(make: "Renault", model: "Megane", colour: "Grey", registrationNumber: "DELETED 1", vehicleID: 1, deleted: true);
        var deletedVehicle2 = Vehicle(make: "Renault", model: "Megane", colour: "Grey", registrationNumber: "DELETED 2", vehicleID: 2, deleted: true);
        var deletedVehicle3 = Vehicle(make: "Renault", model: "Megane", colour: "Grey", registrationNumber: "DELETED 3", vehicleID: 3, deleted: true);
        var deletedVehicle4 = Vehicle(make: "Renault", model: "Megane", colour: "Grey", registrationNumber: "DELETED", vehicleID: 4, deleted: true);
        
        
        var vehicle5 = Vehicle(make: "Renault", model: "Megane", colour: "Grey", registrationNumber: "AB05 ABC", vehicleID: 5, deleted: false);
        var vehicle6 = Vehicle(make: "Renault", model: "Megane", colour: "Grey", registrationNumber: "AB06 ABC", vehicleID: 6, deleted: false);
        var vehicle7 = Vehicle(make: "Renault", model: "Megane", colour: "Grey", registrationNumber: "AB07 ABC", vehicleID: 7, deleted: false);
        var vehicle8 = Vehicle(make: "Renault", model: "Megane", colour: "Grey", registrationNumber: "AB08 ABC", vehicleID: 8, deleted: false);
        var vehicle9 = Vehicle(make: "Renault", model: "Megane", colour: "Grey", registrationNumber: "AB09 ABC", vehicleID: 9, deleted: false);
        
        User.sharedInstance.addVehicle(deletedVehicle);
        User.sharedInstance.addVehicle(vehicle5);
        User.sharedInstance.addVehicle(deletedVehicle2);
        User.sharedInstance.addVehicle(vehicle6);
        User.sharedInstance.addVehicle(vehicle7);
        User.sharedInstance.addVehicle(deletedVehicle3);
        User.sharedInstance.addVehicle(deletedVehicle4);
        User.sharedInstance.addVehicle(vehicle8);
        User.sharedInstance.addVehicle(vehicle9);
        
        var firstVehicle = User.sharedInstance.getFirstVehicle();
        var allActiveVehicles = User.sharedInstance.getActiveVehicles();
        
        
        //Should Pass
        XCTAssertTrue(User.sharedInstance.UserName == "David.mcqueen@gmail.com", "Access User Singleton correctly");
        XCTAssertTrue(User.sharedInstance.FirstName ==  "David", "Access User Singleton correctly");
        XCTAssertTrue(User.sharedInstance.Surname == "McQueen", "Access User Singleton correctly");
        XCTAssertTrue(User.sharedInstance.CurrentBalance == 19.74, "Access User Singleton correctly");
        
       
        XCTAssertTrue(firstVehicle?.displayVehicle() == "Renault Megane (AB05 ABC)", "Gets first (non deleted) vehicle")
        XCTAssertTrue(allActiveVehicles.count == 5, "Get all active vehicles correctly")
        
        //Delete the first active vehicle
        XCTAssertTrue(User.sharedInstance.deleteVehicle(vehicle5), "Vehicle should delete OK");
        
        //Check the vehicle has been deleted
        
        firstVehicle = User.sharedInstance.getFirstVehicle();
        allActiveVehicles = User.sharedInstance.getActiveVehicles();
        
        XCTAssertTrue(firstVehicle?.displayVehicle() == "Renault Megane (AB06 ABC)", "Gets first (non deleted) vehicle, this should be vehicle2")
        XCTAssertTrue(allActiveVehicles.count == 4, "Get all active vehicles correctly")
        
        
        //Test all vehicles are deleted
        User.sharedInstance.deleteAllvehciles();
        
        firstVehicle = User.sharedInstance.getFirstVehicle();
        
        XCTAssertTrue(firstVehicle?.displayVehicle() == nil, "No vehicle with the account");
        XCTAssertTrue(firstVehicle == nil, "No vehicle with the account");
        
        
        //Test that the last vehicle cant be deleted
        var vehicle10 = Vehicle(make: "Renault", model: "Megane", colour: "Grey", registrationNumber: "AB10 ABC", vehicleID: 10, deleted: false);
        var vehicle11 = Vehicle(make: "Renault", model: "Megane", colour: "Grey", registrationNumber: "AB11 ABC", vehicleID: 11, deleted: false);

        User.sharedInstance.addVehicle(vehicle10);
        User.sharedInstance.addVehicle(vehicle11);
        
        XCTAssertTrue(User.sharedInstance.deleteVehicle(vehicle10), "Vehicle should delete OK");
        XCTAssertFalse(User.sharedInstance.deleteVehicle(vehicle11), "Vehicle should NOT delete");
        
        firstVehicle = User.sharedInstance.getFirstVehicle();
        allActiveVehicles = User.sharedInstance.getActiveVehicles();
        XCTAssertTrue(firstVehicle?.displayVehicle() == "Renault Megane (AB11 ABC)", "Vehicle 11 should still be active (last vehicle)")
    }

}
