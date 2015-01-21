//
//  ParkSession.swift
//  CarParkApplication
//
//  Created by DavidMcQueen on 20/01/2015.
//  Copyright (c) 2015 DavidMcQueen. All rights reserved.
//

import Foundation

class ParkSession {
    var ParkSessionID: Int;
    var CarParkID: Int;
    var StartTime: String;
    var EndTime: String?;
    var CurrentSession: Bool;
    var ParkedVehicleID: Int;
    
    init (parkSessionID: Int, carParkID: Int, startTime: String, currentSession: Bool, parkedVehicleID: Int){
        self.ParkSessionID = parkSessionID;
        self.CarParkID = carParkID;
        self.StartTime = startTime;
        self.CurrentSession = currentSession;
        self.ParkedVehicleID = parkedVehicleID;
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