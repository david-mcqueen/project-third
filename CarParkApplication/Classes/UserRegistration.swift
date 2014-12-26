//
//  UserRegistration.swift
//  CarParkApplication
//
//  Created by David McQueen on 06/10/2014.
//  Copyright (c) 2014 David McQueen. All rights reserved.
//

import Foundation

class UserRegistration {
    //TODO:- Move functions into the controllers!
    var FirstName: String;
    var SurName: String;
    var Email: String;
    var ConfirmEmail: String?;
    var Password: String;
    var ConfirmPassword: String?;
    var PhoneNumber: String;
    var ConfirmPhoneNumber: String?;
    
    //TODO:- Create GET and SET functions for each of the values, make these private!
    //Spread the changes throughout the rest of the project
        
    init(_firstName:String, _surname:String, _email:String, _password:String, _phoneNumber:String) {
        self.FirstName = _firstName;
        self.SurName = _surname;
        self.Email = _email;
        self.Password = _password;
        self.PhoneNumber = _phoneNumber;
    }
    
    init(_firstName:String, _surname:String, _email:String, _confirmEmail:String, _password:String, _confirmPassword:String, _phoneNumber: String, _confirmPhoneNumber: String) {
        self.FirstName = _firstName;
        self.SurName = _surname;
        self.Email = _email;
        self.Password = _password;
        self.ConfirmEmail = _confirmEmail;
        self.ConfirmPassword = _confirmPassword;
        self.PhoneNumber = _phoneNumber;
        self.ConfirmPhoneNumber = _confirmPhoneNumber;
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
    
    func matchingPhoneNumber() -> Bool {
        if(PhoneNumber == ConfirmPhoneNumber){
            return true;
        }else{
            return false;
        }
    }
    
    func validEmailPattern() -> Bool{
        return validateEmail(self.Email);
    }
    
    func validPasswordPattern() -> Bool{
        return validatePassword(self.Password);
    }
    
    func validPhonePattern() -> Bool{
        return validatePhoneNumber(self.PhoneNumber);
    }
    
}