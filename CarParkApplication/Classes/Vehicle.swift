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
    var Colour: String;
    var RegistrationNumber: String;
    
    init(make:String, colour:String, registrationNumber:String){
        self.Make = make;
        self.Colour = colour;
        self.RegistrationNumber = registrationNumber;
    }
}