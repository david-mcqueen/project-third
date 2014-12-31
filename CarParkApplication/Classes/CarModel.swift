//
//  Car-Model.swift
//  CarParkApplication
//
//  Created by DavidMcQueen on 31/12/2014.
//  Copyright (c) 2014 DavidMcQueen. All rights reserved.
//

import Foundation

class CarModel {
    var model_name: AnyObject;
    var model_make_id: AnyObject;
    
    init(_model_name:AnyObject, _model_make_id:AnyObject){
        self.model_name = _model_name;
        self.model_make_id = _model_make_id;
    }
}