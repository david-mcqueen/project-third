//
//  Car-Model.swift
//  CarParkApplication
//
//  Created by DavidMcQueen on 31/12/2014.
//  Copyright (c) 2014 DavidMcQueen. All rights reserved.
//
/*
//  A class to hold the vehicle Model, as returned from CarQueryAPI
*/
import Foundation

class CarModel {
    var model_name: String;
    var model_make_id: String;
    
    init(_model_name:String, _model_make_id:String){
        self.model_name = _model_name;
        self.model_make_id = _model_make_id;
    }
}