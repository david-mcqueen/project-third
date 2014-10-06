//
//  loginUser.swift
//  CarParkApplication
//
//  Created by DavidMcQueen on 06/10/2014.
//  Copyright (c) 2014 DavidMcQueen. All rights reserved.
//

import Foundation

class LoginUser {
    var UserName:String;
    var Password:String;
    
    init(userName:String, password:String){
        self.UserName = userName;
        self.Password = password;
    }
}