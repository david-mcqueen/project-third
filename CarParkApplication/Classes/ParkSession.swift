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
    var CarParkName: String;
    var StartTime: NSDate;
    var EndTime: NSDate?;
    var CurrentSession: Bool;
    var ParkedVehicleID: Int;
    var Value: Double?;
    
    init (parkSessionID: Int, carParkID: Int, carParkName: String, startTime: NSDate, currentSession: Bool, parkedVehicleID: Int){
        self.ParkSessionID = parkSessionID;
        self.CarParkID = carParkID;
        self.CarParkName = carParkName;
        self.StartTime = startTime;
        self.CurrentSession = currentSession;
        self.ParkedVehicleID = parkedVehicleID;
    }
    
    init (parkSessionID: Int, carParkID: Int, carParkName: String, startTime: NSDate, endTimeParking: NSDate, currentSession: Bool, parkedVehicleID: Int, value: Double){
        self.ParkSessionID = parkSessionID;
        self.CarParkID = carParkID;
        self.CarParkName = carParkName;
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
        var dateFormatter = NSDateFormatter();
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm";
        return dateFormatter.stringFromDate(self.StartTime);
    }
    
    func endTimeAsString() -> String{
        var dateFormatter = NSDateFormatter();
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm";
        return dateFormatter.stringFromDate(self.EndTime!);
    }
    
    func locationDetails() -> String{
        return "\(self.CarParkID): \(self.CarParkName)";
    }
    
    func calculateDuration() -> String{
        var difference: Double = self.EndTime!.timeIntervalSinceDate(self.StartTime);
        //The difference is represented in seconds
        
        var secondsInt: Int = (Int)(difference);
        let (h, m) = convertSecondsToHoursMinutes(secondsInt);
        
        return "\(h) hours \(m) minutes";
    }
}