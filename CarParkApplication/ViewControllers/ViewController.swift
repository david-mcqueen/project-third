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
    var beaconActivityIndicator : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 100, 100)) as UIActivityIndicatorView
    

    @IBOutlet var timeBandLabel: UILabel!
    @IBOutlet var vehicleLabel: UILabel!
    var selectedVehicle:String = ""
    var selectedTimeBand: String = "2 hours"
    
    @IBOutlet var toggleMethod: UISwitch!
    
    @IBAction func toggleMethodPressed(sender: AnyObject) {
        //Reload all of the table data
        self.tableView.reloadData();
    }
    
    @IBAction func parkPressed(sender: AnyObject) {
        println("park the vehicle");
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var firstVehicle = User.sharedInstance.getFirstVehicle();
        selectedVehicle = ("\(firstVehicle.Make) \(firstVehicle.Model) (\(firstVehicle.RegistrationNumber))");
        User.sharedInstance.selectedVehicle = selectedVehicle;
        
        locationManager.delegate = self;
        vehicleLabel.text = selectedVehicle;
        
        //Request permission to access beacons - Whilst the app is in Foreground
        if(CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedWhenInUse){
            locationManager.requestWhenInUseAuthorization();
        }
        
        //TODO:- Handle the user denying the location request
        
        beaconActivityIndicator.center = self.view.center
        beaconActivityIndicator.hidesWhenStopped = true
        beaconActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        
        
        

    }
    
    @IBAction func determineLocation(sender: AnyObject) {
        //Start looking for beacons so long as we have permission
        if(CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse){
            //Start looks for regions
            NSLog("Start monitoring for regions");
            beaconActivityIndicator.startAnimating()
            locationManager.startRangingBeaconsInRegion(region);
        }
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
        println("getBeaconDetails")
        var locationName: String;
        
        //The beacon ID needs to be in the format stored on the server.
        var beacon = String(major) + "." + String(minor);
        
        //TODO:- Remove this hardcode beacon value
        beacon = "1.1";
        
        determineCarPark(User.sharedInstance.token!, beacon, {(success: Bool, carPark: String) -> () in
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
            println("Known Beacons \(knownBeacons)");
            let closestBeacon = knownBeacons[0] as CLBeacon;
            
            
            getBeaconDetails(closestBeacon.major.integerValue, minor: closestBeacon.minor.integerValue, rssi: closestBeacon.rssi);
            
            //We have found the closest beacon, stop ranging for new locations
            locationManager.stopRangingBeaconsInRegion(region);
            beaconActivityIndicator.stopAnimating();
            //TODO:- Only turn of beacon ranging, when the server has returned a car park ID?
            //TODO:- Or keep sending the same ID until a response is retunred?
        }
        
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 2 && toggleMethod.on){
            //Set the header & footer heights to 0
            self.tableView.sectionHeaderHeight = 0;
            return 0;
        } else {
            return super.tableView(tableView, heightForHeaderInSection: section);
        }  //keeps inalterate all other Header
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if(section == 2 && toggleMethod.on) {
            //Set the header & footer heights to 0
            self.tableView.sectionFooterHeight = 0;
            return 0;
        } else {
            return super.tableView(tableView, heightForFooterInSection: section)
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 2) //Index number of interested section
        {
            if(section == 2 && toggleMethod.on){
                return 0;
            } else  {
                return 1;
            }
            
        }else{
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PickTimeBand" {
            println("PickTimeBand Segue")
            let timeBandSelectViewController = segue.destinationViewController as TimeBandSelectViewController
            timeBandSelectViewController.selectedTimeBand = selectedTimeBand
        }
        
    }
    
    @IBAction func selectedTimeBandSave(segue:UIStoryboardSegue) {
        let timeBandSelectViewController = segue.sourceViewController as TimeBandSelectViewController
        if let _selectedTimeBand = timeBandSelectViewController.selectedTimeBand {
            timeBandLabel.text = _selectedTimeBand
            selectedTimeBand = _selectedTimeBand
            println("selected time band: \(selectedTimeBand)");
        }
        self.navigationController?.popViewControllerAnimated(true);
    }
    
    @IBAction func selectedVehicleSave(segue:UIStoryboardSegue) {
        let vehicleSelectViewController = segue.sourceViewController as VehicleSelectViewController
        if let _selectedVehicle = vehicleSelectViewController.selectedVehicle {
            vehicleLabel.text = _selectedVehicle
            selectedVehicle = _selectedVehicle
            User.sharedInstance.selectedVehicle = selectedVehicle
        }
        self.navigationController?.popViewControllerAnimated(true);
    }
    
    
}

