//
//  User.swift
//  CarParkApplication
//
//  Created by David McQueen on 06/10/2014.
//  Copyright (c) 2014 David McQueen. All rights reserved.
//

import Foundation

class User {
    var UserName: String; //Potentially the same as the email address
    var FirstName: String;
    var Surname: String;
    var CurrentBalance: Double; //The £ balance of their account
    var Vehicles:[Vehicle]; //An array of all vehicles associated with the user.
    var token: String?; //The authorization token provided by the server.
    
    class var sharedInstance: User {
        struct Singleton {
            static let instance = User()
        }
        return Singleton.instance
    }
    
    init(){
        self.UserName = "";
        self.FirstName = "";
        self.Surname = "";
        self.CurrentBalance = 0.0;
        self.Vehicles = []
    }
    
    func addVehicle(newVehicle: Vehicle) {
        self.Vehicles.append(newVehicle);
    }
    
    func deleteVehicle(oldVehicle: Vehicle){
        var removeVehicleIndex: Int?;
        var searchIndex = 0;
        
        for vehicle in self.Vehicles{
            if vehicle.RegistrationNumber == oldVehicle.RegistrationNumber{
                removeVehicleIndex = searchIndex;
            }
            searchIndex++;
        }
        
        self.Vehicles.removeAtIndex(removeVehicleIndex!)
    }
    
    func deleteAllvehciles() {
        self.Vehicles.removeAll(keepCapacity: false)
    }
    
    func getVehicles() -> [Vehicle]{
        //POST: Returns the array of all vehicles associated with the user.
        return self.Vehicles;
    }
    
    func getFirstVehicle() -> Vehicle {
        return self.Vehicles[0];
    }
}