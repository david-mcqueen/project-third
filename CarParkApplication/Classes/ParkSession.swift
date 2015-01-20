//
//  ParkSession.swift
//  CarParkApplication
//
//  Created by DavidMcQueen on 20/01/2015.
//  Copyright (c) 2015 DavidMcQueen. All rights reserved.
//

import Foundation

class ParkSession {
    var ParkSessionID: AnyObject;
    var CarParkID: AnyObject;
    var StartTime: AnyObject;
    var EndTime: AnyObject?;
    var CurrentSession: Bool;
    var ParkedVehicle: Vehicle;
    
    init (parkSessionID: AnyObject, carParkID: AnyObject, startTime: AnyObject, currentSession: Bool, parkedVehicle: Vehicle){
        self.ParkSessionID = parkSessionID;
        self.CarParkID = carParkID;
        self.StartTime = startTime;
        self.CurrentSession = currentSession;
        self.ParkedVehicle = parkedVehicle;
    }
    
//    init (parkSessionID: Int, carParkID: Int, startTime: String, endTime: String, currentSession: Bool, parkedVehicle: Vehicle){
//        self.ParkessionID = parkSessionID;
//        self.CarParkID = carParkID;
//        self.StartTime = startTime;
//        self.EndTime = endTime;
//        self.CurrentSession = currentSession;
//        self.ParkedVehicle = parkedVehicle;
//    }
}