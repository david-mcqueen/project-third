//
//  CarParkAPI.swift
//  CarParkApplication
//
//  Created by DavidMcQueen on 04/01/2015.
//  Copyright (c) 2015 DavidMcQueen. All rights reserved.
//

import Foundation

func determineCarPark(token: String, identifier: String, requestCompleted: (success: Bool, carParkID: Int, carParkName: String, error: String?) -> ()) -> (){
    
    let url = NSURL(string:"http://projectthird.ddns.net:8181/WebAPI/webapi/determineCarpark?Token=\(token)&Identifier=\(identifier)");
    let urlSession = NSURLSession.sharedSession();
    
    let jsonResponse = urlSession.dataTaskWithURL(url!, completionHandler: { data, response, error -> Void in
        
        var carParkName: String?;
        var carParkID: Int?;
        var success = false;
        var errorResponse: String?;
        
        if (error != nil) {
            println(error.localizedDescription);
        }
        var err: NSError?
        
        if var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as? NSDictionary{
            if (err != nil){
                println("JSON Error \(err!.localizedDescription) ");
            }
            
            if let dataError: AnyObject = jsonResult["Error"]{
                println(dataError);
                errorResponse = dataError as? String;
            }else{
                if let parkID: AnyObject = jsonResult["CarParkID"]{
                    
                    carParkID = parkID as? Int
                    success = true;
                }
                if let parkName: AnyObject = jsonResult["Name"]{
                    
                    carParkName = parkName as? String
                    success = true;
                }
            }
            
            
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding);
        }else{
            errorResponse = "Server Error"
        }
        
        requestCompleted(success: success, carParkID: carParkID!, carParkName: carParkName!, error: errorResponse);
    });
    
    jsonResponse.resume();
}

func parkVehicle(token: String, carParkID: Int, vehicleID: Int, parkBandID: Int, parkCompleted: (success: Bool, parkTransactionID: Int?, parkFinished: Bool?, parkCost: Double?, error: String?) -> ()) -> (){
    let url = NSURL(string:"http://projectthird.ddns.net:8181/WebAPI/webapi/park");
    let urlSession = NSURLSession.sharedSession();

    var request = NSMutableURLRequest(URL: url!);
    
    var error1 : NSError?;
    var errorResponse: String?;
    request.HTTPMethod = "POST";
    var params: Dictionary<String, AnyObject>
    
    if (parkBandID == -1){
        params = ([
            "Token" : token,
            "CarParkID" : carParkID,
            "UserVehicleID" : vehicleID
            ]);
    }else{
         params = ([
            "Token" : token,
            "CarParkID" : carParkID,
            "UserVehicleID" : vehicleID,
            "CarParkCostID" : "\(parkBandID)"
            ]);
    }
    
    request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &error1);
    request.addValue("application/json", forHTTPHeaderField: "Content-Type");
    request.addValue("application/json", forHTTPHeaderField: "Accept");

    
    var parkVehicleResponse = urlSession.dataTaskWithRequest(request, completionHandler: { data, response, error -> Void in
        
        var err: NSError?
        var parkTransaction:Int?;
        var sessionCost: Double?;
        var sessionFinishTime: NSDate?;
        var sessionFinished: Bool?;
        var success = false;
        var dateFormatter = NSDateFormatter();
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        
        if (error != nil) {
            println(error.localizedDescription);
            errorResponse = error.localizedDescription;
        }
        var strData = NSString(data: data, encoding: NSUTF8StringEncoding);
        println(strData)
        if var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as? NSDictionary{
            println(jsonResult);
            if (err != nil){
                println("JSON Error \(err!.localizedDescription) ");
                errorResponse = err!.localizedDescription;
            }
            
            if let dataError: AnyObject = jsonResult["Error"]{
                println(dataError);
                errorResponse = dataError as? String;
            }else if let parkID: AnyObject = jsonResult["ParkTransactionID"]{
                parkTransaction = parkID as? Int
                
                if let finished: AnyObject = jsonResult["Finished"]{
                    sessionFinished = finished as? Bool;
                }
                if let cost: AnyObject = jsonResult["Cost"]{
                    sessionCost = cost as? Double;
                }
                
                success = true;
            }
        }else{
            errorResponse = "Server Error"
        }
        
        parkCompleted(success: success, parkTransactionID: parkTransaction, parkFinished:sessionFinished, parkCost: sessionCost, error: errorResponse);
    });
    
    parkVehicleResponse.resume();

}

