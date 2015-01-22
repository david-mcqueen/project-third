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
        getUserBalance();
        getUserVehicles();
        getUserName();
        getUserParkingSessions();
    }
    
    func getUserBalance(){
        //TODO:- Get the users current balance from the API
        User.sharedInstance.CurrentBalance = 11.74;
    }
    
    func getUserVehicles() {
        //TODO:- Get the users vehicles from the API
        User.sharedInstance.deleteAllvehciles();
        getAllUserVehicles(User.sharedInstance.token!, { (success, vehicles, error) -> () in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                println("getUserVehicles()")
                User.sharedInstance.Vehicles = vehicles;
            });
        });
    }
    
    func getUserName(){
        var testToken = User.sharedInstance.token!;
        testToken = "This is a new token";
        //TODO:- Get the users name from the API
        User.sharedInstance.FirstName = "David";
        User.sharedInstance.Surname = "McQueen";
    }
    
    func getUserParkingSessions(){
        getAllParkingSessions(User.sharedInstance.token!, {(success, sessions, error) -> () in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                User.sharedInstance.ParkSessions = sessions;
            });
        });
    }
    
}