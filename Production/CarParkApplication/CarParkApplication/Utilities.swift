//
//  Utilities.swift
//  CarParkApplication
//
//  Created by David McQueen on 06/10/2014.
//  Copyright (c) 2014 David McQueen. All rights reserved.
//

import Foundation

//MARK:- Encryption

//The main encryption. Take a single string and returns it encrypted
func EncryptString(input:String) -> String {
    //PRE: Takes an unencrypted string
    //POST: Returns the string, Encrypted
    var Encryption = "Encrypted";
    
    return Encryption;
}

//Takes the registration details, encrypts each String, then returns an encrypted RegistrationUser
func EncryptRegistration(registrationInput:RegistrationUser) -> RegistrationUser{
    //PRE: RegistrationUser object, unencrypted
    //POST: RegistrationUser object, encrypted
    var encryptedDetails = RegistrationUser(firstName: EncryptString(registrationInput.FirstName), surname: EncryptString(registrationInput.SurName), email: EncryptString(registrationInput.Email), password: EncryptString(registrationInput.Password));
    
    return encryptedDetails;
    
}

//MARK:- Decryption

//The main decryption. Take a single string and returns it decrypted
func DecryptString(input:String) -> String {
    //PRE: Takes an encrypted string
    //POST: Returns the string, decrypted
    var decryption = "decrypted";
    
    return decryption;
}
