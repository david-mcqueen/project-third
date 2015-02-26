//
//  User.swift
//  CarParkApplication
//
//  Created by David McQueen on 06/10/2014.
//  Copyright (c) 2014 David McQueen. All rights reserved.
//

/*
//  A singleton object for the User class
//  Holds the user information, and any necessary functions.
*/

import Foundation

class User {
    var UserName: String; //Potentially the same as the email address
    var FirstName: String;
    var Surname: String;
    var CurrentBalance: Double; //The £ balance of their account
    var Vehicles:[Vehicle]; //An array of all vehicles associated with the user.
    var token: String?; //The authorization token provided by the server.
    var ParkSessions: [ParkSession] = [];
    
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
    
    func deleteVehicle(oldVehicle: Vehicle) -> Bool{
        var removeVehicleIndex: Int?;
        var searchIndex = 0;
        var activeVehicles = getActiveVehicles();
        
        for vehicle in self.Vehicles{
            if vehicle.VehicleID == oldVehicle.VehicleID{
                removeVehicleIndex = searchIndex;
            }
            searchIndex++;
        }
        
        // Only delete if there is > 1 vehicle (need at least 1)
        if activeVehicles.count > 1{
            self.Vehicles.removeAtIndex(removeVehicleIndex!)
            return true;
        }else{
            return false;
        }
        
    }
    
    func deleteAllvehciles() {
        self.Vehicles.removeAll(keepCapacity: false)
    }
    
    func getActiveVehicles() -> [Vehicle]{
        //POST: Returns the array of all vehicles associated with the user.
        var activeVehicles: [Vehicle] = []
        for vehicle in self.Vehicles{
            if (!vehicle.Deleted){
                activeVehicles.append(vehicle);
            }
        }
        return activeVehicles;
    }
    
    func getFirstVehicle() -> Vehicle? {
        var activeVehicles = self.getActiveVehicles();
        
        if activeVehicles.count > 0{
            return activeVehicles[0];
        }else{
            return nil;
        }
        
    }
    
    
    
    //MARK:- Park Session functions
    func deleteAllParkSessions(){
        self.ParkSessions.removeAll(keepCapacity: false);
    }
    
    func addParkSession(newParkSession: ParkSession){
        self.ParkSessions.append(newParkSession);
    }
    
    func removeParkSession(oldParkSession: ParkSession){
        var removeSessionIndex: Int?;
        var searchIndex = 0;
        
        for band in self.ParkSessions{
            if band.ParkSessionID == oldParkSession.ParkSessionID{
                removeSessionIndex = searchIndex;
            }
            searchIndex++;
        }
        println(removeSessionIndex)
        //TODO:- Only delete if there is > 1 vehicle (need at least 1)
        self.ParkSessions.removeAtIndex(removeSessionIndex!)

    }
    
    func getParkSession(sessionID: Int) -> ParkSession?{
        for session in self.ParkSessions{
            if session.ParkSessionID == sessionID{
                return session;
            }
        }
        return nil;
    }
    
    func getAllParkSessions() -> [ParkSession] {
        return self.ParkSessions;
    }
    
    func getCurrentParkSessions() -> [ParkSession]{
        var currentSessions:[ParkSession] = [];
        for session in self.ParkSessions{
            if(session.CurrentSession){
                currentSessions.append(session)
            }
        }
        return currentSessions;
    }
    
    func getCurrentParkSessionsCount() -> Int{
        var currentSessions:[ParkSession] = [];
        for session in self.ParkSessions{
            if(session.CurrentSession){
                currentSessions.append(session)
            }
        }
        return currentSessions.count;
    }
    
    func getPreviousParkSessions() -> [ParkSession]{
        var previousSessions:[ParkSession] = [];
        for session in self.ParkSessions{
            if(!session.CurrentSession){
                previousSessions.append(session)
            }
        }
        return previousSessions;
    }
    
    func getPreviousParkSessionsCount() -> Int{
        var previousSessions:[ParkSession] = [];
        for session in self.ParkSessions{
            if(!session.CurrentSession){
                previousSessions.append(session)
            }
        }
        return previousSessions.count;
    }
    
    //MARK:- Balance Functions
    func getBalanceString() -> String {
        return getCostFormattedString(self.CurrentBalance);
    }
    
    
    //MARK:- Logout
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