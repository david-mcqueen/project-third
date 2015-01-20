//
//  ParkSession.swift
//  CarParkApplication
//
//  Created by DavidMcQueen on 20/01/2015.
//  Copyright (c) 2015 DavidMcQueen. All rights reserved.
//

import Foundation

class ParkSession {
    var ParkessionID: Int;
    var CarParkID: Int;
    var StartTime: NSDate;
    var EndTime: NSDate?;
    var CurrentSession: Bool;
    
    init (parkSessionID: Int, carParkID: Int, startTime: NSDate, currentSession: Bool){
        self.ParkessionID = parkSessionID;
        self.CarParkID = carParkID;
        self.StartTime = startTime;
        self.CurrentSession = currentSession;
    }
    
    init (parkSessionID: Int, carParkID: Int, startTime: NSDate, endTime: NSDate, currentSession: Bool){
        self.ParkessionID = parkSessionID;
        self.CarParkID = carParkID;
        self.StartTime = startTime;
        self.EndTime = endTime;
        self.CurrentSession = currentSession;
    }
}