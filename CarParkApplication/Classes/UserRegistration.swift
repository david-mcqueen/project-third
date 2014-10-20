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
    var validationSuccess: (email:Bool, password:Bool) = (false, false);
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
    
    func matchingEmail() -> Bool{
        if(Email.lowercaseString == ConfirmEmail?.lowercaseString){
            return true;
        }else{
            return false;
        }
    }
    
    func matchingPassword() -> Bool{
        if(Password == ConfirmPassword){
            return true;
        }else{
            return false;
        }
    }

    func validate(){
        // Validates the user input details

        NSLog("Validating User Input");
        
        if(validateEmail(self.Email)){
            self.validationSuccess.email = true;
        }
        if(validatePassword(self.Password)){
            self.validationSuccess.password = true;
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