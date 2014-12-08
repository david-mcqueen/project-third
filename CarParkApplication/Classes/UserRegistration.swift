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
    
    func validEmailPattern() -> Bool{
        return validateEmail(self.Email);
    }
    
    func validPasswordPattern() -> Bool{
        return !validatePassword(self.Password);
    }
    
}