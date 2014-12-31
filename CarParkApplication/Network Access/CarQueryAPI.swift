//
//  CarQueryAPI.swift
//  CarParkApplication
//
//  Created by DavidMcQueen on 31/12/2014.
//  Copyright (c) 2014 DavidMcQueen. All rights reserved.
//

import Foundation

//MARK:- Get Vehicle Makes
func getMakes(requestCompleted: (success: Bool, vehicleMakes: [CarMake]) -> ()) -> (){
    //Pass the user details to the server, to register
    
    let url = NSURL(string:"http://www.carqueryapi.com/api/0.3/?cmd=getMakes");
    let urlSession = NSURLSession.sharedSession();
    
    
    let jsonResponse = urlSession.dataTaskWithURL(url!, completionHandler: { data, response, error -> Void in
        if (error != nil) {
            println(error.localizedDescription);
        }
        var err: NSError?
        
        var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
        if (err != nil){
            println("JSON Error \(err!.localizedDescription) ");
        }
        
        var makes: [CarMake] = [];
        
        if let vehicleMakeArray = jsonResult["Makes"] as? NSArray{
            println(vehicleMakeArray);
            for make in vehicleMakeArray {
                let carCountry: AnyObject? = make["make_display"]!
                let carDisplay: AnyObject?  = make["make_display"]!
                let carID: AnyObject?  = make["make_id"]!
                let carCommon: AnyObject?  = make["make_is_common"]!
                
                let newCar = CarMake(_make_country: carCountry!, _make_display: carDisplay!, _make_id: carID!, _make_is_common: carCommon!)
                
                makes.append(newCar);
            }
        }
        
        requestCompleted(success: true, vehicleMakes: makes);
    });
    
    jsonResponse.resume();
}

//MARK:- Get Models for specific make
func getModels(modelID: String, requestModelsCompleted: (success: Bool, vehicleModels: [CarModel]) -> ()) -> (){
    //Pass the user details to the server, to register
    
    let url = NSURL(string:"http://www.carqueryapi.com/api/0.3/?cmd=getModels&make=\(modelID)");
    let urlSession = NSURLSession.sharedSession();
    
    
    let jsonResponse = urlSession.dataTaskWithURL(url!, completionHandler: { data, response, error -> Void in
        if (error != nil) {
            println(error.localizedDescription);
        }
        var err: NSError?
        
        var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
        if (err != nil){
            println("JSON Error \(err!.localizedDescription) ");
        }
        
        var models: [CarModel] = [];
        
        if let vehicleModelArray = jsonResult["Models"] as? NSArray{
            println(vehicleModelArray);
            for model in vehicleModelArray {
                let modelname: AnyObject? = model["model_name"]!
                let modelID: AnyObject?  = model["model_make_id"]!
                
                let newCar = CarModel(_model_name: modelname!, _model_make_id: modelID!);
                
                models.append(newCar);
            }
        }
        
        requestModelsCompleted(success: true, vehicleModels: models);
    });
    
    jsonResponse.resume();
}