//
//  UserRegistration.swift
//  CarParkApplication
//
//  Created by David McQueen on 06/10/2014.
//  Copyright (c) 2014 David McQueen. All rights reserved.
//

import Foundation

class UserRegistration {
    var FirstName: String;
    var SurName: String;
    var Email: String;
    var ConfirmEmail: String?;
    var Password: String;
    var ConfirmPassword: String?;
    var validationPassed: Bool = false;
    var validationErrors: String?;
    var RegistrationSuccess: Bool = false;
    var RegistrationErrors: String?;
        
    init(firstName:String, surname:String, email:String, password:String) {
        self.FirstName = firstName;
        self.SurName = surname;
        self.Email = email;
        self.Password = password;
    }
    
    init(firstName:String, surname:String, email:String, confirmEmail:String, password:String, confirmPassword:String) {
        self.FirstName = firstName;
        self.SurName = surname;
        self.Email = email;
        self.Password = password;
        self.ConfirmEmail = confirmEmail;
        self.ConfirmPassword = confirmPassword;
    }
    
    func validate(){
        //TODO:- User Details validation
        
        /*
        //Pre: All of the user input fields will be passed in, via the class RegistrationUser
        //Post: Bool = True Then the validation has passed
        //      Bool = False. Then the validation has failed
        
        //This will take the user input, validate it, and then return the result (Pass / Fail)
        */
        NSLog(self.FirstName);
        NSLog(self.SurName);
        NSLog(self.Email);
        NSLog(self.ConfirmEmail!);
        NSLog(self.Password);
        NSLog(self.ConfirmPassword!);
        if (validateEmail(self.Email)){
            NSLog("emailed Passed");
        }else {
            NSLog("email Failed");
        }
        
        if(true){
            self.validationPassed = true;
        }else{
            self.validationPassed = false;
            self.validationErrors = "Errors";
        }
        
    }
    
    func register(){
        //TODO:- Send registration details to server
        /*
        PRE: Validated user details are passed in
        POST: Unique userID is returned from the server
        
        //Bool represents register successful
        //String represents any errors
        */
        
        //Encrypt user details
        
        //If return from the server successfully, then proceed to the next stage (Vehicle)
        //Else, stay on registration page and flag errors
        
        if(true){
            self.RegistrationSuccess = true;
        }else{
            self.RegistrationSuccess = false;
            self.RegistrationErrors = "Errors";
        }
        
    }
    
    
    
}