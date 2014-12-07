//
//  UserLogin.swift
//  CarParkApplication
//
//  Created by DavidMcQueen on 06/10/2014.
//  Copyright (c) 2014 DavidMcQueen. All rights reserved.
//

import Foundation

class UserLogin {
    var UserName:String;
    var Password:String;
    
    init(userName:String, password:String){
        self.UserName = userName;
        self.Password = password;
    }
    
    func emptyInputUsername() -> Bool{
        if self.UserName == ""{
            return true;
        }else{
            return false;
        }
    }
    
    func emptyInputPassword() -> Bool{
        if self.Password == ""{
            return true;
        }else{
            return false;
        }
    }
    
    func login() -> Bool{
        return true;
    }
}