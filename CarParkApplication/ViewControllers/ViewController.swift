//
//  ViewController.swift
//  CarParkApplication
//
//  Created by DavidMcQueen on 05/10/2014.
//  Copyright (c) 2014 DavidMcQueen. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UITableViewController, UITableViewDelegate, CLLocationManagerDelegate {

    @IBOutlet var locationLabel: UILabel!
    let locationManager = CLLocationManager();
    let region = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "EBEFD083-70A2-47C8-9837-E7B5634DF524"), identifier: "CarPark");
    
    
    @IBOutlet var toggleMethod: UISwitch!
    
    @IBAction func toggleMethodPressed(sender: AnyObject) {
        //Reload all of the table data
        self.tableView.reloadData();
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self;
        
        //Request permission to access beacons - Whilst the app is in Foreground
        if(CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedWhenInUse){
            locationManager.requestWhenInUseAuthorization();
        }
        
        
        //TODO:- Handle the user denying the location request

    }
    
//    @IBAction func determineLocation(sender: AnyObject) {
//        //Start looking for beacons so long as we have permission
//        if(CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse){
//            //Start looks for regions
//            NSLog("Start monitoring for regions");
//            locationManager.startRangingBeaconsInRegion(region);
//        }
//    }
    
//    @IBAction func findCarParkButton(sender: AnyObject) {
//        //Start looking for beacons so long as we have permission
//        if(CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse){
//            //Start looks for regions
//            NSLog("Start monitoring for regions");
//            locationManager.startRangingBeaconsInRegion(region);
//        }
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getBeaconDetails(major: Int, minor: Int, rssi: Int){
        var locationName: String;
        
        //The beacon ID needs to be in the format stored on the server.
        var beacon = String(major) + "." + String(minor);
        
        //TODO:- Remove this hardcode beacon value
        beacon = "1.1";
        
        //Get the session token, saved from the last login.
        let savedToken: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("token")!;
        
        
        determineCarPark(savedToken.description, beacon, {(success: Bool, carPark: String) -> () in
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
                let carParkName = "Manchester Oxford Road"
                self.locationLabel.text = "\(carPark): \(carParkName)";
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
            //TODO:- Only turn of beacon ranging, when the server has returned a car park ID?
            //TODO:- Or keep sending the same ID until a response is retunred?
        }
        
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 1 && toggleMethod.on){
            //Set the header & footer heights to 0
            self.tableView.sectionHeaderHeight = 0;
            return 0;
        } else if(section == 2 && !toggleMethod.on){
            //Set the header & footer heights to 0
            self.tableView.sectionHeaderHeight = 0;
            return 0;
        } else {
            return super.tableView(tableView, heightForHeaderInSection: section);
        }  //keeps inalterate all other Header
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if(section == 1 && toggleMethod.on){
            //Set the header & footer heights to 0
            self.tableView.sectionFooterHeight = 0;
            return 0;
        } else if(section == 2 && !toggleMethod.on) {
            //Set the header & footer heights to 0
            self.tableView.sectionFooterHeight = 0;
            return 0;
        } else {
            return super.tableView(tableView, heightForFooterInSection: section)
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 1 || section == 2) //Index number of interested section
        {
            if(toggleMethod.on && section == 1){
                return 0;
            } else if(!toggleMethod.on && section == 2){
                return 0;
            } else{
                return 3; //The number of rows in the section
            }
            
        }else{
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
}

