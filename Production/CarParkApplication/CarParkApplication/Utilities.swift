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

func encryptLogin(loginInput:LoginUser) -> LoginUser {
    //Takes login credentials, and returns them encrypted in an object
    
    //PRE: loginUser object, unencrypted
    //POST: loginUser object, with values encrypted
    return LoginUser(userName: encryptString(loginInput.UserName), password: encryptString(loginInput.Password));
}

func encryptVehicleRegistration(registrationInput:VehicleRegistration) -> VehicleRegistration {
    //Takes vehicle registration details, and returns an object with them encrypted
    
    //PRE: VehicleRegistration object, unecnrypted
    //POST: VehicleRegistration object, with values encrypted
    return VehicleRegistration(make: encryptString(registrationInput.Make), colour: encryptString(registrationInput.Colour), registrationNumber: encryptString(registrationInput.RegistrationNumber));
}


//MARK:- Decryption

//The main decryption. Take a single string and returns it decrypted
func decryptString(input:String) -> String {
    //PRE: Takes an encrypted string
    //POST: Returns the string, decrypted
    return "Decrypted";

}
