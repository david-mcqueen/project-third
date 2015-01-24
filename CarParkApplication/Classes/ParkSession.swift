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
    var StartTime: NSDate;
    var EndTime: NSDate?;
    var CurrentSession: Bool;
    var ParkedVehicleID: Int;
    var Value: Double?;
    
    init (parkSessionID: Int, carParkID: Int, startTime: NSDate, currentSession: Bool, parkedVehicleID: Int){
        self.ParkSessionID = parkSessionID;
        self.CarParkID = carParkID;
        self.StartTime = startTime;
        self.CurrentSession = currentSession;
        self.ParkedVehicleID = parkedVehicleID;
    }
    
    init (parkSessionID: Int, carParkID: Int, startTime: NSDate, endTimeParking: NSDate, currentSession: Bool, parkedVehicleID: Int, value: Double){
        self.ParkSessionID = parkSessionID;
        self.CarParkID = carParkID;
        self.StartTime = startTime;
        self.EndTime = endTimeParking;
        self.CurrentSession = currentSession;
        self.ParkedVehicleID = parkedVehicleID;
        self.Value = value;
    }
    
    func vehicleIDAsString() -> String {
        return String(ParkedVehicleID);
    }
    
    func startTimeAsString() -> String{
        return String(self.StartTime.description);
    }
    
    func endTimeAsString() -> String{
        return String(self.EndTime!.description);
    }
    
    
    
    func calculateDuration() -> String{
        var difference = self.EndTime!.timeIntervalSinceDate(self.StartTime);
        //The difference is represented in seconds
        var timeUnit: String?
        timeUnit = "cat"
        
        let (h, m, s) = secondsToHoursMinutesSeconds(640800);
        
        println("\(h) \(m) \(s)")
        return "\(h) hours \(m) minutes \(s) seconds";
    }
}