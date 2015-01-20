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
    var ParkSessions: [ParkSession]?;
    
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
    
    //MARK:- Vehicle functions
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
        
        //TODO:- Only delete if there is > 1 vehicle (need at least 1)
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
        
    //MARK:- Park Session functions
    func deleteAllParkSessions(){
        self.ParkSessions?.removeAll(keepCapacity: false);
    }
    
    func addParkSession(newParkSession: ParkSession){
        self.ParkSessions?.append(newParkSession);
    }
    
    func getAllParkSessions() -> [ParkSession]? {
        return self.ParkSessions;
    }
    
    //MARK:- Balance Functions
    func getBalanceString() -> String {
        return self.CurrentBalance.description;
    }
    
        
    func logout() {
        self.deleteAllvehciles();
        self.FirstName = "";
        self.Surname = ""
        self.token = ""
        self.UserName = "";
        self.CurrentBalance = 0.0;
        
        //TODO:- Call the logout API
    }
}