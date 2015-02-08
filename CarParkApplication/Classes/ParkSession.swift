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
    var Finished: Bool;
    
    init (parkSessionID: Int, carParkID: Int, carParkName: String, startTime: NSDate, currentSession: Bool, parkedVehicleID: Int, finished: Bool){
        self.ParkSessionID = parkSessionID;
        self.CarParkID = carParkID;
        self.CarParkName = carParkName;
        self.StartTime = startTime;
        self.CurrentSession = currentSession;
        self.ParkedVehicleID = parkedVehicleID;
        self.Finished = finished;
    }
    
    init (parkSessionID: Int, carParkID: Int, carParkName: String, startTime: NSDate, endTimeParking: NSDate, currentSession: Bool, parkedVehicleID: Int, value: Double, finished: Bool){
        self.ParkSessionID = parkSessionID;
        self.CarParkID = carParkID;
        self.CarParkName = carParkName;
        self.StartTime = startTime;
        self.EndTime = endTimeParking;
        self.CurrentSession = currentSession;
        self.ParkedVehicleID = parkedVehicleID;
        self.Value = value;
        self.Finished = finished;
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
        return "\(self.CarParkName) (\(self.CarParkID))";
    }
    
    func calculateDuration() -> (String, Int, Int){
        var difference: Double = self.EndTime!.timeIntervalSinceDate(self.StartTime);
        //The difference is represented in seconds
        
        var secondsInt: Int = (Int)(difference);
        let (h, m) = convertSecondsToHoursMinutes(secondsInt);
        var returnTime: String = "";
        if (h > 0){
            returnTime = "\(returnTime)\(h) hours"
        }
        if(m > 0){
            returnTime = "\(returnTime) \(m) minutes"
        }
        
        return (returnTime, h, m);
    }
    
    
    func displaySessionCost() -> String{
        return "£\(getCostFormattedString(self.Value!))";
    }
    
    
    
}