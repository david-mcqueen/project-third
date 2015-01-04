//
//  ViewController.swift
//  CarParkApplication
//
//  Created by DavidMcQueen on 05/10/2014.
//  Copyright (c) 2014 DavidMcQueen. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager();
    let region = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "EBEFD083-70A2-47C8-9837-E7B5634DF524"), identifier: "CarPark");
    
    @IBOutlet weak var beaonOutput: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self;
        
        //Request permission to access beacons - Whilst the app is in Foreground
        if(CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedWhenInUse){
            locationManager.requestWhenInUseAuthorization();
        }
        
        
        //TODO:- Handle the user denying the location request
    }
    
    @IBAction func findCarParkButton(sender: AnyObject) {
        //Start looking for beacons so long as we have permission
        if(CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse){
            //Start looks for regions
            NSLog("Start monitoring for regions");
            locationManager.startRangingBeaconsInRegion(region);
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getBeaconDetails(major: Int, minor: Int, rssi: Int){
        var locationName: String;
        
        
        //Will have to get the beacon details and match.
        //Either on the server or locally
        println(String(rssi));
        println(String(minor));
        println(String(major));
        var beacon = String(major) + "." + String(minor);
        beaonOutput.text = beacon;
        
        //TODO:- Pass through the correct session ID (Token)
        determineCarPark("c05afc84-9420-11e4-aa9b-001e8c3af66d", beacon, {(success: Bool, carPark: String) -> () in
            var alert = UIAlertView(title: "Success!", message: carPark, delegate: nil, cancelButtonTitle: "Okay.")
            if(success) {
                alert.title = "Success!"
                alert.message = carPark
            }
            else {
                alert.title = "Failed : ("
                alert.message = carPark
            }
            
            // Move to the UI thread
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                // Show the alert
                alert.show()
            });
            
            }
        );

    }

    
    func locationManager(manager: CLLocationManager!, rangingBeaconsDidFailForRegion region: CLBeaconRegion!, withError error: NSError!) {
        println("rangingDidFailForRegion");
        println(error.localizedDescription);
    }
    
    
    
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        //This is called when:
        // A new beacon is within range
        // A beacon goe out of range
        // A beacon gets closer / further away
        
        //the CLBeacon object (beacons) is an array of all beacons in region
        
        // Look on http://willd.me/posts/getting-started-with-ibeacon-a-swift-tutorial for more properties that can be accessed
        // Proximity / rssi / accuracy
        
        //Disregard beacons that are Unknown proximity
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.Unknown };
        

        if(knownBeacons.count > 0){
            println(knownBeacons);
            let closestBeacon = knownBeacons[0] as CLBeacon;
            
            
            getBeaconDetails(closestBeacon.major.integerValue, minor: closestBeacon.minor.integerValue, rssi: closestBeacon.rssi);
            
            //We have found the closest beacon, stop ranging for new locations
            locationManager.stopRangingBeaconsInRegion(region);
        }
        
    }
    
}

