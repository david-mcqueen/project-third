//
//  Utilities.swift
//  CarParkApplication
//
//  Created by David McQueen on 06/10/2014.
//  Copyright (c) 2014 David McQueen. All rights reserved.
//

import Foundation

//MARK:- Encryption

func encryptString(input:String) -> String {
    //The main encryption. Take a single string and returns it encrypted
    
    //PRE: Takes an unencrypted string
    //POST: Returns the string, Encrypted
    
    return "Encrypted";
}

func encryptUserRegistration(registrationInput:UserRegistration) -> UserRegistration{
    //Takes the registration details, encrypts each String, then returns an encrypted RegistrationUser
    
    //PRE: RegistrationUser object, unencrypted
    //POST: RegistrationUser object, with values encrypted
    return UserRegistration(firstName: encryptString(registrationInput.FirstName), surname: encryptString(registrationInput.SurName), email: encryptString(registrationInput.Email), password: encryptString(registrationInput.Password));
}

func encryptLogin(loginInput:UserLogin) -> UserLogin {
    //Takes login credentials, and returns them encrypted in an object
    
    //PRE: loginUser object, unencrypted
    //POST: loginUser object, with values encrypted
    return UserLogin(userName: encryptString(loginInput.UserName), password: encryptString(loginInput.Password));
}

func encryptVehicleRegistration(registrationInput:Vehicle) -> Vehicle {
    //Takes vehicle registration details, and returns an object with them encrypted
    
    //PRE: VehicleRegistration object, unecnrypted
    //POST: VehicleRegistration object, with values encrypted
    return Vehicle(make: encryptString(registrationInput.Make), colour: encryptString(registrationInput.Colour), registrationNumber: encryptString(registrationInput.RegistrationNumber));
}


//MARK:- Decryption

//The main decryption. Take a single string and returns it decrypted
func decryptString(input:String) -> String {
    //PRE: Takes an encrypted string
    //POST: Returns the string, decrypted
    return "Decrypted";
    
}



//MARK:- Functions

func validateEmail(inputEmail: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    var emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx);
    return emailTest.evaluateWithObject(inputEmail);
}


func validatePassword(inputPassword: String) -> Bool{
    /*
    Password must:
        Contain one digit 0-9
        contain one lowercase character
        contain one uppercase character
        contain one special symbol in the grup {@#$%}
        be between 6 and 20 characters
    */
    let passwordRegEx = "((?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%]).{6,20})";
    
    var passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx);
    return passwordTest.evaluateWithObject(inputPassword);
    
}
