//
//  UserAPI.swift
//  CarParkApplication
//
//  Created by DavidMcQueen on 31/12/2014.
//  Copyright (c) 2014 DavidMcQueen. All rights reserved.
//

import Foundation

func loginUser(user: UserLogin, loginCompleted: (success: Bool, token: String?, error:String?) -> ()) -> (){
    //Pass the user details to the server, to register
    
    //TODO:- Handle failure reponse / unknown failure
    
    //TODO:- After the user has registered / added a new vehicle the Singleton needs updating!
    
    let urlSession = NSURLSession.sharedSession();
    
    let url = NSURL(string:"http://projectthird.ddns.net:8181/WebAPI/webapi/login");
    var request = NSMutableURLRequest(URL: url!);
    
    var error1 : NSError?;
    var errorResponse: String?;
    
    request.HTTPMethod = "POST";
    var params: Dictionary<String, String> = ([
        "Email" : user.UserName,
        "Password" : user.Password
        ]);
    
    request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &error1);
    request.addValue("application/json", forHTTPHeaderField: "Content-Type");
    request.addValue("text/plain", forHTTPHeaderField: "Accept");
    
    
    var loginResponse = urlSession.dataTaskWithRequest(request, completionHandler: { data, response, error -> Void in
        
        var strData = NSString(data: data, encoding: NSUTF8StringEncoding);
        var success:Bool = false;
        var token:String?;
        
        if (error != nil) {
            println(error.localizedDescription);
            errorResponse = error.localizedDescription;
        }
        
        if (strData != nil){
            if (validateGUID(strData!.description)){
                token = strData!.description;
                success = true;
            }else{
                errorResponse = strData!.description;
            }
        }
        
        loginCompleted(success: success, token: token, error: errorResponse);
    });
    
    loginResponse.resume();
    
}

func registerUser(newUser: UserRegistration, registerCompleted: (success: Bool, token: String, error: String?) -> ()) -> (){
    //Pass the user details to the server, to register
    //TODO:- Handle failure reponse / unknown failure
    
    let urlSession = NSURLSession.sharedSession();
    
    let url = NSURL(string:"http://projectthird.ddns.net:8181/WebAPI/webapi/register");
    var request = NSMutableURLRequest(URL: url!);
    
    var error1 : NSError?;
    var errorResponse: String?;
    request.HTTPMethod = "POST";
    var params: Dictionary<String, String> = ([
        "Forename" : newUser.FirstName,
        "Surname" : newUser.SurName,
        "Email" : newUser.Email,
        "PhoneNumber" : newUser.PhoneNumber,
        "Password" : newUser.Password
        ]);
    
    request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &error1);
    request.addValue("application/json", forHTTPHeaderField: "Content-Type");
    request.addValue("text/plain", forHTTPHeaderField: "Accept");
    
    var registerResponse = urlSession.dataTaskWithRequest(request, completionHandler: { data, response, error -> Void in
        
        println(response);
        var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
        var success = false;
        
        println(strData);
        
        if (error != nil) {
            println(error.localizedDescription);
            errorResponse = error.localizedDescription;
        }
        //            var err: NSError?
        
        //Parse the resonse into JSON
        //var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
        
        //            if (err != nil){
        //                println("JSON Error \(err!.localizedDescription) ");
        //            }
        
        var token:String?;
        //TODO:- CHeck of the response contains an error message
        if (strData != nil){
            if (validateGUID(strData!.description)){
                token = strData!.description;
                success = true;
            }
        }
        
        registerCompleted(success: success, token: token!, error: errorResponse);
    });
    
    registerResponse.resume();
}


