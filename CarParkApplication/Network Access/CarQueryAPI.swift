//
//  CarQueryAPI.swift
//  CarParkApplication
//
//  Created by DavidMcQueen on 31/12/2014.
//  Copyright (c) 2014 DavidMcQueen. All rights reserved.
//

/*
//  External communication with www.carqueryapi.com
//  Used to provide a list of Vehicle Makes and Models
//  Classes: CarMake, CarModel
*/

import Foundation



//MARK:- Get Vehicle Makes
func getMakes(requestCompleted: (success: Bool, vehicleMakes: [CarMake], serverError:NSError?, JSONerror: NSError?) -> ()) -> (){
    
    let url = NSURL(string:"http://www.carqueryapi.com/api/0.3/?cmd=getMakes");
    let urlSession = NSURLSession.sharedSession();
    
    let jsonMakeResponse = urlSession.dataTaskWithURL(url!, completionHandler: { data, response, error -> Void in
        var jsonerr: NSError?;
        var makes: [CarMake] = [];
        var _success: Bool = false;
        
        if var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &jsonerr) as? NSDictionary{
            if let vehicleMakeArray = jsonResult["Makes"] as? NSArray{
                for make in vehicleMakeArray {
                    let carCountry: AnyObject? = make["make_display"]!;
                    let carDisplay: AnyObject?  = make["make_display"]!;
                    let carID: AnyObject?  = make["make_id"]!;
                    let carCommon: AnyObject?  = make["make_is_common"]!;
                    
                    let newCar = CarMake(_make_country: carCountry!.description, _make_display: carDisplay!.description, _make_id: carID!.description, _make_is_common: carCommon!.description);
                    
                    makes.append(newCar);
                }
                _success = true;
            }

        }else{
            NSLog("Server Error")
        }
        
        
        requestCompleted(success: _success, vehicleMakes: makes, serverError: error, JSONerror: jsonerr);
    });
    
    jsonMakeResponse.resume();
}



//MARK:- Get Models for specific make
func getModels(modelID: String, requestModelsCompleted: (success: Bool, vehicleModels: [CarModel], serverError:NSError?, JSONerror: NSError?) -> ()) -> (){
    //Pass the user details to the server, to register
    
    let url = NSURL(string:"http://www.carqueryapi.com/api/0.3/?cmd=getModels&make=\(modelID)");
    let urlSession = NSURLSession.sharedSession();
    
    
    let jsonModelResponse = urlSession.dataTaskWithURL(url!, completionHandler: { data, response, error -> Void in
        var jsonerr: NSError?;
        var models: [CarModel] = [];
        var _success: Bool = false;

        
        if var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &jsonerr) as? NSDictionary{
            if let vehicleModelArray = jsonResult["Models"] as? NSArray{
                for model in vehicleModelArray {
                    let modelname: AnyObject? = model["model_name"]!;
                    let modelID: AnyObject?  = model["model_make_id"]!;
                    
                    let newCar = CarModel(_model_name: modelname!.description, _model_make_id: modelID!.description);
                    
                    models.append(newCar);
                }
                _success = true;
            }
        }else{
            NSLog("Server Error")
        }
        
        
        requestModelsCompleted(success: _success, vehicleModels: models, serverError: error, JSONerror: jsonerr);
    });
    
    jsonModelResponse.resume();
}