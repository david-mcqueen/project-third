//
//  User.swift
//  CarParkApplication
//
//  Created by DavidMcQueen on 06/10/2014.
//  Copyright (c) 2014 DavidMcQueen. All rights reserved.
//

import Foundation

class User {
    var UserName: String; //Potentially the same as the email address
    var FirstName: String;
    var Surname: String;
    var CurrentBalance: Double; //The £ balance of their account
    var Vehicles:[Vehicle] = [];
    
    init(userName:String, firstName:String, surname:String, balance:Double, vehicle:Vehicle){
        self.UserName = userName;
        self.FirstName = firstName;
        self.Surname = surname;
        self.CurrentBalance = balance;
        self.Vehicles.append(vehicle);
    }
    
    func addVehicle(newVehicle: Vehicle) {
        self.Vehicles.append(newVehicle);
    }
    
    func getVehicles() -> [Vehicle]{
        //POST: Returns the array of all vehicles associated with the user.
        return self.Vehicles;
    }
}