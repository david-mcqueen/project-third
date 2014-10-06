//
//  Utilities.swift
//  CarParkApplication
//
//  Created by David McQueen on 06/10/2014.
//  Copyright (c) 2014 David McQueen. All rights reserved.
//

import Foundation

//MARK:- Encryption

func EncryptString(input:String) -> String {
    //The main encryption. Take a single string and returns it encrypted
    
    //PRE: Takes an unencrypted string
    //POST: Returns the string, Encrypted
    
    return "Encrypted";
}

func EncryptRegistration(registrationInput:UserRegistration) -> UserRegistration{
    //Takes the registration details, encrypts each String, then returns an encrypted RegistrationUser
    
    //PRE: RegistrationUser object, unencrypted
    //POST: RegistrationUser object, with values encrypted
    return UserRegistration(firstName: EncryptString(registrationInput.FirstName), surname: EncryptString(registrationInput.SurName), email: EncryptString(registrationInput.Email), password: EncryptString(registrationInput.Password));
}

func encryptLogin(loginInput:LoginUser) -> LoginUser {
    //Takes login credentials, and returns them encrypted in an object
    
    //PRE: loginUser object, unencrypted
    //POST: loginUser object, with values encrypted
    return LoginUser(userName: EncryptString(loginInput.UserName), password: EncryptString(loginInput.Password));
}


//MARK:- Decryption

//The main decryption. Take a single string and returns it decrypted
func DecryptString(input:String) -> String {
    //PRE: Takes an encrypted string
    //POST: Returns the string, decrypted
    
    return "Decrypted";

}
