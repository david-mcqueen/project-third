//
//  User.swift
//  CarParkApplication
//
//  Created by David McQueen on 06/10/2014.
//  Copyright (c) 2014 David McQueen. All rights reserved.
//

import Foundation

class CarMake {
    var make_country: String;
    var make_display: String;
    var make_id: String;
    var make_is_common: String;
    
    init(_make_country:String, _make_display:String, _make_id:String, _make_is_common:String){
        self.make_country = _make_country;
        self.make_display = _make_display;
        self.make_id = _make_id;
        self.make_is_common = _make_is_common;
    }
}