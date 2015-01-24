//
//  UserAPI.swift
//  CarParkApplication
//
//  Created by DavidMcQueen on 31/12/2014.
//  Copyright (c) 2014 DavidMcQueen. All rights reserved.
//

import Foundation

func loginUser(user: UserLogin, loginCompleted: (success: Bool, token: String?, error:String?) -> ()) -> (){
    println("login")
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
    request.addValue("application/json", forHTTPHeaderField: "Accept");
    
    
    var loginResponse = urlSession.dataTaskWithRequest(request, completionHandler: { data, response, error -> Void in
        
        var err: NSError?
        var success:Bool = false;
        var token:String?;
        
        if (error != nil) {
            println(error.localizedDescription);
            errorResponse = error.localizedDescription;
        }
        
        var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
        
        if (err != nil){
            println("JSON Error \(err!.localizedDescription) ");
            errorResponse = err!.localizedDescription;
        }
        
        
        if let responseToken: AnyObject = jsonResult["Token"]{
            token = responseToken as? String;
            
            if (validateGUID(token!)){
                success = true;
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
    request.addValue("application/json", forHTTPHeaderField: "Accept");
    
    var registerResponse = urlSession.dataTaskWithRequest(request, completionHandler: { data, response, error -> Void in
        
        var err: NSError?
        var token:String?;
        
        println(response);
        var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
        var success = false;
        
        
        if (error != nil) {
            println(error.localizedDescription);
            errorResponse = error.localizedDescription;
        }
        var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
        
        if (err != nil){
            println("JSON Error \(err!.localizedDescription) ");
            errorResponse = err!.localizedDescription;
        }
        
        
        if let responseToken: AnyObject = jsonResult["Token"]{
            token = responseToken as? String;
            
            if (validateGUID(token!)){
                success = true;
            }
        }
        
        registerCompleted(success: success, token: token!, error: errorResponse);
    });
    
    registerResponse.resume();
}

func getAllParkingSessions(token: String, requestCompleted: (success: Bool, session: [ParkSession], error: String?) -> ()) -> (){
    
    println("All parking sessions")
        let url = NSURL(string:"http://projectthird.ddns.net:8181/WebAPI/webapi/park?Token=\(token)");
        let urlSession = NSURLSession.sharedSession();
        var sessions: [ParkSession] = []
        
        let jsonResponse = urlSession.dataTaskWithURL(url!, completionHandler: { data, response, error -> Void in
            
            var success = false;
            var errorResponse: String?;
            
            if (error != nil) {
                println(error.localizedDescription);
            }
            var err: NSError?
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding);
            var jsonResult : NSArray = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSArray
            
            if (err != nil){
                println("JSON Error \(err!.localizedDescription) ");
            }
            
                for session in jsonResult{
                    if let errorMessage: AnyObject = session["Error"]!{
                        println(errorMessage);
                        errorResponse = errorMessage as? String;
                    }
                    let sessionID: AnyObject? = session["ParkingTransactionID"]!
                    let sessionVehicleID: AnyObject?  = session["UserVehicleID"]!
                    let sessionCarParkID: AnyObject?  = session["CarParkID"]!
                    let sessionStartTime: AnyObject?  = session["StartTime"]!
                    let sessionEndTime: AnyObject?  = session["FinishTime"]!
                    let sessionValue: AnyObject?  = session["Value"]!
                    
                    if(sessionEndTime == nil){
                        let newSession = ParkSession(
                            parkSessionID: (sessionID!.description).toInt()!,
                            carParkID: (sessionCarParkID!.description).toInt()!,
                            startTime: sessionStartTime!.description!,
                            currentSession: true,
                            parkedVehicleID: (sessionVehicleID!.description).toInt()!);
                        
                        sessions.append(newSession);
                    }else{
                        let newSession = ParkSession(
                            parkSessionID: (sessionID!.description).toInt()!,
                            carParkID: (sessionCarParkID!.description).toInt()!,
                            startTime: sessionStartTime!.description!,
                            endTimeParking: sessionEndTime!.description!,
                            currentSession: false,
                            parkedVehicleID: (sessionVehicleID!.description).toInt()!,
                            value: (sessionValue!.description! as NSString).doubleValue);
                        
                        sessions.append(newSession);
                    }
                    
                    
                    
                    
                }
                success = true;
            requestCompleted(success: success, session: sessions, error: errorResponse);
        });
        
    jsonResponse.resume();
    
}


//MARK:- createVehicle
func createVehicle(token: String, newVehicle: Vehicle, vehicleCreated: (success: Bool, createdVehicle: Vehicle, error: String?) -> ()) -> (){
    
    println("Create Vehicle")
    //Pass the user details to the server, to register
    
    //TODO:- Handle failure reponse / unknown failure
    
    //TODO:- After the user has registered / added a new vehicle the Singleton needs updating!
    
    let urlSession = NSURLSession.sharedSession();
    
    let url = NSURL(string:"http://projectthird.ddns.net:8181/WebAPI/webapi/vehicle");
    var request = NSMutableURLRequest(URL: url!);
    
    var error1 : NSError?;
    var errorResponse: String?;
    
    request.HTTPMethod = "POST";
    var params: Dictionary<String, String> = ([
        "Token" : token,
        "Registration" : newVehicle.RegistrationNumber,
        "Make" : newVehicle.Make,
        "Model" : newVehicle.Model,
        "Colour" : newVehicle.Colour
        ]);
    
    request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &error1);
    request.addValue("application/json", forHTTPHeaderField: "Content-Type");
    request.addValue("application/json", forHTTPHeaderField: "Accept");
    
    
    var createVehicleResponse = urlSession.dataTaskWithRequest(request, completionHandler: { data, response, error -> Void in
        
        var err: NSError?
        var success:Bool = false;
        var token:String?;
        
        if (error != nil) {
            println(error.localizedDescription);
            errorResponse = error.localizedDescription;
        }
        
        var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
        
        
        if (err != nil){
            println("JSON Error \(err!.localizedDescription) ");
            errorResponse = err!.localizedDescription;
        }
        
        
        if let newVehicleID: AnyObject = jsonResult["UserVehicleID"]{
            success = true;
            newVehicle.VehicleID = newVehicleID as? Int;
        }
        
        vehicleCreated(success: success, createdVehicle: newVehicle, error: errorResponse);
    });
    
    createVehicleResponse.resume();
}


func getAllUserVehicles(token: String, requestCompleted: (success: Bool, vehicles: [Vehicle], error: String?) -> ()) -> (){
    
    println("All user vehicles")
    let url = NSURL(string:"http://projectthird.ddns.net:8181/WebAPI/webapi/vehicle?Token=\(token)");
    let urlSession = NSURLSession.sharedSession();
    var vehicles: [Vehicle] = []
    
    let jsonResponse = urlSession.dataTaskWithURL(url!, completionHandler: { data, response, error -> Void in
        
        var success = false;
        var errorResponse: String?;
        
        if (error != nil) {
            println(error.localizedDescription);
        }
        var err: NSError?
        var strData = NSString(data: data, encoding: NSUTF8StringEncoding);
        var jsonResult : NSArray = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSArray
    
        if (err != nil){
            println("JSON Error \(err!.localizedDescription) ");
        }
        
        for vehicle in jsonResult{
            if let errorMessage: AnyObject = vehicle["Error"]!{
                println(errorMessage);
                errorResponse = errorMessage as? String;
            }
            let userVehicleID: AnyObject? = vehicle["UserVehicleID"]!
            let vehicleRegistration: AnyObject?  = vehicle["Registration"]!
            let vehicleModel: AnyObject?  = vehicle["Model"]!
            let vehicleMake: AnyObject?  = vehicle["Make"]!
            let vehicleColour: AnyObject?  = vehicle["Colour"]!
            
            //TODO:- Get the vehicle information back from the server
            //Or can link to the known vehicles on the user account?
            let vehicle = Vehicle(make: vehicleMake!.description, model: vehicleModel!.description, colour: vehicleColour!.description, registrationNumber: vehicleRegistration!.description, vehicleID: (userVehicleID!.description).toInt()!);
            
            vehicles.append(vehicle);
        }
        success = true;
        
        
        requestCompleted(success: success, vehicles: vehicles, error: errorResponse);
    });
    
    jsonResponse.resume();
    
}


func userBalance(token: String, requestCompleted: (success: Bool, balance: Double?, error: String?) -> ()) -> (){

    println("User balance")
    let url = NSURL(string:"http://projectthird.ddns.net:8181/WebAPI/webapi/balance?Token=\(token)");
    let urlSession = NSURLSession.sharedSession();
    var newBalance: Double?;
    
    let jsonResponse = urlSession.dataTaskWithURL(url!, completionHandler: { data, response, error -> Void in
        
        var success = false;
        var errorResponse: String?;
        
        if (error != nil) {
            println(error.localizedDescription);
        }
        var err: NSError?
        var strData = NSString(data: data, encoding: NSUTF8StringEncoding);
        var jsonResult : NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
        if (err != nil){
            println("JSON Error \(err!.localizedDescription) ");
        }
        
        if let errorMessage: AnyObject = jsonResult["Error"]{
            println(errorMessage);
            errorResponse = errorMessage as? String;
        }else{
            let balance: AnyObject? = jsonResult["Balance"]!
            newBalance = (balance!.description as NSString).doubleValue;
                
            success = true;
        }
        
        requestCompleted(success: success, balance: newBalance, error: errorResponse);
    });
    
    jsonResponse.resume();
}


func userAddFunds(token: String, paypalTransactionID: String, requestCompleted: (success: Bool, balance: Double?, error: String?) -> ()) -> (){
    
    let urlSession = NSURLSession.sharedSession();
    
    let url = NSURL(string:"http://projectthird.ddns.net:8181/WebAPI/webapi/balance");
    var request = NSMutableURLRequest(URL: url!);
    
    var error1 : NSError?;
    var errorResponse: String?;
    
    request.HTTPMethod = "POST";
    var params: Dictionary<String, String> = ([
        "Token" : token,
        "PaymentID" : paypalTransactionID
        ]);
    
    request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &error1);
    request.addValue("application/json", forHTTPHeaderField: "Content-Type");
    request.addValue("application/json", forHTTPHeaderField: "Accept");
    
    
    var createVehicleResponse = urlSession.dataTaskWithRequest(request, completionHandler: { data, response, error -> Void in
        
        var err: NSError?
        var success:Bool = false;
        var userBalance: Double?;
        
        if (error != nil) {
            println(error.localizedDescription);
            errorResponse = error.localizedDescription;
        }
        
        var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
        
        
        if (err != nil){
            println("JSON Error \(err!.localizedDescription) ");
            errorResponse = err!.localizedDescription;
        }
        
        
        if let newVehicleID: AnyObject = jsonResult["Balance"]{
            success = true;
            userBalance = newVehicleID as? Double;
        }
        
        requestCompleted(success: success, balance: userBalance, error: errorResponse);
    });
    
    createVehicleResponse.resume();

    
}

