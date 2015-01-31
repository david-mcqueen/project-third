//
//  CarPark.swift
//  CarParkApplication
//
//  Created by DavidMcQueen on 31/01/2015.
//  Copyright (c) 2015 DavidMcQueen. All rights reserved.
//

import Foundation


class CarPark{
    var ID: Int;
    var Name: String;
    var Latitude: String;
    var Longitude: String;
    var DistanceFromSearch: Double;
    var Open: String?;
    var Close: String?;
    
    init (_id: Int, _name: String, _lat: String, _long: String, _distance: Double, _open: String?, _close: String?){
        self.ID = _id;
        self.Name = _name;
        self.Latitude = _lat;
        self.Longitude = _long;
        self.DistanceFromSearch = _distance;
        self.Open = _open;
        self.Close = _close;
    }
}

