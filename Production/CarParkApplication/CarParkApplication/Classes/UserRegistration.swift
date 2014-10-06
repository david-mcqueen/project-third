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
    
}