//
//  User.swift
//  CarParkApplication
//
//  Created by David McQueen on 06/10/2014.
//  Copyright (c) 2014 David McQueen. All rights reserved.
//

import Foundation

class CarMake {
    var make_country: AnyObject;
    var make_display: AnyObject;
    var make_id: AnyObject;
    var make_is_common: AnyObject;
    
    init(_make_country:AnyObject, _make_display:AnyObject, _make_id:AnyObject, _make_is_common:AnyObject){
        self.make_country = _make_country;
        self.make_display = _make_display;
        self.make_id = _make_id;
        self.make_is_common = _make_is_common;
    }
}