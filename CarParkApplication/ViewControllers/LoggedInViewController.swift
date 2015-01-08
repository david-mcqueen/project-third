//
//  LoggedInViewController.swift
//  CarParkApplication
//
//  Created by DavidMcQueen on 07/01/2015.
//  Copyright (c) 2015 DavidMcQueen. All rights reserved.
//

import UIKit
import Foundation

class LoggedInViewController: UITabBarController {
    //Perform all background data GETS after the user has logged in
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("Logged in view controller")
        getUserBalance();
        getUserVehicles();
        getUserName();
    }
    
    func getUserBalance(){
        //TODO:- Get the users current balance from the API
        User.sharedInstance.CurrentBalance = 11.74;
    }
    
    func getUserVehicles() {
        //TODO:- Get the users vehicles from the API
        User.sharedInstance.deleteAllvehciles();
        
        let renault = Vehicle(make: "Renault", model: "Megane", colour: "Grey", registrationNumber: "HT57 GHF");
        User.sharedInstance.addVehicle(renault);
        let honda = Vehicle(make: "Honda", model: "Accord", colour: "Blue", registrationNumber: "AF05 VNK");
        User.sharedInstance.addVehicle(honda);
    }
    
    func getUserName(){
        //TODO:- Get the users name from the API
        User.sharedInstance.FirstName = "David";
        User.sharedInstance.Surname = "McQueen";
    }
    
}