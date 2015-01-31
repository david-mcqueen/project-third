//
//  PricingBands.swift
//  CarParkApplication
//
//  Created by DavidMcQueen on 31/01/2015.
//  Copyright (c) 2015 DavidMcQueen. All rights reserved.
//

import Foundation

class PricingBand{
    var CarParkID: Int;
    var BandID: Int;
    var MinimumTimeHours: Int;
    var MaximumTimeHours: Int;
    var BandCost: Double;
    var Day: Int; //Sunday = 1. Saturday = 7
    
    init(_carParkID: Int, _bandID: Int,  _minimum: Int, _maximum: Int, _cost: Double, _day: Int){
        self.CarParkID = _carParkID;
        self.BandID = _bandID;
        self.MinimumTimeHours = _minimum;
        self.MaximumTimeHours = _maximum;
        self.BandCost = _cost;
        self.Day = _day;
    }
    
    func displayBand() -> String {
        return "\(self.MinimumTimeHours) - \(self.MaximumTimeHours) hours";
    }
}