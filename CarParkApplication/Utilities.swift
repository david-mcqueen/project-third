//
//  Utilities.swift
//  CarParkApplication
//
//  Created by David McQueen on 06/10/2014.
//  Copyright (c) 2014 David McQueen. All rights reserved.
//

import Foundation
import UIKit

//MARK:- Encryption

func encryptString(input:String) -> String {
    //The main encryption. Take a single string and returns it encrypted
    
    //PRE: Takes an unencrypted string
    //POST: Returns the string, Encrypted
    
    return "Encrypted";
}

//func encryptUserRegistration(registrationInput:UserRegistration) -> UserRegistration{
//    //Takes the registration details, encrypts each String, then returns an encrypted RegistrationUser
//    
//    //PRE: RegistrationUser object, unencrypted
//    //POST: RegistrationUser object, with values encrypted
//    return UserRegistration(firstName: encryptString(registrationInput.FirstName), surname: encryptString(registrationInput.SurName), email: encryptString(registrationInput.Email), password: encryptString(registrationInput.Password));
//}

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
    return Vehicle(make: encryptString(registrationInput.Make), model: "Test", colour: encryptString(registrationInput.Colour), registrationNumber: encryptString(registrationInput.RegistrationNumber), vehicleID: 1);
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
    
    return emailTest!.evaluateWithObject(inputEmail);
    
    }

func validatePassword(inputPassword: String) -> Bool{
    /*
    Password must:
        Contain one digit 0-9
        contain one lowercase character
        contain one uppercase character
        be between 7 and 30 characters
    */
    let passwordRegEx = "((?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).{7,30})";
    var passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx);
    
    return passwordTest!.evaluateWithObject(inputPassword);
    
}

func validatePhoneNumber(inputNumber: String) -> Bool{
    //Phone Number must be 11 characters long
    let numberRegEx = "[0-9]{11}";
    var numberTest = NSPredicate(format:"SELF MATCHES %@", numberRegEx);
    
    return numberTest!.evaluateWithObject(inputNumber);
}

func validateGUID(inputGUID: String) -> Bool {
    //Determine if the String is a valid GUID
    let GUIDRegEx = "[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}";
    var GUIDTest = NSPredicate(format:"SELF MATCHES %@", GUIDRegEx);
    
    return GUIDTest!.evaluateWithObject(inputGUID);
}

func validateLocationID(inputID: String) -> Bool{
    //Phone Number must be 11 characters long
    let numberRegEx = "[0-9]{1,8}";
    var numberTest = NSPredicate(format:"SELF MATCHES %@", numberRegEx);
    
    return numberTest!.evaluateWithObject(inputID);
}

func displayAlert(title: String, message: String, cancelButton: String){
    var alert = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: cancelButton)
    alert.show();
}

func convertSecondsToHoursMinutes (seconds : Int) -> (Int, Int) {
    return (seconds / 3600, (seconds % 3600) / 60)
}


func isWholeNumber(input: Double) -> Bool{
    if (input % 1 == 0){
        return true;
    }else{
        return false;
    }
}

func getCostFormattedString(inputCost: Double) -> String{
    var costString: String = (inputCost.description)
    var costStringSplit = split(costString) {$0 == "."};
    var pounds = costStringSplit[0];
    var pence = costStringSplit[1];
    
    
    if(isWholeNumber(inputCost)){
        return pounds;
    }else{
        
        if (countElements(pence) == 1){
            pence = pence + "0";
        }
        
        return pounds + "." + pence;
    }
    
}

func borderRed(inputCell: UITableViewCell){
    //Set the border colour red for the input that failed
    
    inputCell.layer.borderColor = (UIColor( red: 1, green: 0, blue:0, alpha: 1.0 )).CGColor;
    inputCell.layer.borderWidth = 2.0;
    inputCell.layer.cornerRadius = 2;
    inputCell.clipsToBounds = true;
}

func clearBorderRed(inputCell: UITableViewCell){
    inputCell.layer.borderColor = (UIColor( red: 1, green: 0, blue:0, alpha: 1.0 )).CGColor;
    inputCell.layer.borderWidth = 0.0;
    inputCell.layer.cornerRadius = 5;
    inputCell.clipsToBounds = true;
}

