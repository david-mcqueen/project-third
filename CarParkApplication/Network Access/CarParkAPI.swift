//
//  CarParkAPI.swift
//  CarParkApplication
//
//  Created by DavidMcQueen on 04/01/2015.
//  Copyright (c) 2015 DavidMcQueen. All rights reserved.
//

import Foundation

func determineCarPark(token: String, identifier: String, requestCompleted: (success: Bool, carPark: String) -> ()) -> (){
    
    let url = NSURL(string:"http://projectthird.ddns.net:8181/WebAPI/webapi/determineCarpark?Token=\(token)&Identifier=\(identifier)");
    let urlSession = NSURLSession.sharedSession();
    
    let jsonResponse = urlSession.dataTaskWithURL(url!, completionHandler: { data, response, error -> Void in
        if (error != nil) {
            println(error.localizedDescription);
        }
        var err: NSError?
        
//        var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
//        if (err != nil){
//            println("JSON Error \(err!.localizedDescription) ");
//        }
        var strData = NSString(data: data, encoding: NSUTF8StringEncoding);
        requestCompleted(success: true, carPark: strData!);
    });
    
    jsonResponse.resume();
}