func stopParking(token: String, parkTransactionID: Int, endParkComplete: (success: Bool, value: Double?, error: String?) -> ()) -> (){
    let url = NSURL(string:"http://projectthird.ddns.net:8181/WebAPI/webapi/park/end");
    let urlSession = NSURLSession.sharedSession();
    
    var request = NSMutableURLRequest(URL: url!);
    
    var error1 : NSError?;
    var errorResponse: String?;
    request.HTTPMethod = "POST";
    var params: Dictionary<String, AnyObject> = ([
        "Token" : token,
        "ParkTransactionID" : parkTransactionID,
        ]);
    
    println(params);
    request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &error1);
    request.addValue("application/json", forHTTPHeaderField: "Content-Type");
    request.addValue("application/json", forHTTPHeaderField: "Accept");
    
    
    var parkVehicleResponse = urlSession.dataTaskWithRequest(request, completionHandler: { data, response, error -> Void in
        
        var err: NSError?
        var parkTransactionValue:Double?;
        
        var success = false;
        
        
        if (error != nil) {
            println(error.localizedDescription);
            errorResponse = error.localizedDescription;
        }
        
        if var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as? NSDictionary{
            println(jsonResult);
            if (err != nil){
                println("JSON Error \(err!.localizedDescription) ");
                errorResponse = err!.localizedDescription;
            }
            
            if let dataError: AnyObject = jsonResult["Error"]{
                println(dataError);
                errorResponse = dataError as? String;
            }else if let parkID: AnyObject = jsonResult["Value"]{
                
                parkTransactionValue = parkID as? Double
                success = true;
            }
            println(parkTransactionValue);
        }else{
            errorResponse = "Server Error"
        }
        
        
        endParkComplete(success: success, value: parkTransactionValue, error: errorResponse);
    });
    
    parkVehicleResponse.resume();
    
}


func getCarParkParkingBands(token: String, carParkID: Int, requestCompleted: (success: Bool, allPricingBands: [PricingBand], error: String?) -> ()) -> (){
    
    let url = NSURL(string:"http://projectthird.ddns.net:8181/WebAPI/webapi/carpark/cost?Token=\(token)&CarParkID=\(carParkID)");
    let urlSession = NSURLSession.sharedSession();
    
    let jsonResponse = urlSession.dataTaskWithURL(url!, completionHandler: { data, response, error -> Void in
        
        var carParkName: String?;
        var success = false;
        var errorResponse: String?;
        var pricingBands: [PricingBand] = [];
        
        if (error != nil) {
            println(error.localizedDescription);
        }
        var err: NSError?
        
        var strData = NSString(data: data, encoding: NSUTF8StringEncoding);
        if var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as? NSArray{
            if (err != nil){
                println("JSON Error \(err!.localizedDescription) ");
            }
            
            println(jsonResult);
            
            for band in jsonResult{
                if let errorMessage: AnyObject = band["Error"]!{
                    println(errorMessage);
                    errorResponse = errorMessage as? String;
                }
                let bandID: AnyObject? = band["CarParkCostID"]!
                let bandMinimum: AnyObject?  = band["MinimumTime"]!
                let bandMaximum: AnyObject?  = band["MaximumTime"]!
                let bandDay: AnyObject?  = band["Day"]!
                let bandCost: AnyObject?  = band["Cost"]!
                
                
                let newPricingBand = PricingBand(
                    _carParkID: carParkID,
                    _bandID: (bandID!.description).toInt()!,
                    _minimum: (bandMinimum!.description).toInt()!,
                    _maximum: (bandMaximum!.description).toInt()!,
                    _cost: (bandCost!.description as NSString).doubleValue,
                    _day: (bandDay!.description).toInt()!
                );
                println(newPricingBand);
                pricingBands.append(newPricingBand);
            }
            success = true;
        }else{
            errorResponse = "Server Error"
        }
        
        requestCompleted(success: success, allPricingBands: pricingBands, error: errorResponse);
    });
    
    jsonResponse.resume();
    
}



