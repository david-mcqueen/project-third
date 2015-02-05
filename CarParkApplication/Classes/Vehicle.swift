//
//  Vehicle.swift
//  CarParkApplication
//
//  Created by DavidMcQueen on 06/10/2014.
//  Copyright (c) 2014 DavidMcQueen. All rights reserved.
//

import Foundation

class Vehicle {
    var Make: String;
    var Model: String;
    var Colour: String;
    var RegistrationNumber: String;
    var VehicleID: Int?;
    var Deleted: Bool;
    
    init(make:String, model: String, colour:String, registrationNumber:String, deleted: Bool){
        self.Make = make;
        self.Model = model;
        self.Colour = colour;
        self.RegistrationNumber = registrationNumber;
        self.Deleted = deleted;
    }
    
    init(make:String, model: String, colour:String, registrationNumber:String, vehicleID: Int, deleted:Bool){
        self.Make = make;
        self.Model = model;
        self.Colour = colour;
        self.RegistrationNumber = registrationNumber;
        self.VehicleID = vehicleID;
        self.Deleted = deleted;
    }
    
    func displayVehicle() -> String{
        return ("\(self.Make) \(self.Model) (\(self.RegistrationNumber))");
    }

}