func searchCarParks(token: String, lat:String, long:String, searchComplete: (success: Bool, returnedCarParks: [CarPark], error: String?) -> ()) -> (){
    
    println("All user vehicles")
    let url = NSURL(string:"http://projectthird.ddns.net:8181/WebAPI/webapi/carpark/search?Token=\(token)&Latitude=\(lat)&Longitude=\(long)");
    let urlSession = NSURLSession.sharedSession();
    var carParks: [CarPark] = []
    
    let jsonResponse = urlSession.dataTaskWithURL(url!, completionHandler: { data, response, error -> Void in
        
        var success = false;
        var errorResponse: String?;
        
        if (error != nil) {
            println(error.localizedDescription);
        }
        var err: NSError?
        var strData = NSString(data: data, encoding: NSUTF8StringEncoding);
        if var jsonResult : NSArray = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSArray{
            if (err != nil){
                println("JSON Error \(err!.localizedDescription) ");
            }
            
            println(jsonResult);
            
            for carPark in jsonResult{
                if let errorMessage: AnyObject = carPark["Error"]!{
                    println(errorMessage);
                    errorResponse = errorMessage as? String;
                }
                let carParkID: AnyObject? = carPark["CarParkID"]!
                let carParkName: AnyObject?  = carPark["Name"]!
                let carParkLat: AnyObject?  = carPark["Latitude"]!
                let carParkLong: AnyObject?  = carPark["Longitude"]!
                let carParkDistance: AnyObject?  = carPark["Distance"]!
                let carParkOpen: AnyObject? = carPark["OpenTime"];
                let carParkClose: AnyObject? = carPark["CloseTime"];

                
                let newCarPark = CarPark(_id:
                    (carParkID!.description).toInt()!,
                    _name: carParkName!.description,
                    _lat: carParkLat!.description,
                    _long: carParkLong!.description,
                    _distance: ((carParkDistance!.description) as NSString).doubleValue,
                    _open: carParkOpen?.description,
                    _close: carParkClose?.description
                );
                println(newCarPark);
                carParks.append(newCarPark);
            }
            success = true;
        }else{
            errorResponse = "Server Error"
        }
        
        searchComplete(success: success, returnedCarParks: carParks, error: errorResponse);
    });
    
    jsonResponse.resume();
    
}



func extendParkingSession(token: String, parkTransactionID:Int, bandID:Int, extendComplete: (success: Bool, newFinishTime: String?, newCost: Double?, error: String?) -> ()) -> (){
    
    
    let urlSession = NSURLSession.sharedSession();
    
    let url = NSURL(string:"http://projectthird.ddns.net:8181/WebAPI/webapi/park/extend");
    var request = NSMutableURLRequest(URL: url!);
    
    
    var error1 : NSError?;
    var errorResponse: String?;
    request.HTTPMethod = "POST";
    var params: Dictionary<String, String> = ([
        "Token" : token,
        "ParkTransactionID" : String(parkTransactionID),
        "CarParkCostID": String(bandID)
        ]);
    
    request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &error1);
    request.addValue("application/json", forHTTPHeaderField: "Content-Type");
    request.addValue("application/json", forHTTPHeaderField: "Accept");
    
    var extendResponse = urlSession.dataTaskWithRequest(request, completionHandler: { data, response, error -> Void in
        
        var err: NSError?
        var token:String?;
        var finishTime: String?;
        var cost: Double?
        
        var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
        var success = false;
        println(strData)
        
        if (error != nil) {
            println(error.localizedDescription);
            errorResponse = error.localizedDescription;
        }
        if var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as? NSDictionary{
            if (err != nil){
                println("JSON Error \(err!.localizedDescription) ");
                errorResponse = err!.localizedDescription;
            }
            
            
            if let newFinishTime: AnyObject = jsonResult["FinishTime"]{
   
                finishTime = newFinishTime.description!;
                if let newCost: AnyObject = jsonResult["Cost"]{
                    
                    cost = (newCost.description as NSString).doubleValue;
                    success = true;
                }
            }
            
        }else{
            errorResponse = "Server Error"
        }
        
        extendComplete(success: success, newFinishTime: finishTime, newCost: cost, error: errorResponse);
    });
    
    extendResponse.resume();
    
}
